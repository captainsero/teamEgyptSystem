import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team_egypt_v3/core/constants/screen_size.dart';
import 'package:team_egypt_v3/core/utils/string_extensions.dart';
import 'package:team_egypt_v3/core/utils/validators.dart';
import 'package:team_egypt_v3/features/dash_board/screens/days_data/logic/days_data_cubit/days_data_cubit.dart';
import 'package:team_egypt_v3/features/dash_board/screens/days_data/presentation/widget/customers_table.dart';
import 'package:team_egypt_v3/features/dash_board/screens/days_data/presentation/widget/date_picker_button.dart';
import 'package:team_egypt_v3/features/dash_board/screens/days_data/presentation/widget/expenses_table.dart';
import 'package:team_egypt_v3/features/dash_board/screens/days_data/presentation/widget/rooms_reservation_card.dart';
import 'package:team_egypt_v3/features/dash_board/screens/days_data/presentation/widget/stuff_data.dart';
import 'package:team_egypt_v3/features/dash_board/screens/days_data/presentation/widget/total_salary_card.dart';
import 'package:team_egypt_v3/features/dash_board/screens/rooms/presentation/widgets/add_reservation/pick_date_theme.dart';

class DaysData extends StatefulWidget {
  const DaysData({super.key});

  @override
  State<DaysData> createState() => _DaysDataState();
}

class _DaysDataState extends State<DaysData> {
  DateTime selectedDate = Validators.choosenDay;
  late String dateFormat;

  @override
  void initState() {
    super.initState();
    dateFormat = StringExtensions.formatDate(selectedDate);
    _loadData();
  }

  Future<void> _loadData() async {
    context.read<DaysDataCubit>().dayCustomersLoad(selectedDate);
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return PickDateTheme(child: child!);
      },
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
        dateFormat = StringExtensions.formatDate(selectedDate);
      });
      _loadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenSize.intial(context);

    return BlocBuilder<DaysDataCubit, DaysDataState>(
      builder: (context, state) {
        List<Map<String, dynamic>> customers = [];
        double revenues = 0.0;
        double expenses = 0.0;
        double total = 0.0;
        double itemsTotal = 0.0;

        if (state is DayCustomersLoad) {
          customers = state.data;
          revenues = state.total;
          expenses = state.expensesTotal;
          itemsTotal = state.itemsTotal;
          total = revenues - expenses;
        }

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: DatePickerButton(onPick: _pickDate),
              ),

              const SizedBox(height: 5),

              CustomersTable(data: customers),

              const SizedBox(height: 10),

              TotalSalaryCard(
                total: total,
                dateFormat: dateFormat,
                expenses: expenses,
                revenues: revenues,
                itemsTotal: itemsTotal,
              ),

              const SizedBox(height: 10),

              RoomsReservationCard(dateFormat: dateFormat),

              const SizedBox(height: 10),

              StuffData(dateFormat: dateFormat),

              const SizedBox(height: 10),

              ExpensesTable(dateFormat: dateFormat, date: selectedDate),
            ],
          ),
        );
      },
    );
  }
}
