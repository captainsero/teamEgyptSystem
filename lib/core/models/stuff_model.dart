import 'package:flutter/material.dart';

class StuffModel {
  final String name;
  final String number;
  final String position;
  TimeOfDay checkIn;
  TimeOfDay checkOut;
  bool isIn;

  StuffModel({
    required this.name,
    required this.number,
    required this.position,
    required this.checkIn,
    required this.checkOut,
    required this.isIn,
  });

  factory StuffModel.fromJson(Map<String, dynamic> json) {
    final fromParts = (json['check_in'] as String).split(':');
    final toParts = (json['check_out'] as String).split(':');

    return StuffModel(
      name: json['name'] as String,
      number: json['number'] as String,
      position: json['position'] as String,
      checkIn: TimeOfDay(
        hour: int.parse(fromParts[0]),
        minute: int.parse(fromParts[1]),
      ),
      checkOut: TimeOfDay(
        hour: int.parse(toParts[0]),
        minute: int.parse(toParts[1]),
      ),
      isIn: json['is_in'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "number": number,
      "position": position,
      "check_in":
          "${checkIn.hour}:${checkIn.minute.toString().padLeft(2, '0')}",
      "check_out":
          "${checkOut.hour}:${checkOut.minute.toString().padLeft(2, '0')}",
      "is_in": isIn,
    };
  }
}
