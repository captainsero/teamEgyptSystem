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
            .from("teamegypt-users-data")
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

  static Future<UsersClass?> getUsersDataByCode(String code) async {
    try {
      final response = await Supabase.instance.client
          .from('teamegypt-users-data')
          .select()
          .eq('code', code)
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
          partnershipCode: response['partnership_code'] ?? '0000',
        );
      } else {
        print('No user found for code: $code');
        return null;
      }
    } catch (e) {
      print("Error fetching user: $e");
      return null;
    }
  }

  static Future<UsersClass?> getUsersDataByNumber({
    required String number,
  }) async {
    try {
      final response = await Supabase.instance.client
          .from('teamegypt-users-data')
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
          .from("teamegypt-users-data")
          .select()
          .range(offset, offset + limit - 1); // range is inclusive
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print("Error in paginated fetch: $e");
      return [];
    }
  }
}
