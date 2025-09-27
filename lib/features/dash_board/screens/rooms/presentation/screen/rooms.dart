import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team_egypt_v3/core/constants/screen_size.dart';
import 'package:team_egypt_v3/features/dash_board/screens/rooms/logic/cubit/reservation_cubit.dart';
import 'package:team_egypt_v3/features/dash_board/screens/rooms/presentation/widgets/add_reservation/add_reservation.dart';
import 'package:team_egypt_v3/features/dash_board/screens/rooms/presentation/widgets/available_rooms.dart';
import 'package:team_egypt_v3/features/dash_board/screens/rooms/presentation/widgets/room_reservation.dart';

class Rooms extends StatefulWidget {
  const Rooms({super.key});

  @override
  State<Rooms> createState() => _RoomsState();
}

class _RoomsState extends State<Rooms> {
  @override
  void initState() {
    context.read<ReservationCubit>().getAllRev();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScreenSize.intial(context);
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(children: [Spacer(), AddReservation(), Spacer()]),

          const SizedBox(height: 20),
          RoomReservation(),
          const SizedBox(height: 20),
          AvailableRooms(),
        ],
      ),
    );
  }
}
