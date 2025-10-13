import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:team_egypt_v3/core/models/expenses_model.dart';
import 'package:team_egypt_v3/core/models/reservation_model.dart';
import 'package:team_egypt_v3/core/models/stuff_model.dart';
import 'package:team_egypt_v3/features/dash_board/screens/days_data/data/supabase_days_data.dart';
import 'package:team_egypt_v3/features/time_screen/data/supabase_in_team.dart';

part 'days_data_state.dart';

class DaysDataCubit extends Cubit<DaysDataState> {
  DaysDataCubit() : super(DaysDataInitial());

  void dayCustomersLoad(DateTime date) async {
    emit(DaysDataLoading());
    try {
      final data = await SupabaseDaysData.getDayUsers(date);
      final reservations = await SupabaseDaysData.getReservations(date);
      final stuff = await SupabaseDaysData.getStuff(date);
      final expenses = await SupabaseDaysData.getExpenses(date);
      final double total = await SupabaseInTeam.getTotal(date);
      final double expensesTotal = await SupabaseDaysData.expensesTotal(date);

      if (isClosed) return;
      emit(
        DayCustomersLoad(
          data: data,
          reservations: reservations,
          stuff: stuff,
          expenses: expenses,
          total: total,
          expensesTotal: expensesTotal,
        ),
      );
    } catch (e) {
      if (isClosed) return;
      print("Error cubit load Customers: $e");
    }
  }

  Future<bool> deleteExpense(DateTime date, String name) async {
    final isDeleted = await SupabaseDaysData.deleteExpenseByName(date, name);
    if (isDeleted) {
      return true;
    } else {
      return false;
    }
  }
}
