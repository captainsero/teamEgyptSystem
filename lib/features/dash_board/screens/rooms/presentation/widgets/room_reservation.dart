import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team_egypt_v3/core/constants/color.dart';
import 'package:team_egypt_v3/core/constants/screen_size.dart';
import 'package:team_egypt_v3/core/models/reservation_model.dart';
import 'package:team_egypt_v3/core/utils/string_extensions.dart';
import 'package:team_egypt_v3/core/widgets/circular_indicator.dart';
import 'package:team_egypt_v3/core/widgets/icon_and_text.dart';
import 'package:team_egypt_v3/core/widgets/modern_toast.dart';
import 'package:team_egypt_v3/features/dash_board/screens/rooms/logic/cubit/reservation_cubit.dart';
import 'package:team_egypt_v3/features/dash_board/widgets/table_cell.dart';
import 'package:team_egypt_v3/features/dash_board/widgets/table_header.dart';
import 'package:toastification/toastification.dart';

class RoomReservation extends StatelessWidget {
  const RoomReservation({super.key});

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
            IconAndText(
              text: "Rooms Reservation",
              icon: Icons.connect_without_contact_sharp,
            ),

            const SizedBox(height: 20),

            BlocBuilder<ReservationCubit, ReservationState>(
              builder: (context, state) {
                List<ReservationModel> reservations = [];
                if (state is ReservationGet) {
                  reservations = state.reservations;
                }

                if (state is GetReservationLoading) {
                  return CircularIndicator();
                } else {
                  return Table(
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    columnWidths: const {
                      0: FlexColumnWidth(2),
                      1: FlexColumnWidth(2),
                      2: FlexColumnWidth(2),
                      3: FlexColumnWidth(2),
                      4: FlexColumnWidth(2),
                      5: FlexColumnWidth(1.5),
                    },
                    children: [
                      TableRow(
                        children: [
                          TableHeader("Name"),
                          TableHeader("Number"),
                          TableHeader("Room"),
                          TableHeader("Date"),
                          Center(child: TableHeader("Time")),
                          TableHeader("Price"),
                          Center(child: TableHeader("Action")),
                        ],
                      ),
                      for (var ele in reservations)
                        TableRow(
                          children: [
                            TableCell1(ele.name),
                            TableCell1(ele.number),
                            TableCell1(ele.room),
                            TableCell1(StringExtensions.formatDate(ele.date)),
                            TableCell1(
                              StringExtensions.formatTimeRange(
                                ele.from,
                                ele.to,
                              ),
                            ),
                            TableCell1(ele.price),

                            IconButton(
                              onPressed: () async {
                                final delete = await context
                                    .read<ReservationCubit>()
                                    .deleteRev(ele.number);

                                if (delete) {
                                  ModernToast.showToast(
                                    context,
                                    'Success',
                                    'Reservation Deleted successfully',
                                    ToastificationType.success,
                                  );
                                } else {
                                  ModernToast.showToast(
                                    context,
                                    'Error',
                                    'Cannot delete the Reservation, try again',
                                    ToastificationType.error,
                                  );
                                }

                                // ModernToast.showToast(
                                //   context,
                                //   'Success',
                                //   "Reservation Deleted Successfully",
                                //   ToastificationType.success,
                                // );
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
