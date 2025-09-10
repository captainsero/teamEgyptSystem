import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:team_egypt_v3/core/models/subscription_model.dart';
import 'package:team_egypt_v3/core/models/subscription_plan_model.dart';

class SupabaseSubscriptions {
  static final supabase = Supabase.instance.client;

  static Future<bool> insertPlan(SubscriptionPlanModel plan) async {
    try {
      // ignore: unused_local_variable
      final response = await supabase.from('subscription_plans').insert({
        'name': plan.name,
        'days': plan.days,
        'price': plan.price,
        'subscription_num': plan.subscriptionsNum,
      });
      return true;
    } catch (e) {
      print("Error insert plan: $e");
      return false;
    }
  }

  static Future<List<SubscriptionPlanModel>> getPlans() async {
    try {
      final response =
          await supabase.from('subscription_plans').select() as List;
      return response
          .map((json) => SubscriptionPlanModel.fromJson(json))
          .toList();
    } catch (e) {
      print("Error get plans: $e");
      return [];
    }
  }

  static Future<String?> getPlanByName(String name) async {
    try {
      final response = await supabase
          .from('subscription_plans')
          .select()
          .eq('name', name);
      return response[0]['name'];
    } catch (e) {
      print("Error get plans: $e");
      return null;
    }
  }

  static Future<int> getPlanSub(String name) async {
    try {
      final response = await supabase
          .from("subscription_plans")
          .select()
          .eq('name', name);
      return response[0]['subscription_num'];
    } catch (e) {
      print("Error get PlanSub: $e");
      return 0;
    }
  }

  static Future<void> updatePlanSub(String name) async {
    int plan = await getPlanSub(name);
    try {
      // ignore: unused_local_variable
      final response = await supabase
          .from("subscription_plans")
          .update({'subscription_num': ++plan})
          .eq('name', name);
    } catch (e) {
      print("Error update PlanSub: $e");
    }
  }

  static Future<void> deletePlan(String name) async {
    try {
      // ignore: unused_local_variable
      final response = await supabase
          .from('subscription_plans')
          .delete()
          .eq('name', name);
    } catch (e) {
      print("Error deleting plan: $e");
    }
  }

  static Future<bool> insertSubscription(SubscriptionModel sub) async {
    try {
      final existing = await supabase
          .from('subscriptions')
          .select()
          .eq('number', sub.number);

      if (existing.isNotEmpty) {
        return false; // Duplicate found
      }

      await supabase.from('subscriptions').insert({
        'name': sub.name,
        'number': sub.number,
        'plan': sub.plan,
        'start_date': sub.startDate.toIso8601String(),
        'end_date': sub.endDate.toIso8601String(),
      });

      return true; // Successfully inserted
    } catch (e) {
      print("Error insert Subscription: $e");
      return false;
    }
  }

  static Future<List<SubscriptionModel>> getSubscriptions() async {
    try {
      final response = await supabase.from('subscriptions').select();
      return (response as List)
          .map((json) => SubscriptionModel.fromJson(json))
          .toList();
    } catch (e) {
      print("Error get Subscriptions: $e");
      return [];
    }
  }

  static Future<SubscriptionModel?> getSubscriptionByNumber(
    String number,
  ) async {
    try {
      final response = await supabase
          .from('subscriptions')
          .select()
          .eq('number', number);

      if (response.isEmpty) return null;

      return SubscriptionModel.fromJson(response[0]);
    } catch (e) {
      print("No Subscription with this number $number : $e");
      return null;
    }
  }

  static Future<void> deleteSubscription(String number) async {
    try {
      // ignore: unused_local_variable
      final response = await supabase
          .from('subscriptions')
          .delete()
          .eq('number', number);
    } catch (e) {
      print("Error deleting plan: $e");
    }
  }
}
