class TasksModel {
  final String name;
  final String staffName;
  final DateTime endDate;
  final bool done;

  TasksModel({
    required this.name,
    required this.staffName,
    required this.endDate,
    required this.done,
  });

  factory TasksModel.fromJson(Map<String, dynamic> json) {
    return TasksModel(
      name: json['name'] as String,
      staffName: json['staff_name'] as String,
      endDate: DateTime.parse(json['end_date'].toString()),
      done: json['done'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "staff_name": staffName,
      "end_date": endDate,
      "done": done,
    };
  }
}
