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
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (workout.workoutType == workoutType.EF)
                      Text(
                        "Endurance fondamentale",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: workout.done ? Colors.purple : Colors.black,
                        ),
                      )
                    else if (workout.workoutType == workoutType.FRACTIONNE)
                      Text(
                        "Entrainement de fractionné",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: workout.done ? Colors.purple : Colors.black,
                        ),
                      )
                    else if (workout.workoutType == workoutType.TEMPO)
                      Text(
                        "Entrainement temp",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: workout.done ? Colors.purple : Colors.black,
                        ),
                      ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            InfoCard(title: "5.3 \nkm"),
                            SizedBox(width: 10),
                            InfoCard(title: " 30 \nmin"),
                          ],
                        ),
                        Text(
                          "${workout.Date.day}.${workout.Date.month}.${workout.Date.year}",
                          style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const Icon(
                  Icons.directions_run,
                  size: 28,
                  color: Colors.purple,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
