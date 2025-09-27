import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:team_egypt_v3/core/models/stuff_model.dart';
import 'package:team_egypt_v3/core/utils/validators.dart';

class SupabaseStuff {
  // Table reference
  static final _table = Supabase.instance.client.from('stuff');
  static final _supabase = Supabase.instance.client;

  /// Insert a new staff row
  static Future<bool> insertPosition(StuffModel stuff) async {
    try {
      await _table.insert(stuff.toJson());
      return true;
    } catch (e) {
      print('Insert error: $e');
      return false;
    }
  }

  /// Fetch all staff rows
  static Future<List<StuffModel>> getAll() async {
    try {
      final data = await _table.select();
      // `data` is List<dynamic>, convert each to StuffModel
      return (data as List)
          .map((row) => StuffModel.fromJson(row as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Fetch error: $e');
      return [];
    }
  }

  /// Delete a staff row by number (or use id if you have one)
  static Future<bool> deleteByNumber(String number) async {
    try {
      await _table.delete().eq('number', number);
      return true;
    } catch (e) {
      print('Delete error: $e');
      return false;
    }
  }

  static Future<StuffModel?> getStuff(String number) async {
    try {
      final response = await _table
          .select()
          .eq('number', number)
          .maybeSingle(); // returns Map<String,dynamic>? or null

      if (response == null) {
        return null; // no staff member with this number
      }

      return StuffModel.fromJson(response);
    } catch (e) {
      print('Fetch stuff error: $e');
      return null;
    }
  }

  /// Mark a staff member as checked-in and store the time
  static Future<bool> checkIn(String number) async {
    try {
      final now = TimeOfDay.now();
      final checkInValue =
          '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

      await _table
          .update({'check_in': checkInValue, 'is_in': true})
          .eq('number', number);

      return true;
    } catch (e) {
      print('Check-in error: $e');
      return false;
    }
  }

  /// Mark a staff member as checked-out and store the time
  static Future<bool> checkOut(String number) async {
    try {
      // 1. Get current time in HH:mm
      final now = TimeOfDay.now();
      final formatted =
          '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

      // 2. Update checkout time
      await _table
          .update({'check_out': formatted, 'is_in': false})
          .eq('number', number);

      // 3. Re-fetch the *updated* row
      final updatedStuff = await getStuff(number);
      if (updatedStuff == null) return false;

      // 4. Save the new data to days_data
      await saveStuffData(Validators.choosenDay, updatedStuff);

      return true;
    } catch (e) {
      print('Check-out error: $e');
      return false;
    }
  }

  static Future<void> saveStuffData(DateTime date, StuffModel stuff) async {
    try {
      final dateOnly = DateTime(date.year, date.month, date.day);

      // Fetch current stuff_data for this date (if any)
      final response = await _supabase
          .from('days_data')
          .select('stuff_data')
          .eq('date', dateOnly.toIso8601String())
          .maybeSingle();

      // Convert existing rows to a list
      List<Map<String, dynamic>> existingStuff = [];
      if (response != null && response['stuff_data'] != null) {
        existingStuff = List<Map<String, dynamic>>.from(response['stuff_data']);
      }

      // Always add the new record
      existingStuff.add(stuff.toJson());

      // Update the row with the new array
      await _supabase
          .from('days_data')
          .update({'stuff_data': existingStuff})
          .eq('date', dateOnly.toIso8601String());

      print('New staff data saved successfully!');
    } catch (e) {
      print('Error saving stuff data: $e');
    }
  }
}
