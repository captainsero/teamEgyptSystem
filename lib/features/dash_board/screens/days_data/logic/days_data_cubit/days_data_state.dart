part of 'days_data_cubit.dart';

@immutable
sealed class DaysDataState {}

final class DaysDataInitial extends DaysDataState {}

class DaysDataLoading extends DaysDataState {}

class DayCustomersLoad extends DaysDataState {
  final List<Map<String, dynamic>> data;
  final List<ReservationModel> reservations;
  final List<StuffModel> stuff;
  final double total;

  DayCustomersLoad({
    required this.data,
    required this.reservations,
    required this.stuff,
    required this.total,
  });
}

