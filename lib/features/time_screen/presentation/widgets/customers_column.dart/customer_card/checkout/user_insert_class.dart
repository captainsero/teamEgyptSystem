class UserInsertClass {
  final String name;
  final String number;
  final String collage;
  final String notes;
  final List<dynamic> drinks;
  final int hoursSpent;

  UserInsertClass({
    required this.name,
    required this.number,
    required this.collage,
    required this.hoursSpent,
    required this.notes,
    required this.drinks,
  });

  factory UserInsertClass.fromjson(Map<String, dynamic> json) {
    return UserInsertClass(
      name: json['name'] as String,
      number: json['number'] as String,
      collage: json['collage'] as String,
      hoursSpent: json['hoursSpent'] as int,
      notes: json['notes'] as String,
      drinks: json['drinks'] as List,
    );
  }
}
