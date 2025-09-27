import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team_egypt_v3/core/constants/color.dart';
import 'package:team_egypt_v3/core/constants/screen_size.dart';
import 'package:team_egypt_v3/core/models/stuff_model.dart';
import 'package:team_egypt_v3/core/utils/string_extensions.dart';
import 'package:team_egypt_v3/features/dash_board/screens/days_data/logic/days_data_cubit/days_data_cubit.dart';
import 'package:team_egypt_v3/features/dash_board/widgets/table_cell.dart';
import 'package:team_egypt_v3/features/dash_board/widgets/table_header.dart';

class StuffData extends StatelessWidget {
  const StuffData({super.key, required this.dateFormat});

  final String dateFormat;

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
                  "Stuff Data - $dateFormat",
                  style: TextStyle(
                    color: Col.light2,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              SizedBox(height: 20),

              BlocBuilder<DaysDataCubit, DaysDataState>(
                builder: (context, state) {
                  List<StuffModel> stuff = [];
                  if (state is DayCustomersLoad) {
                    stuff = state.stuff;
                  }
                  return Table(
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    columnWidths: const {
                      0: FlexColumnWidth(2),
                      1: FlexColumnWidth(2),
                      2: FlexColumnWidth(2),
                      3: FlexColumnWidth(2),
                    },
                    children: [
                      TableRow(
                        children: [
                          TableHeader("Name"),
                          TableHeader("Number"),
                          TableHeader("Position"),
                          TableHeader("Checkin - Checkout"),
                        ],
                      ),
                      for (var ele in stuff)
                        TableRow(
                          children: [
                            TableCell1(ele.name),
                            TableCell1(ele.number),
                            TableCell1(ele.position),
                            TableCell1(
                              StringExtensions.formatTimeRange(
                                ele.checkIn,
                                ele.checkOut,
                              ),
                            ),
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
