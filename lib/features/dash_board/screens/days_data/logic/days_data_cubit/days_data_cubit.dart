import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:team_egypt_v3/core/models/reservation_model.dart';
import 'package:team_egypt_v3/features/dash_board/screens/days_data/data/supabase_days_data.dart';

part 'days_data_state.dart';

class DaysDataCubit extends Cubit<DaysDataState> {
  DaysDataCubit() : super(DaysDataInitial());

  void dayCustomersLoad(DateTime date) async {
    emit(DaysDataLoading());
    try {
      final data = await SupabaseDaysData.getDayUsers(date);
      final reservations = await SupabaseDaysData.getReservations(date);
      emit(DayCustomersLoad(data: data, reservations: reservations));
    } catch (e) {
      print("Error cubit load Customers: $e");
    }
  }
}
