import 'package:flutter/material.dart';
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

  /// Mark a staff member as checked-in and store the time
  static Future<bool> checkIn(String number) async {
    try {
      await _table
          .update({'check_in': TimeOfDay.now(), 'is_in': true})
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
      await _table
          .update({'check_out': TimeOfDay.now(), 'is_in': false})
          .eq('number', number);

      return true;
    } catch (e) {
      print('Check-out error: $e');
      return false;
    }
  }

  static Future<void> saveStuffData(
    DateTime date,
    List<StuffModel> staff,
  ) async {
    try {
      final dateOnly = DateTime(date.year, date.month, date.day);

      // Get the current row for this date
      final response = await _supabase
          .from('days_data')
          .select('stuff_data')
          .eq('date', dateOnly.toIso8601String())
          .maybeSingle();

      // Build a map<number, Map<String,dynamic>> for easy updates
      final Map<String, Map<String, dynamic>> merged = {};

      if (response != null && response['stuff_data'] != null) {
        for (final item in List<Map<String, dynamic>>.from(
          response['stuff_data'],
        )) {
          merged[item['number'] as String] = item;
        }
      }

      // Add or replace each new staff member by number
      for (final s in staff) {
        merged[s.number] = s.toJson();
      }

      // Convert back to a list
      final List<Map<String, dynamic>> finalList = merged.values.toList();

      // Update only the stuff_data column
      await _supabase
          .from('days_data')
          .update({'stuff_data': finalList})
          .eq('date', dateOnly.toIso8601String());

      print('Stuff data saved/merged successfully!');
    } catch (e) {
      print('Error saving stuff data: $e');
    }
  }
}
