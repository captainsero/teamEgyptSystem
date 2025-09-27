import 'package:team_egypt_v3/core/models/subscription_plan_model.dart';

class SubscriptionModel {
  final String name;
  final String number;
  final String plan;
  final int hours;
  final int planHours;
  final DateTime startDate;
  final DateTime endDate;

  SubscriptionModel({
    required this.name,
    required this.number,
    required this.plan,
    required this.hours,
    required this.planHours,
    required this.endDate,
  }) : startDate = DateTime.now();

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionModel(
      name: json['name'] as String,
      number: json['number'] as String,
      plan: json['plan'] as String,
      hours: json['hours'] as int,
      planHours: json['planHours'] as int,
      endDate: DateTime.parse(json['end_date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'number': number,
      'plan': plan,
      'hours': hours,
      'planHours': planHours,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
    };
  }

  /// ✅ calculate subscription duration in days
  int get durationDays {
    return endDate.difference(startDate).inDays;
  }

  /// ✅ check if subscription matches a plan
  bool matchesPlan(SubscriptionPlanModel planModel) {
    return durationDays == planModel.days;
  }
}
