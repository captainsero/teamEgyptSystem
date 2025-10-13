import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:team_egypt_v3/core/models/expenses_model.dart';
import 'package:team_egypt_v3/core/models/reservation_model.dart';
import 'package:team_egypt_v3/core/models/stuff_model.dart';

class SupabaseDaysData {
  static Future<List<Map<String, dynamic>>> getDayUsers(DateTime date) async {
    try {
      final dateOnly = DateTime(date.year, date.month, date.day);

      final response = await Supabase.instance.client
          .from("days_data")
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
          .from("days_data")
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

  static Future<List<StuffModel>> getStuff(DateTime date) async {
    try {
      final dateOnly = DateTime(date.year, date.month, date.day);

      final response = await Supabase.instance.client
          .from("days_data")
          .select("stuff_data")
          .eq("date", dateOnly.toIso8601String())
          .maybeSingle();

      if (response == null || response["stuff_data"] == null) return [];

      final List<dynamic> roomsData = response["stuff_data"];
      return roomsData
          .map((json) => StuffModel.fromJson(Map<String, dynamic>.from(json)))
          .toList();
    } catch (e) {
      print("Error fetching reservations: $e");
      return [];
    }
  }

  static Future<void> updateDayTotal(DateTime date, double newTotal) async {
    try {
      // ignore: unused_local_variable
      final response = await Supabase.instance.client
          .from('days_data')
          .update({'total': newTotal})
          .eq('date', date);
    } catch (e) {
      print('error update day total: $e');
    }
  }

  static Future<bool> insertExpenses(
    DateTime date,
    ExpensesModel expense,
  ) async {
    try {
      // Get current expenses list
      final dateOnly = DateTime(date.year, date.month, date.day);
      final response = await Supabase.instance.client
          .from("days_data")
          .select("expenses")
          .eq("date", dateOnly.toIso8601String())
          .maybeSingle();

      List<dynamic> currentExpenses = [];
      if (response != null && response['expenses'] != null) {
        currentExpenses = List<dynamic>.from(response['expenses']);
      }

      // Add new expense
      currentExpenses.add(expense.toJson());

      // Update the expenses list in database
      await Supabase.instance.client
          .from('days_data')
          .update({'expenses': currentExpenses})
          .eq('date', dateOnly.toIso8601String());
      return true;
    } catch (e) {
      print('Error inserting expense: $e');
      return false;
    }
  }

  static Future<List<ExpensesModel>> getExpenses(DateTime date) async {
    try {
      final dateOnly = DateTime(date.year, date.month, date.day);
      final response = await Supabase.instance.client
          .from("days_data")
          .select("expenses")
          .eq("date", dateOnly.toIso8601String())
          .maybeSingle();

      if (response == null || response['expenses'] == null) return [];

      final List<dynamic> expensesData = response['expenses'];
      return expensesData
          .map(
            (json) => ExpensesModel.fromJson(Map<String, dynamic>.from(json)),
          )
          .toList();
    } catch (e) {
      print('Error getting expenses: $e');
      return [];
    }
  }
}
