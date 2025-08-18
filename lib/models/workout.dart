import 'package:ferum/models/enum.dart';

class WorkoutClass {
  final int id;
  final String? accountId;
  final String? trainingPlanId;
  final workoutSport;
  final String name;
  final bool done;
  final DateTime Date;
  final workoutType;
  final int duration;
  final double distance;
  final String day;

  WorkoutClass({
    required this.id,
    this.accountId,
    this.trainingPlanId,
    required this.name,
    required this.done,
    required this.Date,
    required this.workoutType,
    required this.workoutSport,
    required this.duration,
    required this.distance,
    required this.day,
  });

  factory WorkoutClass.fromJson(Map<String, dynamic> json) {
    return WorkoutClass(
      id: json['id'],
      accountId: json['accountId'],
      trainingPlanId: json['trainingPlanId'],
      name: json['name'],
      done: json['done'],
      Date: json['Date'],
      workoutType: json['workoutType'],
      workoutSport: json['workoutSport'],
      duration: json['duration'],
      distance: json['distance'],
      day: json['day'],
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}
