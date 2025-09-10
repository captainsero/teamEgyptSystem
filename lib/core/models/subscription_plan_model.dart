class SubscriptionPlanModel {
  final String name;
  final int days;
  final double price;
  final int subscriptionsNum;

  SubscriptionPlanModel({
    required this.name,
    required this.days,
    required this.price,
    required this.subscriptionsNum,
  });

  factory SubscriptionPlanModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionPlanModel(
      name: json['name'] as String,
      days: json['days'] as int,
      price: (json['price'] as num).toDouble(),
      subscriptionsNum: (json['subscription_num'] ?? 0) as int,
    );
  }
}
