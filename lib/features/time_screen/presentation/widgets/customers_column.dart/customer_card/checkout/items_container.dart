import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:team_egypt_v3/core/constants/color.dart';
import 'package:team_egypt_v3/core/constants/screen_size.dart';
import 'package:team_egypt_v3/core/models/checkout_items.dart';
import 'package:team_egypt_v3/core/models/items_model.dart';
import 'package:team_egypt_v3/core/widgets/circular_indicator.dart';
import 'package:team_egypt_v3/features/dash_board/screens/items/logic/cubit/items_cubit.dart';

class ItemsContainer extends StatefulWidget {
  const ItemsContainer({super.key, required this.user});
  final String user;

  @override
  State<ItemsContainer> createState() => _ItemsContainerState();
}

class _ItemsContainerState extends State<ItemsContainer> {
  String item = 'Drink';
  bool isChosen = true;

  // void onChoose() {
  //   setState(() {
  //     item = item == "Drink" ? "Snack" : "Drink";
  //   });
  //   context.read<ItemsCubit>().getByCategory(item);
  // }

  void onDrink() {
    setState(() {
      item = "Drink";
      isChosen = true;
    });
    context.read<ItemsCubit>().getByCategory(item);
  }

  void onSnack() {
    setState(() {
      item = "Snack";
      isChosen = false;
    });
    context.read<ItemsCubit>().getByCategory(item);
  }

  @override
  void initState() {
    super.initState();
    context.read<ItemsCubit>().getByCategory(item);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ItemsCubit, ItemsState>(
      builder: (context, state) {
        List<ItemsModel> items = [];
        if (state is ItemsGetByCategory) {
          items = state.items;
        }

        if (state is ItemsLoading) {
          return CircularIndicator();
        } else {
          return Container(
            width: ScreenSize.width / 1.8,
            height: ScreenSize.height / 1.8,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Col.light1.withOpacity(0.4)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: onDrink,
                      child: Text(
                        "Drinks",
                        style: isChosen
                            ? TextStyle(fontSize: 20, color: Colors.white)
                            : TextStyle(fontSize: 16, color: Col.light2),
                      ),
                    ),

                    TextButton(
                      onPressed: onSnack,
                      child: Text(
                        "Snacks",
                        style: isChosen
                            ? TextStyle(fontSize: 16, color: Col.light2)
                            : TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: SizedBox(
                    width: ScreenSize.width / 1.8,
                    child: GridView.builder(
                      physics: const BouncingScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3, // 3 items per row
                        childAspectRatio: 2.5, // Adjust for card shape
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index];

                        // Decide label & color
                        late String label;
                        late Color textColor;

                        if (item.quantity == 0) {
                          label = "Out Of Stock";
                          textColor = Colors.red;
                        } else if (item.quantity < 5 && item.quantity > 0 ||
                            item.quantity == 5) {
                          // 👈 quantity less than 5
                          label = "Low Stock";
                          textColor = Colors.orange;
                        } else {
                          label = "Add";
                          textColor = Colors.white;
                        }

                        return Card(
                          color: Col.light1,
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      item.name,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                      ),
                                    ),
                                    Spacer(),
                                    Text(
                                      "${item.quantity}",
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                      ),
                                    ),
                                    Spacer(),
                                    Text(
                                      "\$${item.price}",
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ],
                                ),

                                Spacer(),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: item.quantity == 0
                                        ? null
                                        : () async {
                                            final itemBox =
                                                Hive.box<CheckoutItems>(
                                                  widget.user,
                                                );

                                            // ✅ Check if an item with the same name already exists
                                            final alreadyExists = itemBox.values
                                                .any(
                                                  (checkout) =>
                                                      checkout.name ==
                                                      items[index].name,
                                                );

                                            if (alreadyExists) {
                                              // Item is already in the box → do nothing
                                              return;
                                            }

                                            // Item is not in the box → add it
                                            await itemBox.add(
                                              CheckoutItems(
                                                name: items[index].name,
                                                price: items[index].price,
                                                quantity: 1,
                                                category: items[index].category,
                                                mainQuantity:
                                                    items[index].quantity,
                                              ),
                                            );
                                          },

                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Col.dark2,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: Text(
                                      label,
                                      style: TextStyle(
                                        color: textColor,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
