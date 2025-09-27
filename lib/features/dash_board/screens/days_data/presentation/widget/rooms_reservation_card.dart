import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team_egypt_v3/core/constants/color.dart';
import 'package:team_egypt_v3/core/constants/screen_size.dart';
import 'package:team_egypt_v3/core/models/reservation_model.dart';
import 'package:team_egypt_v3/core/utils/string_extensions.dart';
import 'package:team_egypt_v3/features/dash_board/screens/days_data/logic/days_data_cubit/days_data_cubit.dart';
import 'package:team_egypt_v3/features/dash_board/widgets/table_cell.dart';
import 'package:team_egypt_v3/features/dash_board/widgets/table_header.dart';

class RoomsReservationCard extends StatelessWidget {
  final String dateFormat;

  const RoomsReservationCard({super.key, required this.dateFormat});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenSize.width / 1.5,
      height: ScreenSize.height / 3,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Col.dark2,
        borderRadius: BorderRadius.circular(20),
      ),
      child: SingleChildScrollView(
        child: Align(
          alignment: Alignment.topLeft,
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Rooms Reservation - $dateFormat",
                  style: TextStyle(
                    color: Col.light2,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              SizedBox(height: 20),

              BlocBuilder<DaysDataCubit, DaysDataState>(
                builder: (context, state) {
                  List<ReservationModel> reservation = [];
                  if (state is DayCustomersLoad) {
                    reservation = state.reservations;
                  }
                  return Table(
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    columnWidths: const {
                      0: FlexColumnWidth(2),
                      1: FlexColumnWidth(2),
                      2: FlexColumnWidth(2),
                      3: FlexColumnWidth(2),
                      4: FlexColumnWidth(2),
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
                        ],
                      ),
                      for (var ele in reservation)
                        TableRow(
                          children: [
                            TableCell1(ele.name),
                            TableCell1(ele.number),
                            TableCell1(ele.room),
                            TableCell1(StringExtensions.formatDate(ele.date)),
                            Center(
                              child: TableCell1(
                                StringExtensions.formatTimeRange(
                                  ele.from,
                                  ele.to,
                                ),
                              ),
                            ),
                            TableCell1(ele.price),
                          ],
                        ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
