import 'package:flutter/material.dart';
import 'package:team_egypt_v3/core/constants/color.dart';
import 'package:team_egypt_v3/core/constants/fonts.dart';

class IconAndText extends StatelessWidget {
  const IconAndText({super.key, required this.text, required this.icon});

  final String text;
  final IconData? icon;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Col.light2),
        const SizedBox(width: 5),
        Text(
          text,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 20,
            color: Col.light2,
            fontFamily: Fonts.names,
          ),
        ),
      ],
    );
  }
}
