import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:team_egypt_v3/core/models/stuff_model.dart';

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

  static Future<void> saveStuffData(
    DateTime date,
    List<StuffModel> staff,
  ) async {
    try {
      final dateOnly = DateTime(date.year, date.month, date.day);

      // Fetch the existing stuff_data array for this date (if any)
      final response = await _supabase
          .from('days_data')
          .select('stuff_data')
          .eq('date', dateOnly.toIso8601String())
          .maybeSingle();

      // Convert existing rows to a List<Map>
      List<Map<String, dynamic>> existingStuff = [];
      if (response != null && response['stuff_data'] != null) {
        existingStuff = List<Map<String, dynamic>>.from(response['stuff_data']);
      }

      // Add all new staff entries
      existingStuff.addAll(staff.map((s) => s.toJson()));

      // Update only the stuff_data column
      await _supabase
          .from('days_data')
          .update({'stuff_data': existingStuff})
          .eq('date', dateOnly.toIso8601String());

      print('Stuff data saved successfully!');
    } catch (e) {
      print('Error saving stuff data: $e');
    }
  }
}
