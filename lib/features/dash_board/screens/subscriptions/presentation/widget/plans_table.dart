import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team_egypt_v3/core/models/subscription_plan_model.dart';
import 'package:team_egypt_v3/core/widgets/circular_indicator.dart';
import 'package:team_egypt_v3/core/widgets/modern_toast.dart';
import 'package:team_egypt_v3/features/dash_board/screens/subscriptions/logic/cubit/plans_cubit.dart';
import 'package:team_egypt_v3/features/dash_board/widgets/table_cell.dart';
import 'package:team_egypt_v3/features/dash_board/widgets/table_header.dart';
import 'package:toastification/toastification.dart';

class PlansTable extends StatelessWidget {
  const PlansTable({super.key});

  @override
  Widget build(BuildContext context) {
    List<SubscriptionPlanModel> plans = [];
    return BlocBuilder<PlansCubit, PlansState>(
      builder: (context, state) {
        if (state is PlansInitial || state is PlansLoading) {
          return CircularIndicator();
        } else if (state is GetPlans) {
          plans = state.plans;
        }
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
                TableHeader("Price"),
                TableHeader("Days"),
                TableHeader("Subscriptions"),
                TableHeader("Hours"),
                Center(child: TableHeader("Actions")),
              ],
            ),
            for (var ele in plans)
              TableRow(
                children: [
                  TableCell1(ele.name),
                  TableCell1("${ele.price}"),
                  TableCell1("${ele.days}"),
                  TableCell1(ele.subscriptionsNum),
                  TableCell1(ele.hours == 0 ? 'Unlimited' : ele.hours),
                  BlocBuilder<PlansCubit, PlansState>(
                    builder: (context, state) {
                      return IconButton(
                        onPressed: () {
                          context.read<PlansCubit>().deletePlan(ele.name);
                          ModernToast.showToast(
                            context,
                            'Success',
                            "Plan deleted successfully",
                            ToastificationType.success,
                          );
                        },
                        icon: Padding(
                          padding: const EdgeInsets.all(8),
                          child: const Icon(Icons.delete, color: Colors.red),
                        ),
                      );
                    },
                  ),
                ],
              ),
          ],
        );
      },
    );
  }
}
