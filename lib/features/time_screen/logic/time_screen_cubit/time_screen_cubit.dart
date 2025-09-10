import 'package:bloc/bloc.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:team_egypt_v3/core/models/reservation_model.dart';
import 'package:team_egypt_v3/core/utils/validators.dart';
import 'package:team_egypt_v3/features/dash_board/screens/days_data/data/supabase_days_data.dart';
import 'package:team_egypt_v3/features/dash_board/screens/partnerships_screen/data/supabase_partnership.dart';
import 'package:team_egypt_v3/features/dash_board/screens/rooms/data/supabase_reservations.dart';
import 'package:team_egypt_v3/features/time_screen/data/supabase_in_team.dart';
import 'package:team_egypt_v3/features/time_screen/data/supabase_rooms_data.dart';
part 'time_screen_state.dart';

class TimeScreenCubit extends Cubit<TimeScreenState> {
  double htotal = 0;
  TimeScreenCubit() : super(TimeScreenInitial());

  void getTotal() async {
    final double total = await SupabaseInTeam.getTotal(Validators.choosenDay);
    htotal = total;
    emit(GetTotal(total: total));
  }

  /// ✅ Upsert User
  void upsertUser(
    DateTime date, {
    required String number,
    required String name,
    required String collage,
    double? price,
    DateTime? checkoutTime,
    String? note,
    required String partnershipCode,
  }) async {
    final existingUsers = await SupabaseDaysData.getDayUsers(date);

    final userIndex = existingUsers.indexWhere(
      (user) => user['number'] == number,
    );

    String partnershipName = await SupabasePartnership.getPartnershipName(
      partnershipCode,
    );

    if (userIndex != -1) {
      existingUsers[userIndex] = {
        ...existingUsers[userIndex],
        if (price != null) 'price': price,
        if (checkoutTime != null)
          'checkoutTime': checkoutTime.toIso8601String(),
        'partnership_code': partnershipName,
        if (note != null) 'note': note,
      };
    } else {
      existingUsers.add({
        'name': name,
        'number': number,
        'collage': collage,
        'partnership_code': partnershipName,
        if (price != null) 'price': price,
        if (checkoutTime != null)
          'checkoutTime': checkoutTime.toIso8601String(),
        if (note != null) 'note': note else 'note': null,
      });
    }

    final total = existingUsers.fold<double>(
      0,
      (sum, user) => sum + (user['price'] ?? 0),
    );

    await SupabaseInTeam.updateDaysData(date, total, existingUsers);

    htotal = total;
    emit(GetTotal(total: total));
  }

  // ✅ NEW: Get all rooms for a day
  Future<void> getRooms(DateTime date) async {
    final rooms = await SupabaseRoomsData.getReservations(date);
    emit(
      RoomsDataLoaded(rooms.map((r) => r.toJson()).toList()),
    ); // keep JSON for UI
  }

  // ✅ Upsert room reservation
  Future<void> upsertRoom(DateTime date, ReservationModel reservation) async {
    final total = await SupabaseInTeam.getTotal(date);
    final newTotal = total + reservation.price;

    // 3. Save reservation with updated total
    await SupabaseRoomsData.saveReservation(date, newTotal, reservation);

    // 4. Update local state
    emit(GetTotal(total: newTotal));
  }
}
