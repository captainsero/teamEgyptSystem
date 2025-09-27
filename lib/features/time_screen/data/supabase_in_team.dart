import 'package:flutter/src/widgets/framework.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:team_egypt_v3/core/models/users_class.dart';
import 'package:team_egypt_v3/features/dash_board/screens/customers_data/data/supabase_customers_data.dart';
import 'package:team_egypt_v3/core/models/in_team_users.dart';

class SupabaseInTeam {
  static Future<InTeamUsers?> insertInTeam({
    required String number,
    required bool isSub,
    required BuildContext context,
  }) async {
    try {
      final UsersClass? user = await SupabaseCustomersData.getUsersDataByNumber(
        number: number,
      );
      if (user == null) return null;

      // ✅ Check if the user already exists in Supabase
      final existingUser = await Supabase.instance.client
          .from("in_team")
          .select()
          .eq("number", user.number)
          .maybeSingle();

      if (existingUser != null) {
        return null;
      }

      final now = DateTime.now();

      final response = await Supabase.instance.client.from("in_team").insert({
        "name": user.name,
        "number": user.number,
        "timer": now.toIso8601String(),
        "code": user.code,
        "collage": user.collage,
        'partnership_code': user.partnershipCode,
        'is_sub': isSub,
      }).select();

      if (response.isNotEmpty) {
        print("User inserted : ${response.first}");
        return InTeamUsers(
          name: user.name,
          number: user.number,
          timer: now,
          code: user.code,
          collage: user.collage,
          partnershipCode: user.partnershipCode,
          isSub: isSub,
        );
      } else {
        return null;
      }
    } catch (e) {
      print("Error insert user: $e");
      return null;
    }
  }

  static Future<InTeamUsers?> getInTeam(String number) async {
    try {
      final response = await Supabase.instance.client
          .from('in_team')
          .select()
          .eq('number', number)
          .maybeSingle();

      if (response != null) {
        return InTeamUsers(
          name: response['name'],
          number: response['number'],
          timer: DateTime.parse(response['timer']),
          code: response['code'],
          collage: response['collage'],
          partnershipCode: response['partnership_code'],
          isSub: response['is_sub'],
        );
      } else {
        print('No user found for number: $number');
        return null;
      }
    } catch (e) {
      print("Error fetching user: $e");
      return null;
    }
  }

  static Future<double> getTotal(DateTime date) async {
    try {
      final response = await Supabase.instance.client
          .from("days_data")
          .select()
          .eq("date", date);

      if (response.isNotEmpty) {
        final total = response[0]['total'];
        return total is double
            ? total
            : double.tryParse(total.toString()) ?? 0.0;
      }
      return 0.0;
    } catch (e) {
      print("Error: $e");
      return 0.0;
    }
  }

  static Future<void> deleteUser(String number) async {
    try {
      // ignore: unused_local_variable
      final response = await Supabase.instance.client
          .from('in_team')
          .delete()
          .eq('number', number);

      print('User with code $number deleted successfully from Supabase');
    } catch (e) {
      print("Error deleting user from Supabase: $e");
      rethrow; // Re-throw to handle in the cubit
    }
  }

  static Future<void> updateDaysData(
    DateTime date,
    double newTotal,
    List<Map<String, dynamic>> updatedUsers,
  ) async {
    try {
      final dateOnly = DateTime(date.year, date.month, date.day);

      await Supabase.instance.client
          .from("days_data")
          .update({'total': newTotal, 'users_data': updatedUsers})
          .eq('date', dateOnly);
    } catch (e) {
      print("Error while updating days data: $e");
    }
  }

  static Future<bool> updateInTeamUser({
    required String number,
    String? name,
    String? collage,
    String? code,
    String? partnershipCode,
    bool? isSub,
    DateTime? timer,
  }) async {
    try {
      final updateData = <String, dynamic>{};
      if (name != null) updateData['name'] = name;
      if (collage != null) updateData['collage'] = collage;
      if (code != null) updateData['code'] = code;
      if (partnershipCode != null) {
        updateData['partnership_code'] = partnershipCode;
      }
      if (isSub != null) updateData['is_sub'] = isSub;
      if (timer != null) updateData['timer'] = timer.toIso8601String();

      await Supabase.instance.client
          .from("in_team")
          .update(updateData)
          .eq('number', number);

      return true;
    } catch (e) {
      print("Error updating in_team user: $e");
      return false;
    }
  }
}
