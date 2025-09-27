import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team_egypt_v3/core/constants/color.dart';
import 'package:team_egypt_v3/core/constants/fonts.dart';
import 'package:team_egypt_v3/core/constants/screen_size.dart';
import 'package:team_egypt_v3/features/app_bar/presentation/screen/app_bar_main.dart';
import 'package:team_egypt_v3/features/time_screen/data/supabase_in_team.dart';
import 'package:team_egypt_v3/features/time_screen/logic/time_screen_cubit/time_screen_cubit.dart';
import 'package:team_egypt_v3/features/time_screen/presentation/widgets/customers_column.dart/customers_column.dart';
import 'package:team_egypt_v3/features/time_screen/presentation/widgets/customers_column.dart/reservations/today_rev_container.dart';

class TimeScreen extends StatefulWidget {
  const TimeScreen({super.key, required this.day});
  final DateTime day;

  @override
  State<TimeScreen> createState() => _TimeScreenState();
}

class _TimeScreenState extends State<TimeScreen> {
  final TextEditingController _searchController = TextEditingController();
  String searchQuery = '';
  double total = 0.0;

  @override
  void initState() {
    super.initState();
    _loadTotal();
  }

  void _loadTotal() async {
    total = await SupabaseInTeam.getTotal(widget.day);
    setState(() {});
  }

  // void _refreshUsers() {
  //   context.read<InTeamCubit>().loadUsers(); // This will refresh the list
  // }

  @override
  Widget build(BuildContext context) {
    ScreenSize.intial(context);

    return Scaffold(
      appBar: AppBarMain(),
      backgroundColor: Col.dark1,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Row(
          children: [
            // Customers
            CustomerColumn(
              searchController: _searchController,
              searchQuery: searchQuery,
              onSearchChanged: (value) {
                setState(() {
                  searchQuery = value.trim();
                });
              },
            ),

            const SizedBox(width: 10),

            Expanded(
              flex: 3,
              child: Column(
                children: [
                  const SizedBox(height: 30),

                  BlocBuilder<TimeScreenCubit, TimeScreenState>(
                    builder: (context, state) {
                      final total = (state is GetTotal)
                          ? state.total
                          : this.total;

                      return Container(
                        width: ScreenSize.width / 3,
                        height: ScreenSize.height / 4,
                        decoration: BoxDecoration(
                          color: Color(0xFF102021),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Col.light1, width: 0.5),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(30),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.attach_money_rounded,
                                    color: Col.light1,
                                  ),
                                  SizedBox(width: 3),
                                  Text(
                                    "Total Salary Today",
                                    style: TextStyle(color: Col.light1),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              Text(
                                "$total EGP",
                                style: TextStyle(
                                  color: Col.light1,
                                  fontSize: 25,
                                  fontFamily: Fonts.tableHead,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                "From active sessions and room reservations",
                                style: TextStyle(color: Col.light1),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  const Spacer(),

                  TodayRevContainer(),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
