import 'package:ferum/models/enum.dart';

// Full workout model: includes schedule, planned steps (plan), and optional performance metrics
class WorkoutClass {
  final String id;
  final WorkoutSport sport;
  final WorkoutType type;
  final WorkoutStatut status;
  final DateTime? start;
  final DateTime? end;
  final String day;
  final int durationSec;
  final double? distanceMeters;
  final double? caloriesKcal;
  final double? avgHeartRate;
  final double? grade;
  final String? aiReview;
  final List<WorkoutBloc> plan;
  final List<PerformanceDetail>? performanceDetails;

  WorkoutClass({
    required this.id,
    required this.sport,
    required this.type,
    required this.status,
    this.start,
    this.end,
    required this.day,
    required this.durationSec,
    this.distanceMeters,
    this.caloriesKcal,
    this.avgHeartRate,
    this.grade,
    this.aiReview,
    required this.plan,
    this.performanceDetails,
  });

  factory WorkoutClass.fromJson(Map<String, dynamic> json) {
    return WorkoutClass(
      id: json['id'],
      // Parse required sport enum from its string name; throws if unknown
      sport: WorkoutSport.values.firstWhere(
        (e) => e.name == json['sport'],
        orElse: () => throw Exception("Invalid sport: ${json['sport']}"),
      ),
      // Parse required workout type enum from its string name; throws if unknown
      type: WorkoutType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => throw Exception("Invalid type: ${json['type']}"),
      ),
      // Parse required status enum from its string name; throws if unknown
      status: WorkoutStatut.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => throw Exception("Invalid statut: ${json['status']}"),
      ),
      // ISO-8601 timestamps; may be null when not scheduled
      start: json['start'] != null ? DateTime.parse(json['start']) : null,
      end: json['end'] != null ? DateTime.parse(json['end']) : null,
      day: json['day'],
      // Planned duration in seconds
      durationSec: json['durationSec'],
      // Optional metrics (units): distance in meters, calories in kcal, HR in bpm
      distanceMeters: (json['distanceMeters'] as num?)?.toDouble(),
      caloriesKcal: (json['caloriesKcal'] as num?)?.toDouble(),
      avgHeartRate: (json['avgHeartRate'] as num?)?.toDouble(),
      grade: (json['grade'] as num?)?.toDouble(),
      aiReview: json['aiReview'],
      // Planned steps (blocks) for the session
      plan: ((json['plan'] as List?) ?? [])
          .map((e) => WorkoutBloc.fromJson(e as Map<String, dynamic>))
          .toList(),
      // Optional post-workout metrics per block (actual vs planned)
      performanceDetails: (json['performanceDetails'] as List?)
          ?.map((e) => PerformanceDetail.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    // Enums are stored as enum objects here; using `.name` with the backend
    'type': type,
    'status': status,
    // Serialize dates as ISO-8601 strings
    'start': start?.toIso8601String(),
    'end': end?.toIso8601String(),
    'day': day,
    'durationSec': durationSec,
    'distanceMeters': distanceMeters,
    'caloriesKcal': caloriesKcal,
    'avgHeartRate': avgHeartRate,
    'grade': grade,
    'aiReview': aiReview,
    'plan': plan.map((e) => e.toJson()).toList(),
    'performanceDetails': performanceDetails?.map((e) => e.toJson()).toList(),
  };
}

// A step (block) of the workout: repeatable group of one or more details
class WorkoutBloc {
  final int blocId;
  // Number of times this block should be repeated
  final int repetitionCount;
  final List<BlocDetail> details;

  WorkoutBloc({
    required this.blocId,
    required this.repetitionCount,
    required this.details,
  });

  factory WorkoutBloc.fromJson(Map<String, dynamic> json) {
    return WorkoutBloc(
      blocId: (json['blocId'] as num).toInt(),
      // Number of times this block should be repeated
      repetitionCount: (json['repetitionCount'] as num).toInt(),
      details: (json['details'] as List<dynamic>)
          .map((e) => BlocDetail.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'blocId': blocId,
    'repetitionCount': repetitionCount,
    'details': details.map((e) => e.toJson()).toList(),
  };
}

// Atomic instruction inside a block: duration + target HR range + intensity zone
class BlocDetail {
  final int blocDetailId;
  // Duration in seconds
  final int durationSec;
  // Target HR range in bpm
  final int bpmMinTarget;
  final int bpmMaxTarget;
  final String intensityZone;

  BlocDetail({
    required this.blocDetailId,
    required this.durationSec,
    required this.bpmMinTarget,
    required this.bpmMaxTarget,
    required this.intensityZone,
  });

  factory BlocDetail.fromJson(Map<String, dynamic> json) {
    return BlocDetail(
      blocDetailId: (json['blocDetailId'] as num).toInt(),
      durationSec: (json['durationSec'] as num).toInt(),
      bpmMinTarget: (json['bpmMinTarget'] as num).toInt(),
      bpmMaxTarget: (json['bpmMaxTarget'] as num).toInt(),
      intensityZone: json['intensityZone'],
    );
  }

  Map<String, dynamic> toJson() => {
    'blocDetailId': blocDetailId,
    'durationSec': durationSec,
    'bpmMinTarget': bpmMinTarget,
    'bpmMaxTarget': bpmMaxTarget,
    'intensityZone': intensityZone,
  };
}

// Measured performance for a single block: planned BPM range vs actual mean
class PerformanceDetail {
  final int blocId;
  final int plannedBPMMin;
  final int plannedBPMMax;
  final int actualBPMMean;

  PerformanceDetail({
    required this.blocId,
    required this.plannedBPMMin,
    required this.plannedBPMMax,
    required this.actualBPMMean,
  });

  factory PerformanceDetail.fromJson(Map<String, dynamic> json) {
    return PerformanceDetail(
      blocId: (json['blocId'] as num).toInt(),
      plannedBPMMin: (json['plannedBPMMin'] as num).toInt(),
      plannedBPMMax: (json['plannedBPMMax'] as num).toInt(),
      actualBPMMean: (json['actualBPMMean'] as num).toInt(),
    );
  }

  Map<String, dynamic> toJson() => {
    'blocId': blocId,
    'plannedBPMMin': plannedBPMMin,
    'plannedBPMMax': plannedBPMMax,
    'actualBPMMean': actualBPMMean,
  };
}
