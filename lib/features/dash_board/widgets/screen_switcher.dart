import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team_egypt_v3/features/dash_board/screens/customers_data/logic/customers_data_cubit/customers_data_cubit.dart';
import 'package:team_egypt_v3/features/dash_board/screens/customers_data/presentation/screen/customers_data.dart';
import 'package:team_egypt_v3/features/dash_board/screens/days_data/presentation/screen/days_data.dart';
import 'package:team_egypt_v3/features/dash_board/screens/items/presentation/screen/items_screen.dart';
import 'package:team_egypt_v3/features/dash_board/screens/partnerships_screen/logic/cubit/partner_ship_cubit.dart';
import 'package:team_egypt_v3/features/dash_board/screens/partnerships_screen/presentation/screen/partnership_screen.dart';
import 'package:team_egypt_v3/features/dash_board/screens/prices/screen/prices_screen.dart';
import 'package:team_egypt_v3/features/dash_board/screens/rooms/presentation/screen/rooms.dart';
import 'package:team_egypt_v3/features/dash_board/screens/stuff/presentation/screen/stuff_screen.dart';
import 'package:team_egypt_v3/features/dash_board/screens/subscriptions/presentation/screen/subsciptions.dart';
import 'package:team_egypt_v3/features/dash_board/screens/tasks/presentation/screens/tasks_screen.dart';

class ScreenSwitcher extends StatelessWidget {
  const ScreenSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 20),
        child: Builder(
          builder: (context) {
            final state = context.watch<CustomersDataCubit>().state;

            switch (state.selectedPage) {
              case 1:
                return CustomersData(
                  isLoading: state is CustomersDataLoading,
                  error: state is TeamDataError ? state.message : null,
                  teamData: state is CustomersDataLoaded ? state.data : [],
                );
              case 2:
                return DaysData();
              case 3:
                return BlocProvider(
                  create: (_) => PartnerShipCubit()..partnerShipLoadData(),
                  child: const PartnershipScreen(),
                );
              case 4:
                return Subsciptions();
              case 5:
                return Rooms();
              case 6:
                return StuffScreen();
              case 7:
                return ItemsScreen();
              case 8:
                return PricesScreen();
              // case 9:
              //   return MonthlyOverview();
              case 10:
                return TasksScreen();
              default:
                return Center(child: Text("Unknown Page"));
            }
          },
        ),
      ),
    );
  }
}
