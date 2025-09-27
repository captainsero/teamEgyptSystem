import 'package:flutter/material.dart';
import 'package:team_egypt_v3/core/constants/color.dart';
import 'package:team_egypt_v3/core/constants/fonts.dart';

class CardText extends StatelessWidget {
  const CardText({super.key, required this.text, required this.itemText});

  final dynamic itemText;
  final String text;

  @override
  Widget build(BuildContext context) {
    return SelectableText(
      '$text : ${itemText ?? ''}',
      style: TextStyle(fontFamily: Fonts.head, fontSize: 20, color: Col.light2),
    );
  }
}
