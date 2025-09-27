import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team_egypt_v3/core/constants/color.dart';
import 'package:team_egypt_v3/core/constants/screen_size.dart';
import 'package:team_egypt_v3/core/models/stuff_model.dart';
import 'package:team_egypt_v3/core/widgets/icon_and_text.dart';
import 'package:team_egypt_v3/core/widgets/modern_toast.dart';
import 'package:team_egypt_v3/features/dash_board/screens/stuff/logic/cubit/stuff_cubit.dart';
import 'package:team_egypt_v3/features/dash_board/widgets/table_cell.dart';
import 'package:team_egypt_v3/features/dash_board/widgets/table_header.dart';
import 'package:toastification/toastification.dart';

class OurStuff extends StatelessWidget {
  const OurStuff({super.key});

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconAndText(text: "Our Stuff", icon: Icons.group_sharp),
          const SizedBox(height: 20),
          BlocBuilder<StuffCubit, StuffState>(
            builder: (context, state) {
              List<StuffModel> stuff = [];
              if (state is StuffGet) {
                stuff = state.stuff;
              }
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
                      TableHeader("Number"),
                      TableHeader("position"),
                      Center(child: TableHeader("Actions")),
                    ],
                  ),
                  for (var ele in stuff)
                    TableRow(
                      children: [
                        TableCell1(ele.name),
                        TableCell1(ele.number),
                        TableCell1(ele.position),

                        IconButton(
                          onPressed: () async {
                            final delete = await context
                                .read<StuffCubit>()
                                .delete(ele.number);

                            if (delete) {
                              ModernToast.showToast(
                                context,
                                'Success',
                                'Position Deleted successfully',
                                ToastificationType.success,
                              );
                            } else {
                              ModernToast.showToast(
                                context,
                                'Error',
                                'Cannot delete the Position, try again',
                                ToastificationType.error,
                              );
                            }
                          },
                          icon: Padding(
                            padding: const EdgeInsets.all(8),
                            child: const Icon(Icons.delete, color: Colors.red),
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
    );
  }
}
