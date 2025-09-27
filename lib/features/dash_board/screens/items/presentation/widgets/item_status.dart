import 'package:flutter/material.dart';

class ItemStatus extends StatelessWidget {
  const ItemStatus({super.key, required this.quantity});

  final int quantity;

  @override
  Widget build(BuildContext context) {
    String label;
    Color color;
    IconData icon;

    if (quantity > 5) {
      // Active
      label = "in Stock";
      color = Colors.green;
      icon = Icons.check;
    } else if (quantity <= 0) {
      // Upcoming
      label = "Critical";
      color = Colors.red;
      icon = Icons.remove;
    } else {
      // Ended
      label = "Low Stock";
      color = Colors.orangeAccent; // can swap with yellow if you prefer
      icon = Icons.notification_important_rounded;
    }

    return Container(
      width: 20,
      height: 30,
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        border: Border.all(color: color, width: 1.5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(fontWeight: FontWeight.bold, color: color),
          ),
        ],
      ),
    );
  }
}
