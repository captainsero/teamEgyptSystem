import 'package:flutter/material.dart';

class ReservationModel {
  final String name;
  final String number;
  final String room;
  double price;
  final DateTime date;
  final TimeOfDay from;
  final TimeOfDay to;

  ReservationModel({
    required this.name,
    required this.number,
    required this.room,
    required this.price,
    required this.date,
    required this.from,
    required this.to,
  });

  factory ReservationModel.fromJson(Map<String, dynamic> json) {
    final fromParts = (json['from'] as String).split(':');
    final toParts = (json['to'] as String).split(':');

    return ReservationModel(
      name: json['name'] as String,
      number: json['number'] as String,
      room: json['room'] as String,
      price: (json['price'] as num).toDouble(),
      date: DateTime.parse(json['date']),
      from: TimeOfDay(
        hour: int.parse(fromParts[0]),
        minute: int.parse(fromParts[1]),
      ),
      to: TimeOfDay(hour: int.parse(toParts[0]), minute: int.parse(toParts[1])),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "number": number,
      "room": room,
      "date": date.toIso8601String(),
      "from": "${from.hour}:${from.minute.toString().padLeft(2, '0')}",
      "to": "${to.hour}:${to.minute.toString().padLeft(2, '0')}",
      "price": price,
    };
  }
}
