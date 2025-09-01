import 'package:ferum/models/enum.dart';

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
      start: json['start'] != null ? DateTime.parse(json['start']) : null,
      end: json['end'] != null ? DateTime.parse(json['end']) : null,
      day: json['day'],
      durationSec: json['durationSec'],
      distanceMeters: (json['distanceMeters'] as num?)?.toDouble(),
      caloriesKcal: (json['caloriesKcal'] as num?)?.toDouble(),
      avgHeartRate: (json['avgHeartRate'] as num?)?.toDouble(),
      grade: (json['grade'] as num?)?.toDouble(),
      aiReview: json['aiReview'],
      plan: ((json['plan'] as List?) ?? [])
          .map((e) => WorkoutBloc.fromJson(e as Map<String, dynamic>))
          .toList(),
      performanceDetails: (json['performanceDetails'] as List?)
          ?.map((e) => PerformanceDetail.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'sport': sport,
    'type': type,
    'status': status,
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

class WorkoutBloc {
  final int blocId;
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

class BlocDetail {
  final int blocDetailId;
  final int durationSec;
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
