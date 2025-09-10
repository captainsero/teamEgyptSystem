import 'package:flutter/material.dart';
import 'package:team_egypt_v3/core/constants/color.dart';
import 'package:team_egypt_v3/core/constants/screen_size.dart';

class RoomsReservationCard extends StatelessWidget {
  final String dateFormat;

  const RoomsReservationCard({super.key, required this.dateFormat});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenSize.width / 1.5,
      height: ScreenSize.height / 3,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Col.dark2,
        borderRadius: BorderRadius.circular(20),
      ),
      child: SingleChildScrollView(
        child: Align(
          alignment: Alignment.topLeft,
          child: Text(
            "Rooms Reservation - $dateFormat",
            style: TextStyle(color: Col.light2, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}