import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:team_egypt_v3/core/models/reservation_model.dart';

class SupabaseReservations {
  static final supabase = Supabase.instance.client;

  // Insert Reservation
  static Future<bool> insertRev(ReservationModel rev) async {
    try {
      // Check if reservation with same number already exists
      final existing = await supabase
          .from("room_reservation")
          .select()
          .eq('number', rev.number);

      if (existing.isNotEmpty) {
        print("Reservation with this number already exists");
        return false;
      }

      // Insert new reservation
      final response = await supabase.from("room_reservation").insert({
        'name': rev.name,
        'number': rev.number,
        'room': rev.room,
        'price': rev.price,
        'date': rev.date.toIso8601String().split('T').first, // yyyy-MM-dd
        'from':
            '${rev.from.hour.toString().padLeft(2, '0')}:${rev.from.minute.toString().padLeft(2, '0')}:00',
        'to':
            '${rev.to.hour.toString().padLeft(2, '0')}:${rev.to.minute.toString().padLeft(2, '0')}:00',
      }).select(); // add .select() to get the inserted row back

      return response.isNotEmpty;
    } catch (e) {
      print("Error inserting Rev: $e");
      return false;
    }
  }

  // Get all reservations
  static Future<List<ReservationModel>> getAllRev() async {
    try {
      final response = await supabase.from("room_reservation").select();
      return (response as List)
          .map((rev) => ReservationModel.fromJson(rev))
          .toList();
    } catch (e) {
      print("Error getting all Rev: $e");
      return [];
    }
  }

  // Get reservations by date
  static Future<List<ReservationModel>> getRevByDate(DateTime date) async {
    try {
      final formattedDate = date
          .toIso8601String()
          .split('T')
          .first; // yyyy-MM-dd
      final response = await supabase
          .from("room_reservation")
          .select()
          .eq('date', formattedDate);

      return (response as List)
          .map((rev) => ReservationModel.fromJson(rev))
          .toList();
    } catch (e) {
      print("Error getting Rev by date: $e");
      return [];
    }
  }

  // Delete reservation by ID
  static Future<bool> deleteRev(String number) async {
    try {
      final response = await supabase
          .from("room_reservation")
          .delete()
          .eq('number', number)
          .select(); // 👈 important: returns the deleted rows

      // ignore: unnecessary_null_comparison
      if (response != null && response.isNotEmpty) {
        return true; // deletion happened
      }
      return false; // nothing deleted
    } catch (e) {
      print("Error deleting Rev: $e");
      return false;
    }
  }
}
