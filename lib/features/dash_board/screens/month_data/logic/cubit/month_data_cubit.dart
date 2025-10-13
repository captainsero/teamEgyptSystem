import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:team_egypt_v3/core/models/expenses_model.dart';
import 'package:team_egypt_v3/features/dash_board/screens/month_data/data/supabase_month_data.dart';

part 'month_data_state.dart';

class MonthDataCubit extends Cubit<MonthDataState> {
  MonthDataCubit() : super(MonthDataInitial());

  Future<void> getMonthlyTotal(int year) async {
    emit(Loading());
    List<double> totals = List.filled(12, 0.0);
    List<double> expensesTotals = List.filled(12, 0.0);

    // Runs all month fetches in parallel
    final futures = List.generate(12, (index) async {
      int month = index + 1;
      final total = await SupabaseMonthData.getMonthTotalFromDailyTotals(
        year,
        month,
      );
      final expensesTotal = await SupabaseMonthData.expensesMonthlyTotal(
        year,
        month,
      );
      totals[index] = total;
      expensesTotals[index] = expensesTotal;
    });

    await Future.wait(futures);

    emit(GetMonthlyTotal(total: totals, expensesTotal: expensesTotals));
  }

  Future<void> getMonthTotals(int year, int month) async {
    final totals = await SupabaseMonthData.getMonthlyTotalDetails(year, month);
    final expensesTotals = await SupabaseMonthData.getMonthlyExpenses(
      year,
      month,
    );
    emit(
      GetMonthTotals(
        year: year,
        month: month,
        total: totals,
        expensesTotal: expensesTotals,
      ),
    );
    // getMonthlyTotal(year);
  }
}
