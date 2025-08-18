import 'package:pigeon/pigeon.dart';

class BPMDataPoint {
  String? ts; // ISO8601 timestamp
  double? bpm;
}

class SpeedDataPoint {
  String? ts; // ISO8601 timestamp
  double? kmh;
  double? paceMinPerKm; // minutes per km
}

class HKWorkoutData {
  String? uuid;
  String? start; // ISO8601
  String? end; // ISO8601
  double? distance;
  double? avgSpeed;
  double? avgBPM;
  double? maxBPM;
  List<BPMDataPoint?>? bpmDataPoints;
  List<SpeedDataPoint?>? speedDataPoints;
}

@HostApi()
abstract class HealthKitWorkoutApi {
  List<HKWorkoutData?> getWorkouts();
}
