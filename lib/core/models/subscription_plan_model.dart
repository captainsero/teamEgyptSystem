class SubscriptionPlanModel {
  final String name;
  final int days;
  final double price;
  final int subscriptionsNum;
  final int hours;

  SubscriptionPlanModel({
    required this.name,
    required this.days,
    required this.price,
    required this.subscriptionsNum,
    required this.hours,
  });

  factory SubscriptionPlanModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionPlanModel(
      name: json['name'] as String,
      days: json['days'] as int,
      price: (json['price'] as num).toDouble(),
      subscriptionsNum: (json['subscription_num'] ?? 0) as int,
      hours: (json['hours'] ?? 0) as int
    );
  }
}
