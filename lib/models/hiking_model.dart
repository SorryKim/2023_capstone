import 'package:cloud_firestore/cloud_firestore.dart';

class HikingModel {
  final String id;
  int steps;
  double distance;
  double time;
  double calories;
  final Timestamp sendDate;

  HikingModel({
    this.id = '',
    this.steps = 0,
    this.distance = 0,
    this.time = 0,
    this.calories = 0,
    Timestamp? sendDate,
  }) : sendDate = sendDate ?? Timestamp(0, 0);

  factory HikingModel.fromMap(
      {required String id, required Map<String, dynamic> map}) {
    return HikingModel(
      id: id,
      steps: map['steps'] ?? 0,
      distance: map['distance'] ?? 0,
      time: map['time'] ?? 0,
      calories: map['calories'] ?? 0,
      sendDate: map['sendDate'] ?? Timestamp(0, 0),
    );
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = {};
    data['steps'] = steps;
    data['distance'] = distance;
    data['time'] = time;
    data['calories'] = calories;
    data['sendDate'] = sendDate;
    return data;
  }
}
