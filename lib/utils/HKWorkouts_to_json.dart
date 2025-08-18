import 'dart:convert';
import 'package:ferum/pigeons/healthkit_workout.g.dart';

Map<String, dynamic> hkWorkoutToJson(HKWorkoutData w) {
  return {
    "UUID": w.uuid,
    "start": w.start,
    "end": w.end,
    "distance": w.distance,
    "avgSpeed": w.avgSpeed,
    "avgBPM": w.avgBPM,
    "maxBPM": w.maxBPM,
    "BPMDataPoints":
        w.bpmDataPoints
            ?.where((p) => p != null)
            .map((p) => {"ts": p!.ts, "bpm": p.bpm})
            .toList() ??
        [],
    "SpeedDataPoints":
        w.speedDataPoints
            ?.where((p) => p != null)
            .map(
              (p) => {
                "ts": p!.ts,
                "kmh": p.kmh,
                "pace_min_per_km": p.paceMinPerKm,
              },
            )
            .toList() ??
        [],
  };
}
