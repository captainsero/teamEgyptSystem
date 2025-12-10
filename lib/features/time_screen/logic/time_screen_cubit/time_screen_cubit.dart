import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:team_egypt_v3/core/models/reservation_model.dart';
import 'package:team_egypt_v3/features/dash_board/screens/days_data/data/supabase_days_data.dart';
import 'package:team_egypt_v3/features/dash_board/screens/partnerships_screen/data/supabase_partnership.dart';
import 'package:team_egypt_v3/features/dash_board/screens/subscriptions/data/supabase_subscriptions.dart';
import 'package:team_egypt_v3/features/time_screen/data/supabase_in_team.dart';
import 'package:team_egypt_v3/features/time_screen/data/supabase_rooms_data.dart';
import 'package:team_egypt_v3/features/time_screen/logic/in_team_cubit.dart';
part 'time_screen_state.dart';

class TimeScreenCubit extends Cubit<TimeScreenState> {
  double htotal = 0;
  TimeScreenCubit() : super(TimeScreenInitial());

  void getTotal(DateTime date) async {
    final double total = await SupabaseInTeam.getTotal(date);
    htotal = total;
    emit(GetTotal(total: total));
  }

  Future<double> updateTotal(DateTime date, double price) async {
    final cerruntTotal = await SupabaseInTeam.getTotal(date);
    final newTotal = cerruntTotal + price;
    // ignore: unused_local_variable
    final updateTotal = await SupabaseDaysData.updateDayTotal(date, newTotal);
    htotal = newTotal;
    emit(GetTotal(total: newTotal));
    return newTotal;
  }

  /// ✅ Upsert User
  void upsertUser(
    DateTime date, {
    required String number,
    required String name,
    required String collage,
    required String time,
    required double price,
    double? itemsTotal,
    DateTime? checkoutTime,
    String? note,
    required String partnershipCode,
  }) async {
    final existingUsers = await SupabaseDaysData.getDayUsers(date);
    final box = Hive.box<String>('noteBox');
    final newNote = box.get(number);
    if (newNote != null) {
      note = newNote;
    }

    String partnershipName = await SupabasePartnership.getPartnershipName(
      partnershipCode,
    );

    existingUsers.add({
      'name': name,
      'number': number,
      'collage': collage,
      'partnership_code': partnershipName,
      'price': price,
      'time': time,
      if (checkoutTime != null) 'checkoutTime': checkoutTime.toIso8601String(),
      if (note != null) 'note': note else 'note': null,
    });

    if (itemsTotal != null) {
      final _ = await SupabaseInTeam.addToItemsTotal(itemsTotal);
    }

    final cerruntTotal = await SupabaseInTeam.getTotal(date);
    final newTotal = cerruntTotal + price;

    await SupabaseInTeam.updateDaysData(date, newTotal, existingUsers);

    box.delete(number);

    htotal = newTotal;

    emit(GetTotal(total: newTotal));
  }

  // ✅ Upsert room reservation
  Future<void> upsertRoom(
    DateTime date,
    ReservationModel reservation,
    double itemsTotal,
  ) async {
    final total = await SupabaseInTeam.getTotal(date);
    final newTotal = total + reservation.price;

    // 3. Save reservation with updated total
    await SupabaseRoomsData.saveReservation(date, newTotal, reservation);
    final _ = await SupabaseInTeam.addToItemsTotal(itemsTotal);

    // 4. Update local state
    emit(GetTotal(total: newTotal));
  }

  void deleteInTeamUserAndAddMinets(
    BuildContext context,
    String number,
    int timeSpent,
  ) async {
    await context.read<InTeamCubit>().deleteUser(number);
    await SupabaseSubscriptions.addMinutesToSubscriptionHours(
      number: number,
      minutesToAdd: timeSpent,
    );
  }
}
