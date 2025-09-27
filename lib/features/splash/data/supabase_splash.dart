import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:team_egypt_v3/core/utils/validators.dart';
import 'package:team_egypt_v3/features/time_screen/presentation/screen/time_screen.dart';

class SupabaseSplash {
  static Future<bool> checking(DateTime date) async {
    try {
      final response = await Supabase.instance.client
          .from("days_data")
          .select()
          .eq("date", date.toIso8601String().split('T').first)
          .maybeSingle();
      return response != null;
    } catch (e) {
      print("Error: $e");
      return false;
    }
  }

  static Future<DateTime?> insertDay(DateTime date, dynamic context) async {
    final formattedDate = date.toIso8601String().split('T').first;
    if (await checking(date)) {
      Validators.choosenDay = date;
      Navigator.pushReplacement(
        (context),
        MaterialPageRoute(
          builder: (context) => TimeScreen(day: Validators.choosenDay),
        ),
      );
      return date;
    } else {
      try {
        // ignore: unused_local_variable
        final response = await Supabase.instance.client
            .from("days_data")
            .insert({'date': formattedDate})
            .select();
        Validators.choosenDay = date;
        Navigator.pushReplacement(
          (context),
          MaterialPageRoute(
            builder: (context) => TimeScreen(day: Validators.choosenDay),
          ),
        );
        return date;
      } catch (e) {
        print("Error: $e");
        return null;
      }
    }
  }
}