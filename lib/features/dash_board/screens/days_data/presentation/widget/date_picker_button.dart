import 'package:flutter/material.dart';
import 'package:team_egypt_v3/core/constants/color.dart';
import 'package:team_egypt_v3/core/constants/fonts.dart';

class DatePickerButton extends StatelessWidget {
  final VoidCallback onPick;

  const DatePickerButton({super.key, required this.onPick});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPick,
      icon: Icon(Icons.calendar_today, size: 20, color: Col.light2),
      label: Text(
        'Pick Date',
        style: TextStyle(
          color: Col.light2,
          fontFamily: Fonts.head,
          fontWeight: FontWeight.bold,
        ),
      ),
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: Col.light2, width: 1.5), // border color
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }
}
