import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:team_egypt_v3/core/models/reservation_model.dart';
import 'package:team_egypt_v3/features/dash_board/screens/rooms/data/supabase_rooms.dart';

class SupabaseReservations {
  static final supabase = Supabase.instance.client;

  // Insert Reservation
  static Future<bool> insertRev(ReservationModel rev) async {
    try {

      // 2. Conflict check
      final formattedDate = rev.date.toIso8601String().split('T').first;
      final fromStr =
          '${rev.from.hour.toString().padLeft(2, '0')}:${rev.from.minute.toString().padLeft(2, '0')}:00';
      final toStr =
          '${rev.to.hour.toString().padLeft(2, '0')}:${rev.to.minute.toString().padLeft(2, '0')}:00';

      final conflicts = await supabase
          .from('room_reservation')
          .select()
          .eq('room', rev.room)
          .eq('date', formattedDate)
          .or(
            'and(from.lte.$fromStr,to.gt.$fromStr),'
            'and(from.lt.$toStr,to.gte.$toStr),'
            'and(from.gte.$fromStr,to.lte.$toStr)',
          );

      if (conflicts.isNotEmpty) {
        print('Time conflict with an existing reservation');
        return false;
      }

      // 3. Insert if no conflict
      await SupabaseRooms.incrementReservationNum(rev.room);
      final response = await supabase.from('room_reservation').insert({
        'name': rev.name,
        'number': rev.number,
        'room': rev.room,
        'price': rev.price,
        'date': formattedDate,
        'from': fromStr,
        'to': toStr,
      }).select();

      return response.isNotEmpty;
    } catch (e) {
      print('Error inserting Rev: $e');
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
  static Future<bool> deleteRev(int id) async {
    try {
      final response = await supabase
          .from("room_reservation")
          .delete()
          .eq('id', id)
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
