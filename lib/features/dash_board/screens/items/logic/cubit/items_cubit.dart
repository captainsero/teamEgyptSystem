import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:team_egypt_v3/core/models/items_model.dart';
import 'package:team_egypt_v3/features/dash_board/screens/items/data/supabase_items.dart';

part 'items_state.dart';

class ItemsCubit extends Cubit<ItemsState> {
  ItemsCubit() : super(ItemsInitial());

  void getAll() async {
    emit(ItemsLoading());
    final items = await SupabaseItems.getAll();
    if (items.isEmpty) {
      emit(ItemsError(message: "There is no items"));
    } else {
      emit(ItemsGetAll(items: items));
    }
  }

  void getOne(String name) async {
    emit(ItemsLoading());
    final item = await SupabaseItems.getByName(name);
    if (item == null) {
      emit(ItemsError(message: "There is no item with this name"));
    } else {
      emit(ItemsGetOne(item: item));
    }
  }

  void insert(ItemsModel items) async {
    emit(ItemsLoading());
    final insert = await SupabaseItems.insert(items);
    if (insert == false) {
      emit(ItemsError(message: "There is an item with the same name"));
    } else {
      emit(ItemsSuccessfull(message: "Item added successfully"));
      getAll();
    }
  }

  void delete(String name) async {
    emit(ItemsLoading());
    final delete = await SupabaseItems.deleteByName(name);
    if (delete == false) {
      emit(ItemsError(message: "Cannot Delete the item"));
    } else {
      emit(ItemsSuccessfull(message: "Item Deleted successfully"));
      getAll();
    }
  }

  void update(ItemsModel items) async {
    emit(ItemsLoading());
    final update = await SupabaseItems.updateByName(items);
    if (update == false) {
      emit(ItemsError(message: "Cannot Update the item"));
    }else{
      emit(ItemsSuccessfull(message: "Item Updated successfully"));
      getAll();
    }
  }
}
