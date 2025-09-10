import 'package:flutter/material.dart';
import 'package:team_egypt_v3/features/dash_board/screens/customers_data/presentation/widgets/customer_card_dashboard/customer_card_dashboard.dart';
import 'package:team_egypt_v3/features/dash_board/screens/customers_data/presentation/widgets/customer_card_dashboard/error_text.dart';
import 'package:team_egypt_v3/features/dash_board/screens/customers_data/presentation/widgets/head_text.dart';
import 'package:team_egypt_v3/features/dash_board/screens/customers_data/presentation/widgets/next_button.dart';
import 'package:team_egypt_v3/features/dash_board/screens/customers_data/presentation/widgets/page_text.dart';
import 'package:team_egypt_v3/features/dash_board/screens/customers_data/presentation/widgets/press_text.dart';
import 'package:team_egypt_v3/features/dash_board/screens/customers_data/presentation/widgets/previous_button.dart';
import 'package:team_egypt_v3/features/dash_board/screens/customers_data/presentation/widgets/search_person_button.dart';

class CustomersData extends StatelessWidget {
  const CustomersData({
    super.key,
    required this.isLoading,
    required this.error,
    required this.teamData,
  });

  final bool isLoading;
  final String? error;
  final List<Map<String, dynamic>> teamData;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        HeadText(),
        Align(
          alignment: Alignment.topLeft,
          child: Row(
            children: [
              PreviousButton(),

              const SizedBox(width: 20),

              NextButton(),

              const SizedBox(width: 20),

              PageText(),

              Spacer(),

              SearchPersonButton(),
            ],
          ),
        ),
        const SizedBox(height: 30),

        if (isLoading) const Center(child: CircularProgressIndicator()),
        if (error != null) ErrorText(error: error),

        if (!isLoading && error == null && teamData.isEmpty) PressText(),

        if (!isLoading && error == null && teamData.isNotEmpty)
          CustomerCardDashboard(teamData: teamData),
      ],
    );
  }
}
