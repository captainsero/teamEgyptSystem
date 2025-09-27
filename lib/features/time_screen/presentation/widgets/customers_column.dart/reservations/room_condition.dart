import 'package:flutter/material.dart';

class RoomCondition extends StatelessWidget {
  const RoomCondition({super.key, required this.from, required this.to});

  final TimeOfDay from;
  final TimeOfDay to;

  /// Convert TimeOfDay to minutes since midnight
  int _toMinutes(TimeOfDay t) => t.hour * 60 + t.minute;

  @override
  Widget build(BuildContext context) {
    final now = TimeOfDay.fromDateTime(DateTime.now());
    final nowMinutes = _toMinutes(now);
    final fromMinutes = _toMinutes(from);
    final toMinutes = _toMinutes(to);

    String label;
    Color color;
    IconData icon;

    if (nowMinutes >= fromMinutes && nowMinutes <= toMinutes) {
      // Active
      label = "Active";
      color = Colors.green;
      icon = Icons.check_circle;
    } else if (nowMinutes < fromMinutes) {
      // Upcoming
      label = "Upcoming";
      color = Colors.blue;
      icon = Icons.access_time;
    } else {
      // Ended
      label = "Ended";
      color = Colors.orangeAccent; // can swap with yellow if you prefer
      icon = Icons.stop_circle;
    }

    return Container(
      width: 100,
      height: 40,
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
