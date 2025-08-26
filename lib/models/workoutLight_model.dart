import 'package:ferum/models/enum.dart';

class WorkoutLightClass {
  final String id;
  final WorkoutSport sport;
  final WorkoutType type;
  final WorkoutStatut status;
  final String day;
  final int duration;
  final int week;
  final String source;

  WorkoutLightClass({
    required this.id,
    required this.sport,
    required this.type,
    required this.status,
    required this.day,
    required this.duration,
    required this.week,
    required this.source,
  });

  factory WorkoutLightClass.fromJson(Map<String, dynamic> json) {
    return WorkoutLightClass(
      id: json['id'],
      sport: WorkoutSport.values.firstWhere(
        (e) => e.name == json['sport'],
        orElse: () => throw Exception("Invalid sport: ${json['sport']}"),
      ),
      type: WorkoutType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => throw Exception("Invalid type: ${json['type']}"),
      ),
      status: WorkoutStatut.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => throw Exception("Invalid statut: ${json['status']}"),
      ),
      day: json['day'],
      duration: json['duration'],
      week: json['week'],
      source: json['source'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'sport': sport.name,
    'type': type.name,
    'statut': status.name,
    'day': day,
    'duration': duration,
    'week': week,
    'source': source,
  };

  static List<WorkoutLightClass> fromJsonList(List<dynamic> list) {
    return list
        .map((e) => WorkoutLightClass.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  static List<Map<String, dynamic>> toJsonList(List<WorkoutLightClass> items) {
    return items.map((e) => e.toJson()).toList();
  }
}
