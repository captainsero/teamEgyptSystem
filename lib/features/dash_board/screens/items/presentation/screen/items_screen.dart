import 'package:flutter/material.dart';
import 'package:team_egypt_v3/features/dash_board/screens/items/presentation/widgets/add_item_container.dart';
import 'package:team_egypt_v3/features/dash_board/screens/items/presentation/widgets/items_list_container.dart';

class ItemsScreen extends StatefulWidget {
  const ItemsScreen({super.key});

  @override
  State<ItemsScreen> createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [AddItemContainer(), Spacer(), ItemsListContainer(), Spacer()],
    );
  }
}
