import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team_egypt_v3/core/models/subscription_model.dart';
import 'package:team_egypt_v3/core/utils/string_extensions.dart';
import 'package:team_egypt_v3/core/widgets/circular_indicator.dart';
import 'package:team_egypt_v3/core/widgets/modern_toast.dart';
import 'package:team_egypt_v3/features/dash_board/screens/subscriptions/logic/cubit/subscription_cubit.dart';
import 'package:team_egypt_v3/features/dash_board/widgets/table_cell.dart';
import 'package:team_egypt_v3/features/dash_board/widgets/table_header.dart';
import 'package:toastification/toastification.dart';

class SubscriptionTable extends StatefulWidget {
  const SubscriptionTable({super.key});

  @override
  State<SubscriptionTable> createState() => _SubscriptionTableState();
}

class _SubscriptionTableState extends State<SubscriptionTable> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SubscriptionCubit, SubscriptionState>(
      builder: (context, state) {
        List<SubscriptionModel> sub = [];
        if (state is SubscriptionInitial || state is SubscriptionLoading) {
          return CircularIndicator();
        } else if (state is GetSubscriptions) {
          sub = state.sub;
          return _buildTable(sub);
        } else if (state is SubscriptionError) {
          return _buildTable(sub);
        } else {
          // Handle other states or return an empty container
          return Container();
        }
      },
    );
  }

  Widget _buildTable(List<SubscriptionModel> sub) {
    return Table(
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      columnWidths: const {
        0: FlexColumnWidth(2),
        1: FlexColumnWidth(2),
        2: FlexColumnWidth(2),
        3: FlexColumnWidth(2),
        4: FlexColumnWidth(1.5),
      },
      children: [
        TableRow(
          children: [
            TableHeader("Name"),
            TableHeader("Number"),
            TableHeader("Plan"),
            TableHeader("End Date"),
            Center(child: TableHeader("Actions")),
          ],
        ),
        for (var ele in sub)
          TableRow(
            children: [
              TableCell1(ele.name),
              TableCell1(ele.number),
              TableCell1(ele.plan),
              TableCell1(StringExtensions.formatDate(ele.endDate)),
              IconButton(
                onPressed: () {
                  // Add delete functionality here
                  context.read<SubscriptionCubit>().deleteSubscription(
                    ele.number,
                  );
                  ModernToast.showToast(
                    context,
                    'Success',
                    'Subscription Deleted successfully',
                    ToastificationType.success,
                  );
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
  }
}
