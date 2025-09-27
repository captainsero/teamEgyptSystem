import 'package:flutter/material.dart';
import 'package:team_egypt_v3/core/constants/color.dart';
import 'package:team_egypt_v3/core/constants/fonts.dart';

class ScreensButton extends StatelessWidget {
  const ScreensButton({
    super.key,
    required this.screen,
    required this.title,
    required this.isSelected,
    required this.onSelected,
  });

  final Widget screen;
  final String title;
  final bool isSelected;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: ElevatedButton(
        onPressed: () {
          onSelected();
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => screen,
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                    return FadeTransition(opacity: animation, child: child);
                  },
              transitionDuration: Duration(milliseconds: 200),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? Col.dark2 : Col.light2,
          elevation: 0,
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Col.light2 : Colors.black,
            fontSize: 20,
            fontFamily: Fonts.appBarButtons,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
