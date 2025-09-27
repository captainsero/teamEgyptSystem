import 'package:flutter/material.dart';
import 'package:team_egypt_v3/core/constants/color.dart';
import 'package:team_egypt_v3/core/constants/fonts.dart';
import 'package:team_egypt_v3/core/constants/screen_size.dart';

class PressText extends StatelessWidget {
  const PressText({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Text(
        'Press Next To load The data.',
        style: TextStyle(
          fontFamily: Fonts.head,
          fontSize: ScreenSize.width / 50,
          color: Col.light2,
        ),
      ),
    );
  }
}