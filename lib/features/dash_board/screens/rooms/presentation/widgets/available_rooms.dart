import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team_egypt_v3/core/constants/color.dart';
import 'package:team_egypt_v3/core/constants/screen_size.dart';
import 'package:team_egypt_v3/core/models/rooms_model.dart';
import 'package:team_egypt_v3/core/widgets/circular_indicator.dart';
import 'package:team_egypt_v3/core/widgets/icon_and_text.dart';
import 'package:team_egypt_v3/core/widgets/modern_toast.dart';
import 'package:team_egypt_v3/features/dash_board/screens/rooms/logic/cubit/rooms_cubit.dart';
import 'package:team_egypt_v3/features/dash_board/widgets/table_cell.dart';
import 'package:team_egypt_v3/features/dash_board/widgets/table_header.dart';
import 'package:toastification/toastification.dart';

class AvailableRooms extends StatelessWidget {
  const AvailableRooms({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenSize.width / 1.5,
      height: ScreenSize.height / 2.5,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Col.dark2,
        borderRadius: BorderRadius.circular(20),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconAndText(text: "Available Rooms", icon: Icons.room_preferences),

            const SizedBox(height: 20),

            BlocBuilder<RoomsCubit, RoomsState>(
              builder: (context, state) {
                List<RoomsModel> rooms = [];
                if (state is GetRooms) {
                  rooms = state.rooms;
                }

                if (state is RoomsLoading) {
                  return CircularIndicator();
                } else {
                  return Table(
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    columnWidths: const {
                      0: FlexColumnWidth(2),
                      1: FlexColumnWidth(2),
                      2: FlexColumnWidth(2),
                      3: FlexColumnWidth(1.5),
                    },
                    children: [
                      TableRow(
                        children: [
                          TableHeader("Name"),
                          TableHeader("Price"),
                          TableHeader("Subscriptions"),
                          Center(child: TableHeader("Actions")),
                        ],
                      ),
                      for (var ele in rooms)
                        TableRow(
                          children: [
                            TableCell1(ele.name),
                            TableCell1("${ele.price}"),
                            TableCell1("${ele.reservationNum}"),

                            IconButton(
                              onPressed: () async {
                                final delete = await context
                                    .read<RoomsCubit>()
                                    .deleteRoom(ele.name);

                                if (delete) {
                                  ModernToast.showToast(
                                    context,
                                    'Success',
                                    'Room Deleted successfully',
                                    ToastificationType.success,
                                  );
                                } else {
                                  ModernToast.showToast(
                                    context,
                                    'Error',
                                    'Cannot delete the room, try again',
                                    ToastificationType.error,
                                  );
                                }
                              },
                              icon: Padding(
                                padding: const EdgeInsets.all(8),
                                child: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ],
                        ),
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
