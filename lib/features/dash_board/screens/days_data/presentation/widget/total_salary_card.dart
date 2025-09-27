import 'package:flutter/material.dart';
import 'package:team_egypt_v3/core/constants/color.dart';
import 'package:team_egypt_v3/core/constants/fonts.dart';
import 'package:team_egypt_v3/core/constants/screen_size.dart';

class TotalSalaryCard extends StatelessWidget {
  final double total;
  final String dateFormat;

  const TotalSalaryCard({
    super.key,
    required this.total,
    required this.dateFormat,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenSize.width / 1.5,
      height: ScreenSize.height / 5,
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
          Text(
            "$total EGP",
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
