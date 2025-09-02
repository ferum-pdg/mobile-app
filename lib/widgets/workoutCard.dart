import 'package:flutter/material.dart';

import '../models/enum.dart';
import '../models/workoutLight_model.dart';

import 'infoCard.dart';
import 'tagBadge.dart';

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

class workoutLightCard extends StatelessWidget {
  final WorkoutLightClass workout;

  const workoutLightCard({super.key, required this.workout});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: (workout.status == WorkoutStatut.COMPLETED)
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
                      getFrenchDay(workout.day),
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
                              color: (workout.status == WorkoutStatut.COMPLETED)
                                  ? Colors.purple
                                  : Colors.black,
                            ),
                          )
                        else if (workout.type == WorkoutType.EA)
                          Text(
                            "Tempo",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: (workout.status == WorkoutStatut.COMPLETED)
                                  ? Colors.purple
                                  : Colors.black,
                            ),
                          )
                        else if (workout.type == WorkoutType.LACTATE)
                          Text(
                            "Endurance active",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: (workout.status == WorkoutStatut.COMPLETED)
                                  ? Colors.purple
                                  : Colors.black,
                            ),
                          )
                        else if (workout.type == WorkoutType.INTERVAL)
                          Text(
                            "Intervalles",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: (workout.status == WorkoutStatut.COMPLETED)
                                  ? Colors.purple
                                  : Colors.black,
                            ),
                          )
                        else if (workout.type == WorkoutType.TECHNIC)
                          Text(
                            "Technique",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: (workout.status == WorkoutStatut.COMPLETED)
                                  ? Colors.purple
                                  : Colors.black,
                            ),
                          )
                        else if (workout.type == WorkoutType.RA)
                          Text(
                            "Récupération active",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: (workout.status == WorkoutStatut.COMPLETED)
                                  ? Colors.purple
                                  : Colors.black,
                            ),
                          ),

                        if (workout.status == WorkoutStatut.COMPLETED) ...[
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
                        if (workout.duration > 3600)
                          InfoCard(
                            title:
                                " ${formatDuration((workout.duration / 60).toInt())}",
                          ),
                        if (workout.duration <= 3600)
                          InfoCard(
                            title: " ${(workout.duration / 60).toInt()} \nmin",
                          ),
                        SizedBox(width: 15),
                        if (workout.sport == WorkoutSport.RUNNING)
                          TagBadge(text: "RUNNING", color: Colors.purple)
                        else if (workout.sport == WorkoutSport.CYCLING)
                          TagBadge(text: "CYCLISME", color: Colors.green)
                        else if (workout.sport == WorkoutSport.SWIMMING)
                          TagBadge(text: "NATATION", color: Colors.blue),
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
