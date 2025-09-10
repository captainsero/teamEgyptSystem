import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team_egypt_v3/core/constants/color.dart';
import 'package:team_egypt_v3/core/constants/fonts.dart';
import 'package:team_egypt_v3/core/constants/screen_size.dart';
import 'package:team_egypt_v3/features/dash_board/screens/customers_data/logic/customers_data_cubit/customers_data_cubit.dart';

class PageText extends StatelessWidget {
  const PageText({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      "Page: ${context.watch<CustomersDataCubit>().currentPage + 1}",
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontFamily: Fonts.head,
        fontSize: ScreenSize.width / 80,
        color: Col.light2,
      ),
    );
  }
}