import 'package:pigeon/pigeon.dart';

// Heart rate measurement point coming from HealthKit
class BPMDataPoint {
  String? timestamp; // ISO8601 timestamp
  double? bpm;
}

// Speed/pace measurement point coming from HealthKit
class SpeedDataPoint {
  String? timestamp; // ISO8601 timestamp
  double? kmh;
  double? paceMinPerKm; // minutes per km
}

class HKWorkoutData {
  String? start; // ISO8601
  String? end; // ISO8601
  // Distance covered (meters, as provided by HealthKit)
  double? distance;
  double? avgSpeed;
  double? avgBPM;
  double? maxBPM;
  List<BPMDataPoint?>? bpmDataPoints;
  List<SpeedDataPoint?>? speedDataPoints;
  String? sport;
  // Energy burned in kilocalories
  double? caloriesKcal;
  // Source app/device that recorded the workout
  String? source;
}

// Pigeon API definition to fetch workouts from iOS HealthKit
@HostApi()
abstract class HealthKitWorkoutApi {
  List<HKWorkoutData?> getWorkouts();
}
