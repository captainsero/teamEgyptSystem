import 'package:flutter/material.dart';
import 'package:team_egypt_v3/core/constants/fonts.dart';
import 'package:team_egypt_v3/core/constants/screen_size.dart';

class ErrorText extends StatelessWidget {
  const ErrorText({super.key, required this.error});

  final String? error;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Text(
        'Error: $error',
        style: TextStyle(
          fontFamily: Fonts.head,
          fontSize: ScreenSize.width / 50,
          color: Colors.red,
        ),
      ),
    );
  }
}