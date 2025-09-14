import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:team_egypt_v3/core/models/stuff_model.dart';
import 'package:team_egypt_v3/features/dash_board/screens/stuff/data/supabase_stuff.dart';

part 'stuff_state.dart';

class StuffCubit extends Cubit<StuffState> {
  StuffCubit() : super(StuffInitial());

  void getAll() async {
    emit(StuffLoading());
    final stuff = await SupabaseStuff.getAll();
    emit(StuffGet(stuff: stuff));
  }

  void insert(StuffModel stuff) async {
    emit(StuffLoading());
    final insert = await SupabaseStuff.insertPosition(stuff);

    if (insert) {
      emit(StuffSuccess(message: "Position Added Successfully"));
      getAll();
    } else {
      emit(StuffError(message: "There is a stuff with the same number"));
    }
  }

  void checkIn(String number) async {
    emit(StuffLoading());
    final stuff = await SupabaseStuff.getStuff(number);
    if (stuff == null) {
      emit(StuffError(message: "There is no stuff with the number"));
    } else {
      if (stuff.isIn = false) {
        final check = await SupabaseStuff.checkIn(number);

        if (check) {
          emit(StuffSuccess(message: 'CheckedIn Successfully'));
        } else {
          emit(StuffError(message: "There is no stuff with this number"));
        }
      } else {
        emit(StuffError(message: "This stuff already in"));
      }
    }
  }

  void checkOut(String number) async {
    emit(StuffLoading());
    final stuff = await SupabaseStuff.getStuff(number);
    if (stuff == null) {
      emit(StuffError(message: "There is no stuff with the number"));
    } else {
      if (stuff.isIn = true) {
        final check = await SupabaseStuff.checkIn(number);

        if (check) {
          emit(StuffSuccess(message: 'CheckedOut Successfully'));
        }
      } else {
        emit(StuffError(message: "This stuff already out"));
      }
    }
  }

  void delete(String number) async {
    emit(StuffLoading());
    final delete = await SupabaseStuff.deleteByNumber(number);

    if (delete) {
      emit(StuffSuccess(message: "Deleted Successfully"));
    } else {
      emit(StuffError(message: "There is no stuff with this number"));
    }
  }
}
