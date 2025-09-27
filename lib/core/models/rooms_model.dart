class RoomsModel {
  final String name;
  final double price;
  final int reservationNum;

  RoomsModel({
    required this.name,
    required this.price,
    required this.reservationNum,
  });

  factory RoomsModel.fromJson(Map<String, dynamic> json) {
    return RoomsModel(
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      reservationNum: (json['reservation_num'] ?? 0) as int,
    );
  }
}
