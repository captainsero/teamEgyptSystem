import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:team_egypt_v3/core/models/checkout_items.dart';

class CancelButton extends StatelessWidget {
  const CancelButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.of(context).pop();
        final checkoutBox = Hive.box<CheckoutItems>('itemsBox');
        checkoutBox.clear();
      },
      child: Text(
        "Cancel",
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
    );
  }
}
