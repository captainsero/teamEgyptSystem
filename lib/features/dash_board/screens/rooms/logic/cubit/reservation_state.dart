part of 'reservation_cubit.dart';

@immutable
sealed class ReservationState {}

final class ReservationInitial extends ReservationState {}

class ReservationLoading extends ReservationState {}

class ReservationInsert extends ReservationState {}

class ReservationError extends ReservationState {
  final String message;

  ReservationError({required this.message});
}

class ReservationGet extends ReservationState {
  final List<ReservationModel> reservations;
  final List<ReservationModel> reservationsByDate;

  ReservationGet({
    required this.reservations,
    required this.reservationsByDate,
  });
}

class ReservationDelete extends ReservationState {}
