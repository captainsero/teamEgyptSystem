import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:team_egypt_v3/features/dash_board/screens/customers_data/logic/customers_data_logic.dart';

part 'customers_data_state.dart';

class CustomersDataCubit extends Cubit<CustomersDataState> {
  CustomersDataCubit() : super(CustomersDataInitial());

  int _currentPage = 0;
  static const int _limit = 50;

  Future<void> loadPage(int page) async {
    emit(CustomersDataLoading(state.selectedPage));
    try {
      final offset = page * _limit;
      final pageData = await CustomersDataLogic.getUsersPaginated(
        _limit,
        offset,
      );

      _currentPage = page;
      emit(CustomersDataLoaded(pageData, state.selectedPage));
    } catch (e) {
      emit(TeamDataError(e.toString(), state.selectedPage));
    }
  }

  void nextPage() => loadPage(_currentPage + 1);

  void previousPage() {
    if (_currentPage > 0) {
      loadPage(_currentPage - 1);
    }
  }

  void reset() {
    _currentPage = 0;
    emit(CustomersDataLoaded([], state.selectedPage));
  }

  void changePage(int index) {
    emit(
      CustomersDataLoaded(
        state is CustomersDataLoaded ? (state as CustomersDataLoaded).data : [],
        index,
      ),
    );
  }

  int get currentPage => _currentPage;
}
