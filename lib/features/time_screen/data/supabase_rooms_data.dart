import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:team_egypt_v3/core/models/reservation_model.dart';

class SupabaseRoomsData {
  static final supabase = Supabase.instance.client;

  /// Save reservation into days_data.rooms_data
  static Future<void> saveReservation(
    DateTime date,
    double newTotal,
    ReservationModel reservation,
  ) async {
    try {
      final dateOnly = DateTime(date.year, date.month, date.day);

      // Get existing rooms_data for this date
      final response = await supabase
          .from("days-data")
          .select("rooms_data")
          .eq("date", dateOnly.toIso8601String())
          .maybeSingle();

      List<dynamic> existingRooms = [];
      if (response != null && response["rooms_data"] != null) {
        existingRooms = List<Map<String, dynamic>>.from(response["rooms_data"]);
      }

      // Add new reservation
      existingRooms.add(reservation.toJson());

      // Update the row
      await supabase
          .from("days-data")
          .update({"rooms_data": existingRooms,'total': newTotal,})
          .eq("date", dateOnly.toIso8601String());

      print("Reservation saved successfully!");
    } catch (e) {
      print("Error saving reservation: $e");
    }
  }

  /// Get all reservations for a day
  static Future<List<ReservationModel>> getReservations(DateTime date) async {
    try {
      final dateOnly = DateTime(date.year, date.month, date.day);

      final response = await supabase
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
