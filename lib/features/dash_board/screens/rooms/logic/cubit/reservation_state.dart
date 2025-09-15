part of 'reservation_cubit.dart';

@immutable
sealed class ReservationState {}

final class ReservationInitial extends ReservationState {}

class ReservationLoading extends ReservationState {}

class ReservationSuccess extends ReservationState{
  final String message;

  ReservationSuccess({required this.message});
}

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

