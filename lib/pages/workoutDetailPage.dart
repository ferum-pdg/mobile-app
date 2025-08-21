import 'package:ferum/models/enum.dart';
import 'package:flutter/material.dart';

import '../models/workout.dart';

class WorkoutDetailPage extends StatelessWidget {
  final WorkoutClass workout;
  const WorkoutDetailPage({super.key, required this.workout});

  String _formatDuration(int minutes) {
    final h = minutes ~/ 60;
    final m = minutes % 60;
    if (h > 0 && m > 0) return '${h}h ${m}min';
    if (h > 0) return '${h}h';
    return '${m}min';
  }

  String _formatDistance(num? value, workoutSport sport) {
    if (value == null) return '-';
    // Heuristic: swimming shown in meters, others in km
    if (sport == workoutSport.SWIMMING) {
      return '${value.toStringAsFixed(0)} m';
    }
    final km = value.toDouble();
    if (km >= 20) return '${km.toStringAsFixed(0)} km';
    return '${km.toStringAsFixed(1)} km';
  }

  @override
  Widget build(BuildContext context) {
    // Assume durationSec is expressed in minutes for display
    final durationMinutes = (workout.durationSec is int)
        ? workout.durationSec as int
        : (workout.durationSec ?? 0).toInt();

    return Scaffold(
      appBar: AppBar(title: Text(workout.name)),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.fitness_center),
                const SizedBox(width: 8),
                Text(
                  workout.workoutType.toString().split('.').last,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 16),
                Chip(
                  label: Text(workout.workoutSport.toString().split('.').last),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              workout.day != null ? 'Jour: ${workout.day}' : 'Jour: —',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              workout.Date != null ? 'Date: ${workout.Date}' : 'Date: —',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Durée: ' + _formatDuration(durationMinutes),
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Distance: ' +
                  _formatDistance(workout.distanceMeters, workout.workoutSport),
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 12),
            Text(
              workout.name,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Statut: ' + (workout.done ? 'Terminé' : 'À faire'),
              style: TextStyle(
                fontSize: 16,
                color: workout.done ? Colors.green : Colors.orange,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
