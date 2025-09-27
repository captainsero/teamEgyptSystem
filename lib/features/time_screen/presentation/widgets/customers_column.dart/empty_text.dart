import 'package:flutter/material.dart';
import 'package:team_egypt_v3/core/constants/color.dart';
import 'package:team_egypt_v3/core/constants/fonts.dart';
import 'package:team_egypt_v3/core/constants/screen_size.dart';

class EmptyText extends StatelessWidget {
  const EmptyText({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "There Is No One At The Work Space",
        style: TextStyle(
          color: Col.light1,
          fontWeight: FontWeight.bold,
          fontSize: ScreenSize.width / 15,
          fontFamily: Fonts.appBarButtons,
        ),
      ),
    );
  }
}
