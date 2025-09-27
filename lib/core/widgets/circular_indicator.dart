import 'package:flutter/material.dart';
import 'package:team_egypt_v3/core/constants/color.dart';

class CircularIndicator extends StatelessWidget {
  const CircularIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          color: Col.light2.withOpacity(0.15),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Col.dark2.withOpacity(0.12),
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: CircularProgressIndicator(
          strokeWidth: 6,
          valueColor: AlwaysStoppedAnimation<Color>(Col.dark2),
          backgroundColor: Col.light2,
        ),
      ),
    );
  }
}
