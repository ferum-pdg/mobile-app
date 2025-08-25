import 'package:flutter/material.dart';

import '../models/enum.dart';
import '../models/workout.dart';

import 'infoCard.dart';

class workoutCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final WorkoutClass workout;

  const workoutCard({
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
            color: workout.done ? Colors.purple : Colors.black12,
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
                        if (workout.workoutType == WorkoutType.EF)
                          Text(
                            "Endurance fondamentale",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: workout.done
                                  ? Colors.purple
                                  : Colors.black,
                            ),
                          )
                        else if (workout.workoutType == WorkoutType.FRACTIONNE)
                          Text(
                            "Entrainement de fractionné",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: workout.done
                                  ? Colors.purple
                                  : Colors.black,
                            ),
                          )
                        else if (workout.workoutType == WorkoutType.TEMPO)
                          Text(
                            "Entrainement tempo",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: workout.done
                                  ? Colors.purple
                                  : Colors.black,
                            ),
                          ),
                        if (workout.done) ...[
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
                        if (workout.workoutSport == WorkoutSport.RUNNING)
                          InfoCard(title: "${workout.distanceMeters} \nkm"),
                        if (workout.workoutSport == WorkoutSport.CYCLING)
                          InfoCard(
                            title:
                                "${workout.distanceMeters.toStringAsFixed(0)} \nkm",
                          ),
                        if (workout.workoutSport == WorkoutSport.SWIMMING)
                          InfoCard(
                            title:
                                "${workout.distanceMeters.toStringAsFixed(0)} \n  m",
                          ),
                        SizedBox(width: 10),
                        if (workout.durationSec > 60)
                          InfoCard(
                            title: " ${formatDuration(workout.durationSec)}",
                          ),
                        if (workout.durationSec < 60)
                          InfoCard(title: " ${workout.durationSec} \nmin"),
                        SizedBox(width: 100),
                      ],
                    ),
                  ],
                ),
                Column(
                  children: [
                    if (workout.workoutSport == WorkoutSport.RUNNING) ...[
                      const Icon(
                        Icons.directions_run,
                        size: 28,
                        color: Colors.purple,
                      ),
                    ],

                    if (workout.workoutSport == WorkoutSport.CYCLING) ...[
                      const Icon(
                        Icons.directions_bike,
                        size: 28,
                        color: Colors.purple,
                      ),
                    ],
                    if (workout.workoutSport == WorkoutSport.SWIMMING) ...[
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
