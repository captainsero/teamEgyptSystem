import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team_egypt_v3/core/constants/color.dart';
import 'package:team_egypt_v3/core/constants/screen_size.dart';
import 'package:team_egypt_v3/core/models/expenses_model.dart';
import 'package:team_egypt_v3/core/widgets/modern_toast.dart';
import 'package:team_egypt_v3/features/dash_board/screens/days_data/logic/days_data_cubit/days_data_cubit.dart';
import 'package:team_egypt_v3/features/dash_board/widgets/table_cell.dart';
import 'package:team_egypt_v3/features/dash_board/widgets/table_header.dart';
import 'package:toastification/toastification.dart';

class ExpensesTable extends StatelessWidget {
  const ExpensesTable({
    super.key,
    required this.dateFormat,
    required this.date,
  });
  final DateTime date;
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
          alignment: Alignment.center,
          child: BlocBuilder<DaysDataCubit, DaysDataState>(
            builder: (context, state) {
              double total = 0.0;
              List<ExpensesModel> expenses = [];
              if (state is DayCustomersLoad) {
                total = state.expensesTotal;
                expenses = state.expenses;
              }
              return Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Row(
                      children: [
                        Text(
                          "Expenses - $dateFormat",
                          style: TextStyle(
                            color: Col.light2,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Spacer(),
                        Text(
                          "Total - $total",
                          style: TextStyle(
                            color: Col.light2,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 20),

                  Table(
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    columnWidths: const {
                      0: FlexColumnWidth(2),
                      1: FlexColumnWidth(2),
                      2: FlexColumnWidth(2),
                    },
                    children: [
                      TableRow(
                        children: [
                          TableHeader("Name"),
                          TableHeader("Price"),
                          Center(child: TableHeader("Actions")),
                        ],
                      ),
                      for (var ele in expenses)
                        TableRow(
                          children: [
                            TableCell1(ele.name),
                            TableCell1(ele.price),
                            IconButton(
                              onPressed: () async {
                                final delete = await context
                                    .read<DaysDataCubit>()
                                    .deleteExpense(date, ele.name);

                                if (delete) {
                                  ModernToast.showToast(
                                    context,
                                    'Success',
                                    'Reservation Deleted successfully',
                                    ToastificationType.success,
                                  );
                                  context
                                      .read<DaysDataCubit>()
                                      .dayCustomersLoad(date);
                                } else {
                                  ModernToast.showToast(
                                    context,
                                    'Error',
                                    'Cannot delete the Reservation, try again',
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
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
