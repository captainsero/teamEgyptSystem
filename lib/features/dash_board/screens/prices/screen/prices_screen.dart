import 'package:flutter/material.dart';
import 'package:team_egypt_v3/features/dash_board/screens/prices/widgets/add_expenses.dart';
import 'package:team_egypt_v3/features/dash_board/screens/prices/widgets/edit_hour_fee.dart';
import 'package:team_egypt_v3/features/dash_board/screens/prices/widgets/add_room.dart';
import 'package:team_egypt_v3/features/dash_board/screens/prices/widgets/add_position.dart';
import 'package:team_egypt_v3/features/dash_board/screens/prices/widgets/add_subscription_plan.dart';

class PricesScreen extends StatelessWidget {
  const PricesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(children: [AddRoom(), Spacer(), AddPosition()]),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      AddSubscriptionPlan(),
                      Spacer(),
                      Column(
                        children: [
                          EditHourFee(),
                          SizedBox(height: 20),
                          AddExpenses(),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
