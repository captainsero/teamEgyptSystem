import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:team_egypt_v3/core/models/expenses_model.dart';

class SupabaseMonthData {
  // Calculate total expenses for a given month and year
  static Future<double> expensesMonthlyTotal(int year, int month) async {
    try {
      final response = await Supabase.instance.client
          .from('days_data')
          .select('expenses, date');

      // ignore: unnecessary_null_comparison
      if (response == null) return 0.0;

      double total = 0.0;

      for (var dayData in response) {
        final date = DateTime.parse(dayData['date']);
        if (date.year == year && date.month == month) {
          final expensesData = dayData['expenses'] as List<dynamic>? ?? [];

          final expenses = expensesData.map((e) {
            final data = Map<String, dynamic>.from(e);

            // ✅ Safely convert price to double
            if (data['price'] is int) {
              data['price'] = (data['price'] as int).toDouble();
            } else if (data['price'] is String) {
              data['price'] = double.tryParse(data['price']) ?? 0.0;
            }

            return ExpensesModel.fromJson(data);
          }).toList();

          // ✅ Safely sum up the total
          total += expenses.fold<double>(0.0, (sum, exp) => sum + exp.price);
        }
      }

      return total;
    } catch (e) {
      print('Error calculating monthly total: $e');
      return 0.0;
    }
  }

  // Get all expenses for a given month and year
  static Future<List<ExpensesModel>> getMonthlyExpenses(
    int year,
    int month,
  ) async {
    try {
      final response = await Supabase.instance.client
          .from('days_data')
          .select('expenses, date');

      // ignore: unnecessary_null_comparison
      if (response == null) return [];

      List<ExpensesModel> monthlyExpenses = [];

      for (var dayData in response) {
        final date = DateTime.parse(dayData['date']);
        if (date.year == year && date.month == month) {
          final expensesData = dayData['expenses'] as List<dynamic>? ?? [];

          final expenses = expensesData.map((e) {
            final data = Map<String, dynamic>.from(e);

            // ✅ Safely convert price to double
            if (data['price'] is int) {
              data['price'] = (data['price'] as int).toDouble();
            } else if (data['price'] is String) {
              data['price'] = double.tryParse(data['price']) ?? 0.0;
            }

            return ExpensesModel.fromJson(data);
          }).toList();

          monthlyExpenses.addAll(expenses);
        }
      }

      return monthlyExpenses;
    } catch (e) {
      print('Error fetching monthly expenses: $e');
      return [];
    }
  }

  static Future<double> getMonthTotalFromDailyTotals(
    int year,
    int month,
  ) async {
    try {
      final response = await Supabase.instance.client
          .from('days_data')
          .select('total, date');

      // ignore: unnecessary_null_comparison
      if (response == null) return 0.0;

      double monthlyTotal = 0.0;

      for (var dayData in response) {
        final date = DateTime.parse(dayData['date']);
        if (date.year == year && date.month == month) {
          final dayTotal = dayData['total'];
          if (dayTotal is num) {
            monthlyTotal += dayTotal.toDouble();
          }
        }
      }

      return monthlyTotal;
    } catch (e) {
      print('Error calculating monthly total from daily totals: $e');
      return 0.0;
    }
  }

  static Future<List<double>> getMonthlyTotalDetails(
    int year,
    int month,
  ) async {
    try {
      final response = await Supabase.instance.client
          .from('days_data')
          .select('total, date');

      // ignore: unnecessary_null_comparison
      if (response == null) return [];

      List<Map<String, dynamic>> filteredDays = [];

      for (var dayData in response) {
        final date = DateTime.parse(dayData['date']);
        if (date.year == year && date.month == month) {
          filteredDays.add({
            'date': date,
            'total': dayData['total'] is num
                ? dayData['total'].toDouble()
                : 0.0,
          });
        }
      }

      filteredDays.sort(
        (a, b) => (a['date'] as DateTime).compareTo(b['date'] as DateTime),
      );

      return filteredDays.map<double>((day) => day['total'] as double).toList();
    } catch (e) {
      print('Error fetching monthly total details: $e');
      return [];
    }
  }
}
