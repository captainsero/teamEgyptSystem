class UsersClass {
  final String name;
  final String number;
  final String collage;
  DateTime startTimer = DateTime.now();
  final int totalTime;
  final int points;
  final String code;
  final String barcodeUrl;
  final String partnershipCode;

  UsersClass({
    required this.totalTime,
    required this.points,
    required this.name,
    required this.number,
    required this.collage,
    required this.code,
    required this.barcodeUrl,
    required this.partnershipCode,
  });
}
