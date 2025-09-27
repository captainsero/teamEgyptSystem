import 'package:hive/hive.dart';

part 'checkout_items.g.dart'; // generated file

@HiveType(typeId: 0) // <- choose a unique ID for this model
class CheckoutItems extends HiveObject {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final double price;

  @HiveField(2)
  final int quantity;

  @HiveField(3)
  final String category;

    @HiveField(4)
  final int mainQuantity;

  CheckoutItems({
    required this.name,
    required this.price,
    required this.quantity,
    required this.category,
    required this.mainQuantity,
  });
}
