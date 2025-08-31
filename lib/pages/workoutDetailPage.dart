import 'package:ferum/models/enum.dart';
import 'package:flutter/material.dart';

import '../models/workout_model.dart';

import '../widgets/workoutDetailCard.dart';
import '../widgets/infoCard.dart';

import 'package:ferum/services/Workout_service.dart';

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
    _future = _service.fetchWorkoutById(id: widget.id);
  }

  String _formatDuration(int minutes) {
    final h = minutes ~/ 60;
    final m = minutes % 60;
    if (h > 0 && m > 0) return '${h}h ${m}min';
    if (h > 0) return '${h}h';
    return '${m}min';
  }

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

  String _formatDistance(num? meters, WorkoutSport sport) {
    if (meters == null) return '-';
    if (sport == WorkoutSport.SWIMMING) {
      return '${meters.toStringAsFixed(0)} m';
    }
    final km = meters.toDouble() / 1000.0;
    if (km >= 20) return '${km.toStringAsFixed(0)} km';
    return '${km.toStringAsFixed(1)} km';
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<WorkoutClass>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
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
        // Assume durationSec is expressed in seconds for display
        final durationMinutes = (workout.durationSec / 60).round();

        return Scaffold(
          appBar: AppBar(
            title: Row(
              children: [
                if (workout.workoutSport == WorkoutSport.RUNNING)
                  const Icon(
                    Icons.directions_run,
                    size: 35,
                    color: Colors.purple,
                  ),
                if (workout.workoutSport == WorkoutSport.CYCLING)
                  const Icon(
                    Icons.directions_bike,
                    size: 35,
                    color: Colors.purple,
                  ),
                if (workout.workoutSport == WorkoutSport.SWIMMING)
                  const Icon(Icons.pool, size: 35, color: Colors.purple),
                const SizedBox(width: 8),
                Text(
                  workout.workoutType.toString().split('.').last,
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
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

                  if (workout.status == 'COMPLETED') ...[
                    Text(
                      "Résulats",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InfoCard(
                          title: _formatDistance(
                            workout.distanceMeters,
                            workout.workoutSport,
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
                    const Divider(),
                    const SizedBox(height: 16),
                  ],

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
                          StepBlock(
                            number: bloc.blocId,
                            nbRepetition: bloc.repetitionCount > 1
                                ? bloc.repetitionCount
                                : null,
                            children: [
                              ...bloc.details.map(
                                (d) => workoutDetailCard(
                                  title:
                                      '${_formatSec(d.durationSec)} • ${d.bpmMinTarget}-${d.bpmMaxTarget} BPM',
                                  tag: d.intensityZone,
                                  tagColor: _zoneColor(d.intensityZone),
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
