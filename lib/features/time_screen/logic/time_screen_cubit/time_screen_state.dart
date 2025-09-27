part of 'time_screen_cubit.dart';

@immutable
sealed class TimeScreenState {}

final class TimeScreenInitial extends TimeScreenState {}

class GetTotal extends TimeScreenState {
  final double total;

  GetTotal({required this.total});
}

class RoomsDataLoaded extends TimeScreenState {
  final List<Map<String, dynamic>> roomsData;
  RoomsDataLoaded(this.roomsData);
}

class RoomUpserted extends TimeScreenState {
  final Map<String, dynamic> room;
  RoomUpserted(this.room);
}
