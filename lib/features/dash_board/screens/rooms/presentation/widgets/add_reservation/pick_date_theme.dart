import 'package:flutter/material.dart';
import 'package:team_egypt_v3/core/constants/color.dart';

class PickDateTheme extends StatelessWidget {
  final Widget child;

  const PickDateTheme({super.key, required this.child});
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.dark(
          primary: Col.light1,
          onPrimary: Col.dark1,
          surface: Col.dark2,
          onSurface: Col.light2,
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(foregroundColor: Col.light1),
        ), dialogTheme: DialogThemeData(backgroundColor: Col.dark1),
      ),
      child: child,
    );
  }
}
