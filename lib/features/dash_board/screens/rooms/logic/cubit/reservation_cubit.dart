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
    emit(GetReservationLoading());
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

  Future<bool> insertRev(ReservationModel newRev) async {
    emit(InsertReservationLoading());
    final rev = await SupabaseReservations.insertRev(newRev);
    if (rev == true) {
      getAllRev();
      return true;
      // Do NOT call getAllRev() here
    } else {
      getAllRev();
      return false;
      // Do NOT call getAllRev() here
    }
  }

  Future<bool> deleteRev(int id) async {
    emit(DeleteReservationLoading());
    final del = await SupabaseReservations.deleteRev(id);

    if (del == false) {
      getAllRev();
      return false;
      // Do NOT call getAllRev() here
    } else {
      getAllRev();
      return true;
      // Do NOT call getAllRev() here
    }
  }
}
