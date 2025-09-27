part of 'reservation_cubit.dart';

@immutable
sealed class ReservationState {}

final class ReservationInitial extends ReservationState {}

class InsertReservationLoading extends ReservationState {}

class InsertReservationSuccess extends ReservationState{
  final String message;

  InsertReservationSuccess({required this.message});
}

class InsertReservationError extends ReservationState {
  final String message;

  InsertReservationError({required this.message});
}

class DeleteReservationLoading extends ReservationState {}

class DeleteReservationSuccess extends ReservationState{
  final String message;

  DeleteReservationSuccess({required this.message});
}

class DeleteReservationError extends ReservationState {
  final String message;

  DeleteReservationError({required this.message});
}

class GetReservationLoading extends ReservationState {}

class GetReservationSuccess extends ReservationState{
  final String message;

  GetReservationSuccess({required this.message});
}

class GetReservationError extends ReservationState {
  final String message;

  GetReservationError({required this.message});
}


class ReservationGet extends ReservationState {
  final List<ReservationModel> reservations;
  final List<ReservationModel> reservationsByDate;

  ReservationGet({
    required this.reservations,
    required this.reservationsByDate,
  });
}

