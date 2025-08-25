import 'package:flutter/material.dart';

import '../models/enum.dart';
import '../models/workoutLight_model.dart';

import 'infoCard.dart';

class workoutLightCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final WorkoutLightClass workout;

  const workoutLightCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.workout,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: (workout.statut == WorkoutStatut.DONE)
                ? Colors.purple
                : Colors.black12,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${workout.day}",
                      style: TextStyle(fontSize: 12, color: Colors.black),
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        if (workout.type == WorkoutType.EF)
                          Text(
                            "Endurance fondamentale",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: (workout.statut == WorkoutStatut.DONE)
                                  ? Colors.purple
                                  : Colors.black,
                            ),
                          )
                        else if (workout.type == WorkoutType.INTERVAL)
                          Text(
                            "Entrainement de fractionné",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: (workout.statut == WorkoutStatut.DONE)
                                  ? Colors.purple
                                  : Colors.black,
                            ),
                          )
                        else if (workout.type == WorkoutType.LACTATE)
                          Text(
                            "Entrainement tempo",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: (workout.statut == WorkoutStatut.DONE)
                                  ? Colors.purple
                                  : Colors.black,
                            ),
                          ),
                        if (workout.statut == WorkoutStatut.DONE) ...[
                          SizedBox(width: 10),
                          Icon(
                            Icons.check_circle_outline_sharp,
                            color: Colors.purple,
                          ),
                        ],
                      ],
                    ), //ici
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(width: 10),
                        if (workout.duration > 60)
                          InfoCard(
                            title: " ${formatDuration(workout.duration)}",
                          ),
                        if (workout.duration < 60)
                          InfoCard(title: " ${workout.duration} \nmin"),
                        SizedBox(width: 100),
                      ],
                    ),
                  ],
                ),
                Column(
                  children: [
                    if (workout.sport == WorkoutSport.RUNNING) ...[
                      const Icon(
                        Icons.directions_run,
                        size: 28,
                        color: Colors.purple,
                      ),
                    ],

                    if (workout.sport == WorkoutSport.CYCLING) ...[
                      const Icon(
                        Icons.directions_bike,
                        size: 28,
                        color: Colors.purple,
                      ),
                    ],
                    if (workout.sport == WorkoutSport.SWIMMING) ...[
                      const Icon(Icons.pool, size: 28, color: Colors.purple),
                    ],

                    SizedBox(height: 10),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

String formatDuration(int totalMinutes) {
  final hours = totalMinutes ~/ 60;
  final minutes = totalMinutes % 60;
  return '${hours}h${minutes.toString().padLeft(2, '0')}';
}
