import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team_egypt_v3/core/constants/color.dart';
import 'package:team_egypt_v3/core/constants/screen_size.dart';
import 'package:team_egypt_v3/features/dash_board/screens/customers_data/logic/customers_data_cubit/customers_data_cubit.dart';
import 'package:team_egypt_v3/features/dash_board/widgets/side_screen_button/side_button.dart';

class SideButtonContainer extends StatelessWidget {
  const SideButtonContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenSize.width / 5,
      height: ScreenSize.height,
      decoration: BoxDecoration(
        color: Col.dark2,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SideButton(
              label: "Customers Data",
              icon: Icons.groups_2_rounded,
              onpressed: () {
                context.read<CustomersDataCubit>().changePage(1);
              },
              isChanged:
                  context.watch<CustomersDataCubit>().state.selectedPage == 1,
            ),
            const SizedBox(height: 5),
            SideButton(
              label: "Days Data",
              icon: Icons.bar_chart_rounded,

              onpressed: () {
                context.read<CustomersDataCubit>().changePage(2);
              },
              isChanged:
                  context.watch<CustomersDataCubit>().state.selectedPage == 2,
            ),
            const SizedBox(height: 5),
            SideButton(
              label: "Partnerships",
              icon: Icons.people_alt_sharp,

              onpressed: () {
                context.read<CustomersDataCubit>().changePage(3);
              },
              isChanged:
                  context.watch<CustomersDataCubit>().state.selectedPage == 3,
            ),
            const SizedBox(height: 5),
            SideButton(
              label: "Subscriptions",
              icon: Icons.payment,
              onpressed: () {
                context.read<CustomersDataCubit>().changePage(4);
              },
              isChanged:
                  context.watch<CustomersDataCubit>().state.selectedPage == 4,
            ),
            const SizedBox(height: 5),
            SideButton(
              label: "Rooms",
              icon: Icons.location_on,
              onpressed: () {
                context.read<CustomersDataCubit>().changePage(5);
              },
              isChanged:
                  context.watch<CustomersDataCubit>().state.selectedPage == 5,
            ),
            const SizedBox(height: 5),
            SideButton(
              label: "Stuff",
              icon: Icons.person_add_alt_1,

              onpressed: () {
                context.read<CustomersDataCubit>().changePage(6);
              },
              isChanged:
                  context.watch<CustomersDataCubit>().state.selectedPage == 6,
            ),
            const SizedBox(height: 5),
            SideButton(
              label: "Items",
              icon: Icons.inventory,
              onpressed: () {
                context.read<CustomersDataCubit>().changePage(7);
              },
              isChanged:
                  context.watch<CustomersDataCubit>().state.selectedPage == 7,
            ),
            const SizedBox(height: 5),
            SideButton(
              label: "Prices",
              icon: Icons.monetization_on,
              onpressed: () {
                context.read<CustomersDataCubit>().changePage(8);
              },
              isChanged:
                  context.watch<CustomersDataCubit>().state.selectedPage == 8,
            ),
            const SizedBox(height: 5),
            SideButton(
              label: "Monthly Report",
              icon: Icons.calendar_month,
              onpressed: () {
                context.read<CustomersDataCubit>().changePage(9);
              },
              isChanged:
                  context.watch<CustomersDataCubit>().state.selectedPage == 9,
            ),
            SideButton(
              label: "Tasks",
              icon: Icons.task_rounded,
              onpressed: () {
                context.read<CustomersDataCubit>().changePage(10);
              },
              isChanged:
                  context.watch<CustomersDataCubit>().state.selectedPage == 10,
            ),
          ],
        ),
      ),
    );
  }
}
