part of 'month_data_cubit.dart';

sealed class MonthDataState extends Equatable {
  const MonthDataState();

  @override
  List<Object> get props => [];
}

final class MonthDataInitial extends MonthDataState {}

class GetMonthlyTotal extends MonthDataState {
  final List<double> total;
  final List<double> expensesTotal;

  const GetMonthlyTotal({required this.total, required this.expensesTotal});
}

class GetMonthTotals extends MonthDataState {
  final int year;
  final int month;
  final List<double> total;
  final List<ExpensesModel> expensesTotal;

  const GetMonthTotals({
    required this.year,
    required this.month,
    required this.total,
    required this.expensesTotal,
  });

  @override
  List<Object> get props => [year, month, total, expensesTotal];
}

class YearlyTotalsLoaded extends MonthDataState {
  final int year;
  final List<double> monthlyTotals;

  const YearlyTotalsLoaded({required this.year, required this.monthlyTotals});

  @override
  List<Object> get props => [year, monthlyTotals];
}

class Loading extends MonthDataState {}
