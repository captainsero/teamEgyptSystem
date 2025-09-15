import 'package:flutter/material.dart';
import 'package:team_egypt_v3/core/constants/color.dart';
import 'package:team_egypt_v3/core/constants/fonts.dart';

class PriceText extends StatelessWidget {
  const PriceText({super.key, required this.total});

  final double total;

  @override
  Widget build(BuildContext context) {
    return Text(
      "Price After Offer = $total EGP",
      style: TextStyle(
        fontSize: 30,
        color: Col.light2,
        fontFamily: Fonts.tableHead,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
