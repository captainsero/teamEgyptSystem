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
  final double expensesTotal;
  final double itemsTotal;

  DayCustomersLoad({
    required this.data,
    required this.reservations,
    required this.stuff,
    required this.expenses,
    required this.total,
    required this.expensesTotal,
    required this.itemsTotal,
  });
}
