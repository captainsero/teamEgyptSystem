import 'package:flutter/material.dart';
import 'package:team_egypt_v3/core/constants/color.dart';
import 'package:team_egypt_v3/core/constants/screen_size.dart';
import 'package:team_egypt_v3/features/dash_board/screens/subscriptions/presentation/widget/add_subscription.dart';
import 'package:team_egypt_v3/features/dash_board/screens/subscriptions/presentation/widget/plans_table.dart';
import 'package:team_egypt_v3/features/dash_board/screens/subscriptions/presentation/widget/subscription_table.dart';
import 'package:team_egypt_v3/core/widgets/icon_and_text.dart';

class Subsciptions extends StatefulWidget {
  const Subsciptions({super.key});

  @override
  State<Subsciptions> createState() => _SubsciptionsState();
}

class _SubsciptionsState extends State<Subsciptions> {
  @override
  Widget build(BuildContext context) {
    ScreenSize.intial(context);
    return SingleChildScrollView(
      child: Column(
        children: [
          Row(children: [Spacer(), AddSubscription(), Spacer()]),

          const SizedBox(height: 20),
          Container(
            width: ScreenSize.width / 1.5,
            height: ScreenSize.height / 2.5,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Col.dark2,
              borderRadius: BorderRadius.circular(20),
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconAndText(
                    text: "Manage Subscriptions",
                    icon: Icons.manage_accounts,
                  ),
                  SizedBox(height: 10),
                  SubscriptionTable(),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          Container(
            width: ScreenSize.width / 1.5,
            height: ScreenSize.height / 2.5,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Col.dark2,
              borderRadius: BorderRadius.circular(20),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  IconAndText(text: "Mannage Plans", icon: Icons.edit_square),
                  SizedBox(height: 10),
                  PlansTable(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
