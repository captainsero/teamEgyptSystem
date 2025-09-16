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

  void insertRoom(RoomsModel room) async {
    emit(RoomsLoading());
    if (!await SupabaseRooms.insertRoom(room)) {
      emit(RoomsError(message: "There is a room with the same name"));
    } else {
      emit(InsertRoom());

      getRooms();
    }
  }

  void deleteRoom(String name) async {
    emit(RoomsLoading());
    await SupabaseRooms.deleteRoom(name);
    emit(DeleteRoom());

    getRooms();
  }
}
