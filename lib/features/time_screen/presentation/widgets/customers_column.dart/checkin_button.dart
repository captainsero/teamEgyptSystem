import 'package:flutter/material.dart';
import 'package:team_egypt_v3/core/constants/color.dart';
import 'package:team_egypt_v3/core/constants/fonts.dart';
import 'package:team_egypt_v3/core/constants/screen_size.dart';
import 'package:team_egypt_v3/features/time_screen/logic/time_screen_logic.dart';

class CheckinButton extends StatelessWidget {
  const CheckinButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () => TimeScreenLogic.showCheckinDialog(context),
      style: ElevatedButton.styleFrom(
        backgroundColor: Col.light2,
        shape: BeveledRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(5),
        ),
      ),
      icon: Icon(Icons.move_to_inbox, color: Colors.black),
      label: Text(
        "Checkin",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontFamily: Fonts.head,
          color: Colors.black,
          fontSize: ScreenSize.width / 70,
        ),
      ),
    );
  }
}
