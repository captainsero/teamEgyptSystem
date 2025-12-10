import 'package:flutter/material.dart';
import 'package:team_egypt_v3/core/constants/color.dart';
import 'package:team_egypt_v3/core/constants/fonts.dart';
import 'package:team_egypt_v3/core/constants/screen_size.dart';

class TotalSalaryCard extends StatelessWidget {
  final double total;
  final double expenses;
  final double revenues;
  final double itemsTotal;
  final String dateFormat;

  const TotalSalaryCard({
    super.key,
    required this.total,
    required this.dateFormat,
    required this.expenses,
    required this.itemsTotal,
    required this.revenues,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenSize.width / 1.5,
      height: ScreenSize.height / 3,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF102021),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Col.light1, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.attach_money_rounded, color: Col.light1),
              const SizedBox(width: 3),
              Text(
                "Total Salary For $dateFormat",
                style: TextStyle(
                  color: Col.light1,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const Spacer(),
          Row(
            children: [
              Text(
                "Revenues: $revenues EGP",
                style: TextStyle(
                  color: Col.light1,
                  fontSize: 25,
                  fontFamily: Fonts.tableHead,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Spacer(),
              Text(
                "Items Revenues: $itemsTotal EGP",
                style: TextStyle(
                  color: Col.light1,
                  fontSize: 25,
                  fontFamily: Fonts.tableHead,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Spacer(),
            ],
          ),
          const Spacer(),
          Text(
            "Expenses: $expenses EGP",
            style: TextStyle(
              color: Col.light1,
              fontSize: 25,
              fontFamily: Fonts.tableHead,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          Text(
            "Total: $total EGP",
            style: TextStyle(
              color: Col.light1,
              fontSize: 25,
              fontFamily: Fonts.tableHead,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          Text(
            "From active sessions and room reservations",
            style: TextStyle(color: Col.light1),
          ),
        ],
      ),
    );
  }
}
