import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:team_egypt_v3/core/models/rooms_model.dart';

class SupabaseRooms {
  static final supabase = Supabase.instance.client;

  /// Insert a new room
  static Future<bool> insertRoom(RoomsModel room) async {
    try {
      // Check if room already exists with same name
      final existing = await supabase
          .from("rooms")
          .select()
          .eq("name", room.name);

      if (existing.isNotEmpty) {
        print("Room with the same name already exists");
        return false; // don't insert
      }

      // Insert new room
      await supabase.from("rooms").insert({
        'name': room.name,
        'price': room.price,
        'reservation_num': room.reservationNum,
      });

      return true;
    } catch (e) {
      print("Insert room error: $e");
      return false;
    }
  }

  /// Get all rooms
  static Future<List<RoomsModel>> getRooms() async {
    try {
      final response = await supabase.from("rooms").select();

      final rooms = (response as List<dynamic>)
          .map((json) => RoomsModel.fromJson(json as Map<String, dynamic>))
          .toList();

      return rooms;
    } catch (e) {
      print("Get rooms error: $e");
      return [];
    }
  }

  static Future<bool> incrementReservationNum(String name) async {
    try {
      // 1. Get current reservation_num
      final room = await supabase
          .from("rooms")
          .select("reservation_num")
          .eq("name", name)
          .maybeSingle();

      if (room == null) return false;

      final currentNum = room["reservation_num"] as int? ?? 0;

      // 2. Update with +1
      await supabase
          .from("rooms")
          .update({'reservation_num': currentNum + 1})
          .eq("name", name);

      return true;
    } catch (e) {
      print("Increment reservation_num error: $e");
      return false;
    }
  }

  /// Delete room by name (or use id if you have one)
  static Future<bool> deleteRoom(String name) async {
    try {
      await supabase.from("rooms").delete().eq('name', name);
      return true;
    } catch (e) {
      print("Delete room error: $e");
      return false;
    }
  }
}
