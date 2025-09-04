import 'package:ferum/models/enum.dart';

// Lightweight workout model used for lists and weekly summaries (no full step details)
class WorkoutLightClass {
  final String id;
  final WorkoutSport sport;
  final WorkoutType? type;
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
      // Parse sport enum from string; throw if invalid
      sport: WorkoutSport.values.firstWhere(
        (e) => e.name == json['sport'],
        orElse: () => throw Exception("Invalid sport: ${json['sport']}"),
      ),
      // Parse optional type enum; null when not provided
      type: json['type'] != null
          ? WorkoutType.values.firstWhere(
              (e) => e.name == json['type'],
              orElse: () => throw Exception("Invalid type: ${json['type']}"),
            )
          : null,
      // Parse workout status enum from string
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
    // ⚠️ Assumes type is non-null — will throw if not set
    'type': type!.name,
    // Note: key is "statut" (French) while fromJson expects "status" → potential mismatch
    'statut': status.name,
    'day': day,
    'duration': duration,
    'week': week,
    'source': source,
  };

  // Helper to decode a list of workouts from JSON
  static List<WorkoutLightClass> fromJsonList(List<dynamic> list) {
    return list
        .map((e) => WorkoutLightClass.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // Helper to encode a list of workouts into JSON
  static List<Map<String, dynamic>> toJsonList(List<WorkoutLightClass> items) {
    return items.map((e) => e.toJson()).toList();
  }
}
