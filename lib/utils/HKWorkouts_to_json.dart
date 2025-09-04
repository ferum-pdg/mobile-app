import 'package:ferum/pigeons/healthkit_workout.g.dart';

// Convert a HealthKit workout object into a JSON-compatible map
Map<String, dynamic> hkWorkoutToJson(HKWorkoutData w) {
  return {
    "start": w.start,
    "end": w.end,
    "distance": w.distance,
    "avgSpeed": w.avgSpeed,
    "avgBPM": w.avgBPM,
    "maxBPM": w.maxBPM,
    // Heart rate time series: each point has timestamp + bpm
    "bpmDataPoints":
        w.bpmDataPoints
            ?.where((p) => p != null)
            .map((p) => {"ts": p!.timestamp, "bpm": p.bpm})
            .toList() ??
        [],
    // Speed/pace time series: each point has timestamp, km/h, and pace (min/km)
    "speedDataPoints":
        w.speedDataPoints
            ?.where((p) => p != null)
            .map(
              (p) => {
                "ts": p!.timestamp,
                "kmh": p.kmh,
                "pace_min_per_km": p.paceMinPerKm,
              },
            )
            .toList() ??
        [],
    "sport": w.sport,
    "caloriesKcal": w.caloriesKcal,
    "source": w.source,
  };
}
