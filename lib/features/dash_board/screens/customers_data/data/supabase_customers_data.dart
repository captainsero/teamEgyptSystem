import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:team_egypt_v3/core/models/users_class.dart';

class SupabaseCustomersData {
  static Future<bool> insertUserData({
    required BuildContext context,
    required String name,
    required String number,
    required String collage,
    required String partnershipCode,
  }) async {
    try {
      final UsersClass? user1 = await getUsersDataByNumber(number: number);
      if (user1 != null) {
        return false;
      } else {
        // ignore: unused_local_variable
        final response = await Supabase.instance.client
            .from("teamegypt_users_data")
            .insert({
              "name": name,
              "number": number,
              "collage": collage,
              'partnership_code': partnershipCode,
            })
            .select("*");

        return true;
      }
    } catch (e) {
      print("Error insert user: $e");
      return false;
    }
  }

  static Future<UsersClass?> getUsersDataByNumber({
    required String number,
  }) async {
    try {
      final response = await Supabase.instance.client
          .from('teamegypt_users_data')
          .select()
          .eq('number', number)
          .maybeSingle();

      if (response != null) {
        return UsersClass(
          name: response['name'],
          number: response['number'],
          collage: response['collage'],
          code: response['code'],
          totalTime: response['total_time'] ?? 0,
          points: response['points'] ?? 0,
          barcodeUrl: response['barcode_url'] ?? '',
          partnershipCode: response['partnership_code'] ?? '',
        );
      } else {
        print('No user found for code: $number');
        return null;
      }
    } catch (e) {
      print("Error fetching user: $e");
      return null;
    }
  }

  static Future<List<Map<String, dynamic>>> getUsersPaginated({
    required int limit,
    required int offset,
  }) async {
    try {
      final response = await Supabase.instance.client
          .from("teamegypt_users_data")
          .select()
          .range(offset, offset + limit - 1); // range is inclusive
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print("Error in paginated fetch: $e");
      return [];
    }
  }

  // Update user data by number
  static Future<bool> updateUserData({
    required String number,
    String? name,
    String? collage,
    String? partnershipCode,
    int? totalTime,
    int? points,
    String? barcodeUrl,
    String? code,
  }) async {
    try {
      final updateData = <String, dynamic>{};
      if (name != null) updateData['name'] = name;
      if (collage != null) updateData['collage'] = collage;
      if (partnershipCode != null) {
        updateData['partnership_code'] = partnershipCode;
      }
      if (totalTime != null) updateData['total_time'] = totalTime;
      if (points != null) updateData['points'] = points;
      if (barcodeUrl != null) updateData['barcode_url'] = barcodeUrl;
      if (code != null) updateData['code'] = code;

      await Supabase.instance.client
          .from("teamegypt_users_data")
          .update(updateData)
          .eq('number', number);

      return true;
    } catch (e) {
      print("Error updating user: $e");
      return false;
    }
  }

  // Delete user by number
  static Future<bool> deleteUserByNumber({required String number}) async {
    try {
      await Supabase.instance.client
          .from("teamegypt_users_data")
          .delete()
          .eq('number', number);
      return true;
    } catch (e) {
      print("Error deleting user: $e");
      return false;
    }
  }
}
