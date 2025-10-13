class ExpensesModel {
  final String name;
  final double price;

  ExpensesModel({required this.name, required this.price});

  factory ExpensesModel.fromJson(Map<String, dynamic> json) {
    return ExpensesModel(
      name: json['name'] as String,
      price: json['price'] as double,
    );
  }

  Map<String, dynamic> toJson() {
    return {"name": name, "price": price};
  }
}
