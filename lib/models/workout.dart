import 'package:ferum/models/enum.dart';

class WorkoutClass {
  final int id;
  final workoutSport;
  final String name;
  final bool done;
  final DateTime Date;
  final workoutType;
  final int durationSec;
  final double distanceMeters;
  final String day;
  final double? kcal;
  final double? avgBPM;

  WorkoutClass({
    required this.id,
    required this.name,
    required this.done,
    required this.Date,
    required this.workoutType,
    required this.workoutSport,
    required this.durationSec,
    required this.distanceMeters,
    required this.day,
    this.kcal,
    this.avgBPM,
  });

  factory WorkoutClass.fromJson(Map<String, dynamic> json) {
    return WorkoutClass(
      id: json['id'],
      name: json['name'],
      done: json['done'],
      Date: json['Date'],
      workoutType: json['workoutType'],
      workoutSport: json['workoutSport'],
      durationSec: json['duration'],
      distanceMeters: json['distance'],
      day: json['day'],
      kcal: json['kcal'],
      avgBPM: json['avgBPM'],
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}
