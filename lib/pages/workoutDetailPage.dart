import 'package:ferum/models/enum.dart';
import 'package:flutter/material.dart';

import '../models/workout_model.dart';

import '../widgets/workoutDetailCard.dart';
import '../widgets/infoCard.dart';

const kBlue = Color(0xFF3B82F6); // App primary blue
const kPurple = Color(0xFF8B5CF6); // App accent purple

class WorkoutDetailPage extends StatelessWidget {
  final String id;
  const WorkoutDetailPage({super.key, required this.id});

  String _formatDuration(int minutes) {
    final h = minutes ~/ 60;
    final m = minutes % 60;
    if (h > 0 && m > 0) return '${h}h ${m}min';
    if (h > 0) return '${h}h';
    return '${m}min';
  }

  String _formatDistance(num? value, WorkoutSport sport) {
    if (value == null) return '-';
    // Heuristic: swimming shown in meters, others in km
    if (sport == WorkoutSport.SWIMMING) {
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
      appBar: AppBar(
        title: Row(
          children: [
            if (workout.workoutSport == WorkoutSport.RUNNING)
              const Icon(Icons.directions_run, size: 35, color: Colors.purple),
            if (workout.workoutSport == WorkoutSport.CYCLING)
              const Icon(Icons.directions_bike, size: 35, color: Colors.purple),
            if (workout.workoutSport == WorkoutSport.SWIMMING)
              const Icon(Icons.pool, size: 35, color: Colors.purple),
            const SizedBox(width: 8),
            Text(
              workout.workoutType.toString().split('.').last,
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                  border: Border.all(color: Colors.black12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_today,
                          size: 18,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          workout.day != null
                              ? 'Jour: ${workout.day}'
                              : 'Jour: —',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.timer, size: 18, color: Colors.grey),
                        const SizedBox(width: 8),
                        Text(
                          'Durée: ' + _formatDuration(durationMinutes),
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 16),

              if (workout.done) ...[
                Text(
                  "Résulats",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InfoCard(
                      title: "${workout.distanceMeters} km",
                      size: 100,
                      fontSize: 16,
                      useGradient: true,
                    ),
                    SizedBox(width: 10),
                    InfoCard(
                      title:
                          "Moyenne ${workout.avgBPM?.toStringAsFixed(0)} BPM",
                      size: 100,
                      fontSize: 16,
                      useGradient: true,
                    ),
                    SizedBox(width: 10),
                    InfoCard(
                      title: "${workout.kcal?.toStringAsFixed(0)} kcal",
                      size: 100,
                      fontSize: 16,
                      useGradient: true,
                    ),
                    SizedBox(width: 10),
                  ],
                ),
                SizedBox(height: 10),
                const Divider(),
                const SizedBox(height: 16),
              ],

              Text(
                "Programme",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),

              // --- Étapes (aperçu statique) ---
              //échauffement
              StepBlock(
                number: 1,
                children: [
                  workoutDetailCard(
                    title: '15 min à 6:34 - 7:04\'/km',
                    tag: 'EF',
                    tagColor: Colors.blue.shade900,
                    transparentBorder: true,
                  ),
                ],
              ),
              SizedBox(height: 16),
              // Training part)
              StepBlock(
                number: 2,
                nbRepetition: 7,
                children: [
                  workoutDetailCard(
                    title: '3 min à 5:09/km',
                    tag: 'Seuil 60',
                    tagColor: Colors.purple,
                  ),
                  SizedBox(height: 8),
                  workoutDetailCard(
                    title: '1:30 min de récup.',
                    tag: 'Récup',
                    tagColor: Colors.purple,
                  ),
                ],
              ),
              SizedBox(height: 16),
              //Récuperation
              StepBlock(
                number: 3,
                children: [
                  workoutDetailCard(
                    title: '5 min de récup. à 6:34 - 7:04\'/km',
                    tag: 'EF',
                    tagColor: Colors.blue.shade900,
                    transparentBorder: true,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
