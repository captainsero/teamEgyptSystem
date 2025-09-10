import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:team_egypt_v3/core/models/reservation_model.dart';

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

  static Future<List<ReservationModel>> getReservations(DateTime date) async {
    try {
      final dateOnly = DateTime(date.year, date.month, date.day);

      final response = await Supabase.instance.client
          .from("days-data")
          .select("rooms_data")
          .eq("date", dateOnly.toIso8601String())
          .maybeSingle();

      if (response == null || response["rooms_data"] == null) return [];

      final List<dynamic> roomsData = response["rooms_data"];
      return roomsData
          .map(
            (json) =>
                ReservationModel.fromJson(Map<String, dynamic>.from(json)),
          )
          .toList();
    } catch (e) {
      print("Error fetching reservations: $e");
      return [];
    }
  }
}
