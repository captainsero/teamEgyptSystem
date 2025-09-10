import 'package:flutter/material.dart';
import 'package:team_egypt_v3/core/constants/color.dart';

class TableCell1 extends StatelessWidget {
  final dynamic text;

  const TableCell1(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Text(
        text?.toString() ?? "Empty",
        style: TextStyle(color: Col.light2),
      ),
    );
  }
}