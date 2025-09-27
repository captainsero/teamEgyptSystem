import 'package:flutter/material.dart';
import 'package:team_egypt_v3/core/constants/color.dart';
import 'package:team_egypt_v3/core/constants/screen_size.dart';
import 'package:team_egypt_v3/features/time_screen/presentation/widgets/customers_column.dart/customers_column.dart';

class SearchByNumber extends StatelessWidget {
  const SearchByNumber({super.key, required this.widget});

  final CustomerColumn widget;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenSize.width / 5,
      height: ScreenSize.height / 18,
      decoration: BoxDecoration(
        color: Col.light2,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: TextField(
          controller: widget.searchController,
          decoration: const InputDecoration(
            hintText: "Search by number",
            prefixIcon: Icon(Icons.search),
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
          ),
          onChanged: widget.onSearchChanged,
        ),
      ),
    );
  }
}
