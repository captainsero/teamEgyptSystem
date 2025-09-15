import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:team_egypt_v3/core/models/items_model.dart';

part 'items_state.dart';

class ItemsCubit extends Cubit<ItemsState> {
  ItemsCubit() : super(ItemsInitial());
}
