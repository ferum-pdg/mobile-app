import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../pigeons/workout.g.dart';
import '../pigeons/healthkit_authorization.g.dart';

import '../widgets/infoCard.dart';
import '../widgets/circularProgressBar.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int? steps = 0;
  double active_energy_burned = 0;
  double distance_walking_running = 0;
  int heart_rate_resting = 0;

  @override
  void initState() {
    super.initState();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
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
                    totalDone: 3,
                    total: 3,
                    label: "Séances effectués",
                  ),
                  const SizedBox(width: 24),
                  circularPogressBar(
                    totalDone: 7,
                    total: 25,
                    label: "Km parcourus",
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
