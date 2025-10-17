import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team_egypt_v3/core/constants/color.dart';
import 'package:team_egypt_v3/core/constants/screen_size.dart';
import 'package:team_egypt_v3/features/app_bar/presentation/screen/app_bar_main.dart';
import 'package:team_egypt_v3/features/dash_board/screens/customers_data/logic/customers_data_cubit/customers_data_cubit.dart';
import 'package:team_egypt_v3/features/dash_board/widgets/screen_switcher.dart';
import 'package:team_egypt_v3/features/dash_board/widgets/side_screen_button/side_button_container.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({super.key});

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  int isChanged = 1;

  @override
  void initState() {
    context.read<CustomersDataCubit>().loadPage(0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScreenSize.intial(context);

    return Scaffold(
      appBar: AppBarMain(),
      backgroundColor: Col.dark1,
      body: BlocBuilder<CustomersDataCubit, CustomersDataState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [SideButtonContainer(), ScreenSwitcher()],
            ),
          );
        },
      ),
    );
  }
}
