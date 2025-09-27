import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:team_egypt_v3/core/constants/color.dart';
import 'package:team_egypt_v3/core/constants/fonts.dart';
import 'package:team_egypt_v3/core/constants/screen_size.dart';
import 'package:team_egypt_v3/core/models/items_model.dart';
import 'package:team_egypt_v3/core/widgets/circular_indicator.dart';
import 'package:team_egypt_v3/core/widgets/custom_drop_down_field.dart';
import 'package:team_egypt_v3/core/widgets/custom_text_field.dart';
import 'package:team_egypt_v3/core/widgets/icon_and_text.dart';
import 'package:team_egypt_v3/core/widgets/modern_toast.dart';
import 'package:team_egypt_v3/features/dash_board/screens/items/logic/cubit/items_cubit.dart';
import 'package:toastification/toastification.dart';

class AddItemContainer extends StatefulWidget {
  const AddItemContainer({super.key});

  @override
  State<AddItemContainer> createState() => _AddItemContainerState();
}

class _AddItemContainerState extends State<AddItemContainer> {
  final nameController = TextEditingController();

  final priceController = TextEditingController();

  final quantityController = TextEditingController();

  String? category;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenSize.width / 1.5,
      height: ScreenSize.height / 3.5,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Col.dark2,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconAndText(text: "Add Item", icon: Icons.playlist_add),
            SizedBox(height: 20),
            Row(
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
              ],
            ),
            Spacer(),
            Row(
              children: [
                SizedBox(
                  width: ScreenSize.width / 5.5,
                  child: CustomDropdownField(
                    value: category,
                    items: ["Drink", "Snack"],
                    hint: "Select Category",
                    onChanged: (value) {
                      setState(() {
                        category = value;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please select a Room";
                      }
                      return null;
                    },
                  ),
                ),
                Spacer(),
                BlocBuilder<ItemsCubit, ItemsState>(
                  builder: (context, state) {
                    void addButton() async {
                      if (_formKey.currentState!.validate()) {
                        final name = nameController.text;
                        final price = double.parse(priceController.text);
                        final quantity = int.parse(quantityController.text);

                        final item = ItemsModel(
                          name: name,
                          price: price,
                          quantity: quantity,
                          category: category!,
                        );

                        final isInsert = await context
                            .read<ItemsCubit>()
                            .insert(item);
                        if (isInsert) {
                          ModernToast.showToast(
                            context,
                            'Success',
                            'Item Inserted successfully',
                            ToastificationType.success,
                          );
                          nameController.clear();
                          priceController.clear();
                          quantityController.clear();
                        } else {
                          ModernToast.showToast(
                            context,
                            'Error',
                            "There is an item with the same name",
                            ToastificationType.error,
                          );
                        }
                      }
                    }

                    if (state is ItemsLoading) {
                      return CircularIndicator();
                    } else {
                      return Align(
                        alignment: Alignment.center,
                        child: TextButton.icon(
                          onPressed: addButton,
                          icon: Icon(
                            Icons.add_circle_sharp,
                            color: Col.light2,
                            size: 20,
                          ),
                          label: Text(
                            "Add",
                            style: TextStyle(
                              color: Col.light2,
                              fontFamily: Fonts.names,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
