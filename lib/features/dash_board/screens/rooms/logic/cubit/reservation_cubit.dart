import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:team_egypt_v3/core/models/reservation_model.dart';
import 'package:team_egypt_v3/core/utils/validators.dart';
import 'package:team_egypt_v3/features/dash_board/screens/rooms/data/supabase_reservations.dart';

part 'reservation_state.dart';

class ReservationCubit extends Cubit<ReservationState> {
  ReservationCubit() : super(ReservationInitial());

  void getAllRev() async {
    emit(ReservationLoading());
    final reservations = await SupabaseReservations.getAllRev();
    final reservationsByDate = await SupabaseReservations.getRevByDate(
      Validators.choosenDay,
    );

    emit(
      ReservationGet(
        reservations: reservations,
        reservationsByDate: reservationsByDate,
      ),
    );
  }

  void insertRev(ReservationModel newRev) async {
    emit(ReservationLoading());
    final rev = await SupabaseReservations.insertRev(newRev);
    if (rev == true) {
      emit(ReservationInsert());

      getAllRev();
    } else {
      emit(
        ReservationError(
          message: 'There is a reversation with the same number',
        ),
      );
      getAllRev();
    }
  }

  void deleteRev(String number) async {
    emit(ReservationLoading());
    final del = await SupabaseReservations.deleteRev(number);

    if (del == false) {
      emit(
        ReservationError(message: "Cann't delete the reversation, try again"),
      );
    } else {
      emit(ReservationDelete());

      getAllRev();
    }
  }
}
