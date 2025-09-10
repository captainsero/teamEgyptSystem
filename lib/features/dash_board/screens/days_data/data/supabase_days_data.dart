import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseDaysData {
  static Future<List<Map<String, dynamic>>> getDayUsers(DateTime date) async {
    try {
      final dateOnly = DateTime(date.year, date.month, date.day);

      final response = await Supabase.instance.client
          .from("days-data")
          .select("users_data")
          .eq("date", dateOnly)
          .maybeSingle();

      if (response == null || response['users_data'] == null) {
        return [];
      }

      // Convert JSON -> List<Map<String, dynamic>>
      return List<Map<String, dynamic>>.from(response['users_data']);
    } catch (e) {
      print("Error fetching users_data: $e");
      return [];
    }
  }
}
