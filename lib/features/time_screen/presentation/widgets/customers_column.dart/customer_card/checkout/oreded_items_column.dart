import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:team_egypt_v3/core/constants/color.dart';
import 'package:team_egypt_v3/core/constants/screen_size.dart';
import 'package:team_egypt_v3/core/models/checkout_items.dart';

class OrderedItemsColumn extends StatelessWidget {
  const OrderedItemsColumn({super.key, required this.user});
  final String user;

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<CheckoutItems>(user);
    final totalBox = Hive.box<double>("itemsTotal");

    return SizedBox(
      height: ScreenSize.height / 4,
      child: ValueListenableBuilder<Box<CheckoutItems>>(
        valueListenable: box.listenable(),
        builder: (context, box, _) {
          final items = box.values.toList();

          // ✅ calculate total using each item's own quantity
          final total = items.fold<double>(
            0,
            (sum, item) => sum + (item.price * item.quantity),
          );

          totalBox.put('${user}total', total);

          if (items.isEmpty) {
            totalBox.put('${user}total', 0.0);
            return const Center(
              child: Text(
                'No items yet',
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                for (int i = 0; i < items.length; i++)
                  _ItemCard(item: items[i], index: i, box: box),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ItemCard extends StatefulWidget {
  final CheckoutItems item;
  final int index;
  final Box<CheckoutItems> box;

  const _ItemCard({required this.item, required this.index, required this.box});

  @override
  State<_ItemCard> createState() => _ItemCardState();
}

class _ItemCardState extends State<_ItemCard> {
  void _updateQuantity(int newQty) {
    // update Hive so the stored quantity stays correct
    widget.box.putAt(
      widget.index,
      CheckoutItems(
        name: widget.item.name,
        price: widget.item.price,
        quantity: newQty,
        category: widget.item.category,
        mainQuantity: widget.item.mainQuantity,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Col.dark2,
      child: Row(
        children: [
          const Spacer(),
          Column(
            children: [
              Text(
                widget.item.name,
                style: const TextStyle(color: Colors.white),
              ),
              Text(
                '\$${widget.item.price.toStringAsFixed(2)} each',
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
          const Spacer(),
          _QtyButton(
            icon: Icons.remove,
            onPressed: () {
              if (widget.item.quantity > 1) {
                _updateQuantity(widget.item.quantity - 1);
              }
            },
          ),
          const Spacer(),
          Text(
            '${widget.item.quantity}',
            style: const TextStyle(color: Colors.white),
          ),
          const Spacer(),
          _QtyButton(
            icon: Icons.add,
            onPressed: () {
              if (widget.item.mainQuantity > widget.item.quantity) {
                _updateQuantity(widget.item.quantity + 1);
              }
            },
          ),
          const Spacer(),
          Column(
            children: [
              Text(
                '\$${(widget.item.price * widget.item.quantity).toStringAsFixed(2)}',
                style: const TextStyle(color: Colors.white),
              ),
              TextButton(
                onPressed: () => widget.box.deleteAt(widget.index),
                child: const Text(
                  'Remove',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
          const Spacer(),
        ],
      ),
    );
  }
}

class _QtyButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _QtyButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: Col.light1,
        borderRadius: BorderRadius.circular(8),
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white, size: 16),
        onPressed: onPressed,
        padding: EdgeInsets.zero,
        splashRadius: 20,
      ),
    );
  }
}
