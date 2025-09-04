import 'package:ferum/models/enum.dart';
import 'package:flutter/material.dart';

import '../models/workout_model.dart';

import '../widgets/workoutDetailCard.dart';
import '../widgets/infoCard.dart';

import 'package:ferum/services/Workout_service.dart';

// Workout details page: fetch by ID, then display summary, AI review, and the step-by-step plan
class WorkoutDetailPage extends StatefulWidget {
  final String id;
  const WorkoutDetailPage({super.key, required this.id});

  @override
  State<WorkoutDetailPage> createState() => _WorkoutDetailPageState();
}

class _WorkoutDetailPageState extends State<WorkoutDetailPage> {
  late final WorkoutService _service;
  late Future<WorkoutClass> _future;

  @override
  void initState() {
    super.initState();
    _service = WorkoutService();
    // Fetch once on init; result cached in _future for the FutureBuilder below
    _future = _service.fetchWorkoutById(id: widget.id);
  }

  // Format minutes as human-readable (e.g., 90 -> "1h 30min")
  String _formatDuration(int minutes) {
    final h = minutes ~/ 60;
    final m = minutes % 60;
    if (h > 0 && m > 0) return '${h}h ${m}min';
    if (h > 0) return '${h}h';
    return '${m}min';
  }

  // Format seconds as human-readable (supports h/min/s combinations)
  String _formatSec(int seconds) {
    final h = seconds ~/ 3600;
    final m = (seconds % 3600) ~/ 60;
    final s = seconds % 60;
    if (h > 0 && m > 0) return '${h}h ${m}min';
    if (h > 0) return '${h}h';
    if (m > 0 && s > 0) return '${m}min ${s}s';
    if (m > 0) return '${m}min';
    return '${s}s';
  }

  // Map intensity zone label to a consistent color used in the UI
  Color _zoneColor(String zone) {
    switch (zone) {
      case 'RECOVERY':
        return Colors.blue.shade900;
      case 'ENDURANCE':
        return Colors.blue;
      case 'TEMPO':
        return Colors.purple;
      case 'THRESHOLD':
        return Colors.deepPurple;
      case 'INTERVAL':
        return Colors.redAccent;
      default:
        return Colors.grey;
    }
  }

  // Localize weekday from English enum/name to French label
  String getFrenchDay(String englishDay) {
    switch (englishDay.toUpperCase()) {
      case "MONDAY":
        return "Lundi";
      case "TUESDAY":
        return "Mardi";
      case "WEDNESDAY":
        return "Mercredi";
      case "THURSDAY":
        return "Jeudi";
      case "FRIDAY":
        return "Vendredi";
      case "SATURDAY":
        return "Samedi";
      case "SUNDAY":
        return "Dimanche";
      default:
        return englishDay;
    }
  }

  // Distance formatting: meters for swimming, kilometers otherwise (rounded)
  String _formatDistance(num? meters, WorkoutSport sport) {
    if (meters == null) return '-';
    final bool isSwimming = (sport == WorkoutSport.SWIMMING);
    if (isSwimming) {
      return '${meters.toStringAsFixed(0)} m';
    }
    final km = meters.toDouble() / 1000.0;
    if (km >= 20) return '${km.toStringAsFixed(0)} km';
    return '${km.toStringAsFixed(1)} km';
  }

  // Color-code average BPM vs planned range: red=too high, orange=too low, green=within target
  Color _bpmColor(PerformanceDetail p) {
    if (p.actualBPMMean > p.plannedBPMMax) return Colors.redAccent; // trop haut
    if (p.actualBPMMean < p.plannedBPMMin) return Colors.orange; // trop bas
    return Colors.green; // dans la cible
  }

  // Helper to render planned BPM range as "min-max"
  String _plannedRange(PerformanceDetail p) =>
      '${p.plannedBPMMin}-${p.plannedBPMMax}';

  // Map sport to Material icon (fallback to a generic fitness icon)
  IconData _sportIcon(WorkoutSport sport) {
    switch (sport) {
      case WorkoutSport.RUNNING:
        return Icons.directions_run;
      case WorkoutSport.CYCLING:
        return Icons.directions_bike;
      case WorkoutSport.SWIMMING:
        return Icons.pool;
      default:
        return Icons.fitness_center;
    }
  }

  // Translate internal workout type to a user-facing label (FR)
  String _typeLabel(WorkoutType type) {
    switch (type) {
      case WorkoutType.EF:
        return 'Endurance fondamentale';
      case WorkoutType.EA:
        return 'Tempo';
      case WorkoutType.LACTATE:
        return 'Endurance active';
      case WorkoutType.INTERVAL:
        return 'Intervalles';
      case WorkoutType.TECHNIC:
        return 'Technique';
      case WorkoutType.RA:
        return 'Récupération active';
      default:
        return 'Séance';
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<WorkoutClass>(
      future: _future,
      builder: (context, snapshot) {
        // Show loading spinner while fetching the workout
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        // Error state with a minimal AppBar to allow back navigation
        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Text('Erreur lors du chargement: ${snapshot.error}'),
              ),
            ),
          );
        }
        final workout = snapshot.data!;
        // Convert server-provided seconds to minutes for display
        final durationMinutes = (workout.durationSec / 60).round();

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            elevation: 0,
            titleSpacing: 0,
            title: Row(
              children: [
                Icon(_sportIcon(workout.sport), size: 28, color: Colors.purple),
                const SizedBox(width: 8),
                Text(
                  _typeLabel(workout.type),
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                // Add a completion checkmark when the workout is marked as done
                if (workout.status == WorkoutStatut.COMPLETED) ...[
                  const SizedBox(width: 10),
                  const Icon(
                    Icons.check_circle_outline_sharp,
                    color: Colors.purple,
                  ),
                ],
              ],
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Summary card: date and planned duration
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
                                  ? 'Jour: ${getFrenchDay(workout.day)}'
                                  : 'Jour: —',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(
                              Icons.timer,
                              size: 18,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Durée: ${_formatDuration(durationMinutes)}',
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

                  // Results section is only visible once the workout is completed
                  if (workout.status == WorkoutStatut.COMPLETED) ...[
                    Text(
                      "Résulats",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    // Key metrics: distance, average HR, calories
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InfoCard(
                          title: _formatDistance(
                            workout.distanceMeters,
                            workout.sport,
                          ),
                          size: 100,
                          fontSize: 16,
                          useGradient: true,
                        ),
                        SizedBox(width: 10),
                        InfoCard(
                          title: workout.avgHeartRate != null
                              ? 'Moyenne ${workout.avgHeartRate!.toStringAsFixed(0)} BPM'
                              : 'Moyenne — BPM',
                          size: 100,
                          fontSize: 16,
                          useGradient: true,
                        ),
                        SizedBox(width: 10),
                        InfoCard(
                          title: workout.caloriesKcal != null
                              ? '${workout.caloriesKcal!.toStringAsFixed(0)} kcal'
                              : '— kcal',
                          size: 100,
                          fontSize: 16,
                          useGradient: true,
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    // Table of performance per block
                    if (workout.performanceDetails != null &&
                        workout.performanceDetails!.isNotEmpty) ...[
                      SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
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
                            const Text(
                              "Performance de l'entraînement",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              // Block-by-block comparison: planned BPM range vs actual mean BPM
                              child: DataTable(
                                columns: const [
                                  DataColumn(label: Text('Bloc')),
                                  DataColumn(label: Text('BPM planifié')),
                                  DataColumn(label: Text('BPM réel')),
                                ],
                                rows: workout.performanceDetails!.map((p) {
                                  return DataRow(
                                    cells: [
                                      DataCell(Text(p.blocId.toString())),
                                      DataCell(Text(_plannedRange(p))),
                                      DataCell(
                                        // Use background tint + border with the color from _bpmColor(p)
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: _bpmColor(
                                              p,
                                            ).withOpacity(0.15),
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            border: Border.all(
                                              color: _bpmColor(p),
                                            ),
                                          ),
                                          child: Text(
                                            p.actualBPMMean.toString(),
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: _bpmColor(p),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 16),
                    // AI-generated post-workout review/summary
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
                          Row(
                            children: [
                              const Text(
                                'Ferum',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.purple,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.blue.shade900,
                                      Colors.purple,
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Text(
                                  'AI',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "${workout.aiReview}",
                            textAlign: TextAlign.justify,
                            style: const TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                    const Divider(),
                    const SizedBox(height: 16),
                  ],

                  // Planned steps for the session (what to do)
                  Text(
                    "Programme",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),

                  if (workout.plan.isEmpty) ...[
                    Text(
                      'Aucun plan pour cette séance',
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ] else ...[
                    ...List.generate(workout.plan.length, (index) {
                      final bloc = workout.plan[index];
                      return Column(
                        children: [
                          // One step (bloc) of the workout, possibly repeated
                          StepBlock(
                            number: bloc.blocId,
                            nbRepetition: bloc.repetitionCount,
                            children: [
                              ...bloc.details.map(
                                (d) => workoutDetailCard(
                                  title:
                                      '${_formatSec(d.durationSec)} • ${d.bpmMinTarget}-${d.bpmMaxTarget} BPM',
                                  tag: d.intensityZone,
                                  tagColor: _zoneColor(d.intensityZone),
                                  // Visual de-emphasis for easy zones: no border for RECOVERY/ENDURANCE
                                  transparentBorder:
                                      d.intensityZone == 'RECOVERY' ||
                                      d.intensityZone == 'ENDURANCE',
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                        ],
                      );
                    }),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
