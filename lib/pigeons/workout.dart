import 'package:pigeon/pigeon.dart';

class WorkoutData {
  String? type;
  double? totalDistance;
  double? totalEnergyBurned;
  double? avgHeartRate;
  double? maxHeartRate;
  double? avgPace;
  double? duration;
  String? startDate;
  String? endDate;
}

@HostApi()
abstract class Workouts {
  List<WorkoutData> getWorkouts();
}
