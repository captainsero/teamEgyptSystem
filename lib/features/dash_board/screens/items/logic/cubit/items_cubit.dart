import 'package:bloc/bloc.dart';
import 'package:hive/hive.dart';
import 'package:meta/meta.dart';
import 'package:team_egypt_v3/core/models/checkout_items.dart';
import 'package:team_egypt_v3/core/models/items_model.dart';
import 'package:team_egypt_v3/features/dash_board/screens/items/data/supabase_items.dart';

part 'items_state.dart';

class ItemsCubit extends Cubit<ItemsState> {
  ItemsCubit() : super(ItemsInitial());

  void getAll() async {
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

  void getByCategory(String category) async {
    emit(ItemsLoading());
    final items = await SupabaseItems.getByCategory(category);
    emit(ItemsGetByCategory(items: items));
  }

  Future<bool> insert(ItemsModel items) async {
    emit(ItemsLoading());
    final insert = await SupabaseItems.insert(items);
    if (insert == false) {
      getAll();

      return false;
    } else {
      getAll();

      return true;
    }
  }

  Future<bool> delete(String name) async {
    emit(ItemsLoading());
    final delete = await SupabaseItems.deleteByName(name);
    if (delete == false) {
      getAll();
      return false;
    } else {
      getAll();
      return true;
    }
  }

  Future<bool> update(ItemsModel items) async {
    emit(ItemsLoading());
    final update = await SupabaseItems.updateByName(items);
    if (update == false) {
      getAll();
      return false;
    } else {
      getAll();
      return true;
    }
  }

  void updateQuantity(String number) async {
    emit(ItemsLoading());
    final update = await SupabaseItems.syncCheckoutToSupabase(number);
    if (update) {
      getAll();
    }
    await Future.delayed(const Duration(seconds: 2));
    if (Hive.isBoxOpen(number)) {
      await Hive.box<CheckoutItems>(number).close();
    }
    final totalBox = Hive.box<double>('itemsTotal');
    final noteBox = Hive.box<String>('noteBox');
    await Hive.deleteBoxFromDisk(number);
    noteBox.delete(number);
    totalBox.delete("${number}total");
    getAll();
  }
}
