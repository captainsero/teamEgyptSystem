part of 'customers_data_cubit.dart';

@immutable
abstract class CustomersDataState {
  final int selectedPage;
  const CustomersDataState(this.selectedPage);
}

class CustomersDataInitial extends CustomersDataState {
  const CustomersDataInitial() : super(1);
}

class CustomersDataLoading extends CustomersDataState {
  const CustomersDataLoading(super.selectedPage);
}

class CustomersDataLoaded extends CustomersDataState {
  final List<Map<String, dynamic>> data;
  const CustomersDataLoaded(this.data, int selectedPage) : super(selectedPage);
}

class TeamDataError extends CustomersDataState {
  final String message;
  const TeamDataError(this.message, int selectedPage) : super(selectedPage);
}
