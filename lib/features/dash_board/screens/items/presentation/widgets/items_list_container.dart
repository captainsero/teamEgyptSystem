import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team_egypt_v3/core/constants/color.dart';
import 'package:team_egypt_v3/core/constants/fonts.dart';
import 'package:team_egypt_v3/core/constants/screen_size.dart';
import 'package:team_egypt_v3/core/models/items_model.dart';
import 'package:team_egypt_v3/core/widgets/circular_indicator.dart';
import 'package:team_egypt_v3/core/widgets/custom_text_field.dart';
import 'package:team_egypt_v3/core/widgets/icon_and_text.dart';
import 'package:team_egypt_v3/features/dash_board/screens/items/logic/cubit/items_cubit.dart';
import 'package:team_egypt_v3/features/dash_board/screens/items/presentation/widgets/item_status.dart';
import 'package:team_egypt_v3/features/dash_board/widgets/table_cell.dart';
import 'package:team_egypt_v3/features/dash_board/widgets/table_header.dart';

class ItemsListContainer extends StatelessWidget {
  const ItemsListContainer({super.key});

  @override
  Widget build(BuildContext context) {
    void showEditDialog(ItemsModel item) async {
      showDialog(
        context: context,
        builder: (context) {
          final _formKey = GlobalKey<FormState>();
          final nameController = TextEditingController(text: item.name);
          final priceController = TextEditingController(
            text: item.price.toString(),
          );
          final quantityController = TextEditingController(
            text: item.quantity.toString(),
          );

          return AlertDialog(
            title: Text(
              "Edit ${item.name}",
              style: TextStyle(
                color: Col.light2,
                fontWeight: FontWeight.bold,
                fontFamily: Fonts.tableHead,
              ),
            ),
            backgroundColor: Col.dark1,
            content: SizedBox(
              width: ScreenSize.width / 3,
              height: ScreenSize.height / 3.8,
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: ScreenSize.width / 5.5,
                      child: CustomTextField(
                        controller: nameController,
                        hint: "Name",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Name cannot be empty";
                          }
                          if (!RegExp(r'^[a-zA-Z0-9\s]+$').hasMatch(value)) {
                            return "Name must contain only letters and numbers";
                          }
                          return null;
                        },
                      ),
                    ),
                    Spacer(),
                    SizedBox(
                      width: ScreenSize.width / 5.5,
                      child: CustomTextField(
                        controller: priceController,
                        hint: "Price",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Price cannot be empty";
                          }
                          if (double.tryParse(value) == null) {
                            return "Price must be a number";
                          }
                          return null;
                        },
                      ),
                    ),

                    Spacer(),
                    SizedBox(
                      width: ScreenSize.width / 5.5,
                      child: CustomTextField(
                        controller: quantityController,
                        hint: "Quantity",
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Quantity cannot be empty";
                          }
                          if (int.tryParse(value) == null) {
                            return "Quantity must be a number";
                          }
                          return null;
                        },
                      ),
                    ),
                    Spacer(),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton.icon(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final name = nameController.text;
                    final price = double.parse(priceController.text);
                    final quantity = int.parse(quantityController.text);

                    final item = ItemsModel(
                      name: name,
                      price: price,
                      quantity: quantity,
                    );

                    context.read<ItemsCubit>().update(item);
                    context.read<ItemsCubit>().getAll();

                    Navigator.pop(context);
                  }
                },
                icon: Icon(Icons.done_all, color: Col.light2, size: 20),
                label: Text(
                  "Done",
                  style: TextStyle(
                    color: Col.light2,
                    fontFamily: Fonts.names,
                    fontSize: 20,
                  ),
                ),
              ),

              SizedBox(width: 10),

              TextButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.cancel_outlined,
                  color: Colors.white,
                  size: 20,
                ),
                label: Text(
                  "Cancle",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: Fonts.names,
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          );
        },
      );
    }

    return Container(
      width: ScreenSize.width / 1.5,
      height: ScreenSize.height / 1.7,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Col.dark2,
        borderRadius: BorderRadius.circular(20),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconAndText(text: "Items List", icon: Icons.format_list_bulleted),
            SizedBox(height: 20),
            BlocBuilder<ItemsCubit, ItemsState>(
              builder: (context, state) {
                List<ItemsModel> items = [];
                if (state is ItemsGetAll) {
                  items = state.items;
                }

                if (state is ItemsLoading) {
                  return CircularIndicator();
                } else {
                  return Table(
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    columnWidths: const {
                      0: FlexColumnWidth(2),
                      1: FlexColumnWidth(2),
                      2: FlexColumnWidth(2),
                      3: FlexColumnWidth(1.1),
                      4: FlexColumnWidth(2),
                    },
                    children: [
                      TableRow(
                        children: [
                          TableHeader("Name"),
                          TableHeader("Price"),
                          TableHeader("Quantity"),
                          Center(child: TableHeader("Status")),

                          Center(child: TableHeader("Actions")),
                        ],
                      ),
                      for (var ele in items)
                        TableRow(
                          children: [
                            TableCell1(ele.name),
                            TableCell1(ele.price),
                            TableCell1(ele.quantity),
                            ItemStatus(quantity: ele.quantity),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  onPressed: () => showEditDialog(ele),
                                  icon: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Icon(Icons.edit, color: Col.light2),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    context.read<ItemsCubit>().delete(ele.name);
                                  },
                                  icon: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
