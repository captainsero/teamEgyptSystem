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

  Future<bool> insert(StuffModel stuff) async {
    emit(StuffLoading());
    final isIn = await SupabaseStuff.getStuff(stuff.number);
    if (isIn != null) {
      getAll();

      return false;
    } else {
      final insert = await SupabaseStuff.insertPosition(stuff);

      if (insert) {
        getAll();

        return true;
      } else {
        getAll();

        return false;
      }
    }
  }

  Future<bool> checkIn(String number) async {
    emit(StuffLoading());
    final stuff = await SupabaseStuff.getStuff(number);
    if (stuff == null) {
      getAll();
      return false;
    } else {
      if (stuff.isIn == false) {
        final check = await SupabaseStuff.checkIn(number);

        if (check) {
          getAll();
          return true;
        } else {
          getAll();
          return false;
        }
      } else {
        getAll();
        return false;
      }
    }
  }

  Future<bool> checkOut(String number) async {
    emit(StuffLoading());
    final stuff = await SupabaseStuff.getStuff(number);
    if (stuff == null) {
      getAll();
      return false;
    } else {
      if (stuff.isIn == true) {
        final check = await SupabaseStuff.checkOut(number);

        if (check) {
          getAll();
          return true;
        } else {
          getAll();
          return false;
        }
      } else {
        getAll();
        return false;
      }
    }
  }

  Future<bool> delete(String number) async {
    emit(StuffLoading());
    final delete = await SupabaseStuff.deleteByNumber(number);

    if (delete) {
      getAll();
      return true;
    } else {
      getAll();
      return false;
    }
  }
}
