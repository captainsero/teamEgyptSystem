part of 'days_data_cubit.dart';

@immutable
sealed class DaysDataState {}

final class DaysDataInitial extends DaysDataState {}

class DaysDataLoading extends DaysDataState {}

class DayCustomersLoad extends DaysDataState {
  final List<Map<String, dynamic>> data;
  final List<ReservationModel> reservations;
  final List<StuffModel> stuff;
  final List<ExpensesModel> expenses;
  final double total;

  DayCustomersLoad({
    required this.data,
    required this.reservations,
    required this.stuff,
    required this.expenses,
    required this.total,
  });
}

class DeleteExpense extends DaysDataState {
  final List<ExpensesModel> expenses;

  DeleteExpense({required this.expenses});
}
