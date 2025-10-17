import 'package:flutter/material.dart';
import 'package:team_egypt_v3/core/constants/color.dart';
import 'package:team_egypt_v3/core/constants/fonts.dart';
import 'package:team_egypt_v3/core/constants/screen_size.dart';

class SideButton extends StatelessWidget {
  const SideButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onpressed,
    required this.isChanged,
  });

  final String label;
  final IconData icon;
  final VoidCallback onpressed;
  final bool isChanged;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onpressed,
      icon: Icon(icon, color: isChanged ? Col.light1 : Col.light2),
      label: Text(
        label,
        style: TextStyle(
          fontSize: ScreenSize.width / 90,
          fontFamily: Fonts.head,
          color: isChanged ? Col.light1 : Col.light2,
        ),
      ),
    );
  }
}
