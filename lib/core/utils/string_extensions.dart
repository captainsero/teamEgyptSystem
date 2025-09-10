import 'package:flutter/material.dart';

class StringExtensions {
  static String formatTime(dynamic value) {
    if (value is int) {
      final duration = Duration(seconds: value);
      return duration.toString().split('.').first; // HH:MM:SS
    }
    return value.toString();
  }

  static String formatDate(DateTime date) {
    return "${date.year}/${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}";
  }

  static String getElapsedTime(DateTime start) {
    final duration = DateTime.now().difference(start);
    return duration.toString().split('.').first.padLeft(8, "0");
  }

  /// 👉 Format a TimeOfDay to AM/PM style
  static String formatTimeOfDay(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod; // 0 → 12
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? "AM" : "PM";
    return "$hour:$minute $period";
  }

  /// 👉 Format a range of times (from → to)
  static String formatTimeRange(TimeOfDay from, TimeOfDay to) {
    return "${formatTimeOfDay(from)} - ${formatTimeOfDay(to)}";
  }

  static double calculateTotal(
    TimeOfDay from,
    TimeOfDay to,
    double pricePerHour,
  ) {
    // Helper to convert TimeOfDay to DateTime
    DateTime _toDateTime(TimeOfDay tod) {
      final now = DateTime.now();
      return DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    }

    final start = _toDateTime(from);
    var end = _toDateTime(to);

    // Handle overnight case (e.g., 10:00 PM → 2:00 AM)
    if (end.isBefore(start)) {
      end = end.add(const Duration(days: 1));
    }

    final minutes = end.difference(start).inMinutes;
    final hours = minutes / 60.0;

    return hours * pricePerHour;
  }
}
