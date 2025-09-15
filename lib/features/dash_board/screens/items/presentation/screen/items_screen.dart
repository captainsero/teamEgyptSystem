import 'package:flutter/material.dart';
import 'package:team_egypt_v3/core/constants/color.dart';
import 'package:team_egypt_v3/core/constants/screen_size.dart';

class ItemsScreen extends StatefulWidget {
  const ItemsScreen({super.key});

  @override
  State<ItemsScreen> createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: ScreenSize.width / 3.4,
          height: ScreenSize.height / 2.4,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Col.dark2,
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ],
    );
  }
}
