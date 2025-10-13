import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team_egypt_v3/core/constants/color.dart';
import 'package:team_egypt_v3/core/constants/fonts.dart';
import 'package:team_egypt_v3/core/constants/screen_size.dart';
import 'package:team_egypt_v3/core/models/expenses_model.dart';
import 'package:team_egypt_v3/core/widgets/circular_indicator.dart';
import 'package:team_egypt_v3/features/dash_board/screens/month_data/logic/cubit/month_data_cubit.dart';

class MonthlyOverview extends StatefulWidget {
  const MonthlyOverview({super.key});

  @override
  State<MonthlyOverview> createState() => _MonthlyOverviewState();
}

class _MonthlyOverviewState extends State<MonthlyOverview>
    with WidgetsBindingObserver {
  late int selectedYear;
  int? selectedMonth;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    selectedYear = DateTime.now().year;
    selectedMonth = DateTime.now().month;
    _loadYearData(selectedYear);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _loadYearData(selectedYear); // reload when screen resumes
    }
  }

  void _loadYearData(int year) {
    context.read<MonthDataCubit>().getMonthlyTotal(year);
  }

  @override
  Widget build(BuildContext context) {
    ScreenSize.intial(context);

    final int startYear = 2020;
    final int endYear = DateTime.now().year + 1;
    final List<int> years = List.generate(
      endYear - startYear + 1,
      (index) => startYear + index,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Align(
            alignment: Alignment.centerRight,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Col.dark2,
                borderRadius: BorderRadius.circular(10),
              ),
              child: DropdownButton<int>(
                value: selectedYear,
                dropdownColor: Col.dark2,
                underline: const SizedBox(),
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: Fonts.head,
                  fontSize: 18,
                ),
                items: years
                    .map(
                      (year) => DropdownMenuItem<int>(
                        value: year,
                        child: Text(year.toString()),
                      ),
                    )
                    .toList(),
                onChanged: (int? newYear) {
                  if (newYear != null && newYear != selectedYear) {
                    selectedYear = newYear;
                    _loadYearData(selectedYear); // reload data on year change
                    setState(() {});
                  }
                },
              ),
            ),
          ),
        ),

        Expanded(
          child: BlocBuilder<MonthDataCubit, MonthDataState>(
            builder: (context, state) {
              if (state is GetMonthlyTotal) {
                final totals = state.total;
                final expensesTotals = state.expensesTotal;

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: 12,
                  itemBuilder: (context, index) {
                    final month = index + 1;
                    final total = totals.length > index ? totals[index] : 0.0;
                    final expensesTotal = expensesTotals.length > index
                        ? expensesTotals[index]
                        : 0.0;
                    final difference = total - expensesTotal;

                    return GestureDetector(
                      onTap: () async {
                        setState(() => selectedMonth = month);
                        await context.read<MonthDataCubit>().getMonthTotals(
                          selectedYear,
                          month,
                        );
                        _showMonthDetailsDialog(
                          context.read<MonthDataCubit>().state,
                          month,
                          selectedYear,
                        );
                      },
                      child: Container(
                        width: ScreenSize.width / 1.5,
                        height: ScreenSize.height / 2.5,
                        margin: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 16,
                        ),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Col.dark2,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _monthName(month) + ' $selectedYear',
                              style: const TextStyle(
                                fontFamily: Fonts.head,
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 16),
                            _buildRow('Total', total),
                            _buildRow('Expenses', expensesTotal),
                            const Divider(color: Colors.white70),
                            _buildRow('Difference', difference),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }

              // Add special case for initial loading spinner
              if (state is Loading) {
                return Center(child: CircularIndicator());
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRow(String label, double value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontFamily: Fonts.names,
              fontSize: 18,
              color: Col.light2,
            ),
          ),
          Text(
            value.toStringAsFixed(2),
            style: const TextStyle(
              fontFamily: Fonts.names,
              fontSize: 18,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  String _monthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[month - 1];
  }

  void _showMonthDetailsDialog(
    MonthDataState state,
    int month,
    int year,
  ) async {
    List<double> dailyTotals = [];
    List<ExpensesModel> expensesList = [];

    if (state is GetMonthTotals) {
      dailyTotals = state.total;
      expensesList = state.expensesTotal;
    }

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Col.dark2,
        title: Text(
          'Details for ${_monthName(month)} $selectedYear',
          style: const TextStyle(fontFamily: Fonts.head, color: Colors.white),
        ),
        content: SizedBox(
          width: ScreenSize.width / 1.5,
          height: ScreenSize.height / 3,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Daily Totals:',
                  style: const TextStyle(
                    fontFamily: Fonts.names,
                    fontSize: 30,
                    color: Col.light1,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                ...dailyTotals.asMap().entries.map((e) {
                  int dayNum = e.key + 1;
                  double value = e.value;
                  return Text(
                    'Day $dayNum: ${value.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontFamily: Fonts.names,
                      color: Col.light2,
                      fontSize: 24,
                    ),
                  );
                }),
                const SizedBox(height: 16),
                Text(
                  'Expenses:',
                  style: const TextStyle(
                    fontFamily: Fonts.names,
                    fontSize: 30,
                    color: Col.light1,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                ...expensesList.map((expense) {
                  return Text(
                    '${expense.name}: ${expense.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontFamily: Fonts.names,
                      color: Col.light2,
                      fontSize: 24,
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Close',
              style: TextStyle(
                color: Col.light1,
                fontFamily: Fonts.appBarButtons,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
    context.read<MonthDataCubit>().getMonthlyTotal(year);
  }
}
