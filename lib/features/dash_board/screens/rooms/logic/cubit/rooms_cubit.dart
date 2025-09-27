import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:team_egypt_v3/core/models/rooms_model.dart';
import 'package:team_egypt_v3/features/dash_board/screens/rooms/data/supabase_rooms.dart';

part 'rooms_state.dart';

class RoomsCubit extends Cubit<RoomsState> {
  RoomsCubit() : super(RoomsInitial());

  void getRooms() async {
    final rooms = await SupabaseRooms.getRooms();
    emit(GetRooms(rooms: rooms));
  }

  Future<bool> insertRoom(RoomsModel room) async {
    emit(RoomsLoading());
    if (!await SupabaseRooms.insertRoom(room)) {
      getRooms();
      return false;
    } else {
      getRooms();
      return true;
    }
  }

  Future<bool> deleteRoom(String name) async {
    emit(RoomsLoading());
    final delete = await SupabaseRooms.deleteRoom(name);
    if (delete) {
      getRooms();
      return true;
    } else {
      getRooms();
      return false;
    }
  }
}
