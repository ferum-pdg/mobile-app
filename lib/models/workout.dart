import 'package:ferum/models/enum.dart';

class WorkoutClass {
  final int id;
  final String name;
  final bool done;
  final DateTime Date;
  final workoutType;
  final workoutSport;

  WorkoutClass({
    required this.id,
    required this.name,
    required this.done,
    required this.Date,
    required this.workoutType,
    required this.workoutSport,
  });

  factory WorkoutClass.fromJson(Map<String, dynamic> json) {
    return WorkoutClass(
      id: json['id'],
      name: json['name'],
      done: json['done'],
      Date: json['Date'],
      workoutType: json['workoutType'],
      workoutSport: json['workoutSport'],
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}
