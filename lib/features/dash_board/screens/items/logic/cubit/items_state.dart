part of 'items_cubit.dart';

@immutable
sealed class ItemsState {}

final class ItemsInitial extends ItemsState {}

class ItemsLoading extends ItemsState {}

class ItemsSuccessfull extends ItemsState {
  final String message;

  ItemsSuccessfull({required this.message});
}

class ItemsError extends ItemsState {
  final String message;

  ItemsError({required this.message});
}

class ItemsGetByCategory extends ItemsState {
  final List<ItemsModel> items;

  ItemsGetByCategory({required this.items});
}

class ItemsGetAll extends ItemsState {
  final List<ItemsModel> items;

  ItemsGetAll({required this.items});
}

class ItemsGetOne extends ItemsState {
  final ItemsModel item;

  ItemsGetOne({required this.item});
}
