import 'package:flutter/material.dart';
import 'package:team_egypt_v3/core/constants/color.dart';
import 'package:team_egypt_v3/core/constants/fonts.dart';
import 'package:team_egypt_v3/features/time_screen/logic/time_screen_logic.dart';

class PartnershipFutureBuilder extends StatelessWidget {
  const PartnershipFutureBuilder({
    super.key,
    required this.item,
  });

  final Map<String, dynamic> item;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: TimeScreenLogic.getPartnerShipName(
        item['code'],
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState ==
            ConnectionState.waiting) {
          return Text(
            "Partnership: Loading...",
            style: TextStyle(
              fontFamily: Fonts.head,
              fontSize: 20,
              color: Col.light2,
            ),
          );
        } else if (snapshot.hasError) {
          return Text(
            "Partnership: Error",
            style: TextStyle(
              fontFamily: Fonts.head,
              fontSize: 20,
              color: Colors.red,
            ),
          );
        } else {
          return Text(
            "Partnership: ${snapshot.data}",
            style: TextStyle(
              fontFamily: Fonts.head,
              fontSize: 20,
              color: Col.light2,
            ),
          );
        }
      },
    );
  }
}