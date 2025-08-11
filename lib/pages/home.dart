import 'package:ferum/widgets/workoutCard.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../pigeons/workout.g.dart';
import '../pigeons/healthkit_authorization.g.dart';

import '../widgets/infoCard.dart';
import '../widgets/circularProgressBar.dart';

import '../models/workout.dart';
import '../models/enum.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final List<WorkoutClass> weeklyWokouts;
  @override
  void initState() {
    super.initState();
    initWeeklyWorkouts();

    //Demande authorisation
    authHealthKit
        .requestAuthorization()
        .then((isAuthorized) {
          if (isAuthorized == true) {
            loadWorkouts();
          } else {
            print("⚠️ Accès Apple Health refusé par l'utilisateur");
          }
        })
        .catchError((e) {
          print("❌ Erreur lors de la demande d'autorisation: $e");
        });
  }

  final workouts = Workouts();

  final workoutsApi = Workouts(); // API Pigeon pour les workouts

  final authHealthKit = HealthKitAuthorization(); // ✅ classe générée Pigeon

  Future<void> loadWorkouts() async {
    final workoutList = await workoutsApi.getWorkouts();
    for (var w in workoutList) {
      print(
        "🏃 Workout: ${w.type}, Start ${w.startDate}, End ${w.endDate}, Durée ${w.duration}, Distance ${w.totalDistance}, EnergyBurned ${w.totalEnergyBurned} FC moyenne: ${w.avgHeartRate}, FC max: ${w.maxHeartRate}, Allure: ${w.avgPace}",
      );
    }
  }

  Future<void> initWeeklyWorkouts() async {
    weeklyWokouts = [
      WorkoutClass(
        id: 1,
        name: "EF matin",
        done: false,
        Date: DateTime(2025, 1, 12),
        workoutType: workoutType.EF,
        workoutSport: workoutSport.RUNNING,
        duration: 30,
        distance: 5.3,
        day: "Mercredi",
      ),
      WorkoutClass(
        id: 2,
        name: "Fractionné running matin",
        done: true,
        Date: DateTime(2025, 1, 10),
        workoutType: workoutType.FRACTIONNE,
        workoutSport: workoutSport.RUNNING,
        duration: 45,
        distance: 7.8,
        day: "Mardi",
      ),
      WorkoutClass(
        id: 3,
        name: "Tempo natation soir",
        done: true,
        Date: DateTime(2025, 1, 10),
        workoutType: workoutType.TEMPO,
        workoutSport: workoutSport.SWIMMING,
        duration: 40,
        distance: 1000,
        day: "Lundi",
      ),
      WorkoutClass(
        id: 4,
        name: "EF vélo soir",
        done: false,
        Date: DateTime(2025, 1, 10),
        workoutType: workoutType.EF,
        workoutSport: workoutSport.CYCLING,
        duration: 110,
        distance: 50,
        day: "Vendredi",
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                const Text(
                  'Bonjour Alex',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Votre résumé de la semaine",
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    circularPogressBar(
                      totalDone: 2,
                      total: 4,
                      label: "Séances effectués",
                      toInt: true,
                    ),
                    const SizedBox(width: 24),
                    circularPogressBar(
                      totalDone: 7.3,
                      total: 25.6,
                      label: "Km parcourus",
                    ),
                  ],
                ),
                const SizedBox(height: 60),
                Text(
                  "Séances de la semaine",
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 25),
                for (WorkoutClass w in weeklyWokouts) ...[
                  if (!w.done) ...[
                    workoutCard(
                      title: "Test",
                      subtitle: "test subtitle",
                      workout: w,
                    ),
                    const SizedBox(height: 15),
                  ],
                ],

                for (WorkoutClass w in weeklyWokouts) ...[
                  if (w.done) ...[
                    workoutCard(
                      title: "Test",
                      subtitle: "test subtitle",
                      workout: w,
                    ),
                    const SizedBox(height: 15),
                  ],
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/*
Future<String> saveJsonToFile(List<Map<String, dynamic>> jsonData) async {
  final directory =
      await getTemporaryDirectory(); // ou getApplicationDocumentsDirectory()
  final filePath = '${directory.path}/health_data.json';
  final file = File(filePath);

  await file.writeAsString(jsonEncode(jsonData));
  print('✅ Fichier sauvegardé : $filePath');
  return filePath;
}

void shareHealthData(String filePath) {
  Share.shareXFiles([XFile(filePath)], text: 'Voici mes données Apple Santé');
}*/
