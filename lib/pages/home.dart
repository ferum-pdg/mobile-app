import 'package:ferum/pigeons/healthkit_workout.g.dart';
import 'package:ferum/widgets/workoutCard.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../pigeons/healthkit_authorization.g.dart';

import '../widgets/circularProgressBar.dart';

import '../models/workout.dart';
import '../models/enum.dart';
import '../models/sharedPreferences.dart';
import '../services/HKWorkouts_service.dart';
import '../utils/HKWorkouts_to_json.dart';
import 'workoutDetailPage.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final List<WorkoutClass> weeklyWokouts;
  late final List<HKWorkoutData?> HKWorkouts;
  SharedPreferences? prefs;
  String? username;
  @override
  void initState() {
    super.initState();
    initWeeklyWorkouts();
    initPrefs();

    // Demande authorisation
    authHealthKit
        .requestAuthorization()
        .then((isAuthorized) {
          if (isAuthorized == true) {
            loadWorkouts().then((_) async {
              // Délègue l'envoi au service dédié
              final svc = HKWorkoutService();
              for (HKWorkoutData? w in HKWorkouts) {
                if (w?.sport == "running" ||
                    w?.sport == "cycling" ||
                    w?.sport == "swimming") {
                  final HKWorkoutJson = hkWorkoutToJson(w!);
                  await svc.sendWorkout(HKWorkoutJson);
                }
              }
            });
          } else {
            print("⚠️ Accès Apple Health refusé par l'utilisateur");
          }
        })
        .catchError((e) {
          print("❌ Erreur lors de la demande d'autorisation: $e");
        });
  }

  final authHealthKit = HealthKitAuthorization(); //  classe générée Pigeon

  Future<void> initPrefs() async {
    SharedPreferences p = await SharedPreferences.getInstance();

    // Only set default values on first launch
    bool isFirstLaunch = p.getBool('isFirstLaunch') ?? true;
    if (isFirstLaunch) {
      defaultSharedPreferences(p);
      await p.setBool('isFirstLaunch', false);
    }

    setState(() {
      prefs = p;
      username = p.getString('username');
    });
  }

  late final HKWorkoutAPI = HealthKitWorkoutApi();

  Future<void> loadWorkouts() async {
    HKWorkouts = await HKWorkoutAPI.getWorkouts();
  }

  Future<void> initWeeklyWorkouts() async {
    weeklyWokouts = [
      WorkoutClass(
        id: 1,
        name: "EF matin",
        done: false,
        Date: DateTime(2025, 1, 12),
        workoutType: WorkoutType.EF,
        workoutSport: WorkoutSport.RUNNING,
        durationSec: 30,
        distanceMeters: 5.3,
        day: "Mercredi",
      ),
      WorkoutClass(
        id: 2,
        name: "Fractionné running matin",
        done: true,
        Date: DateTime(2025, 1, 10),
        workoutType: WorkoutType.FRACTIONNE,
        workoutSport: WorkoutSport.RUNNING,
        durationSec: 45,
        distanceMeters: 15.5,
        day: "Mardi",
        kcal: 1500,
        avgBPM: 156,
      ),
      WorkoutClass(
        id: 3,
        name: "Tempo natation soir",
        done: true,
        Date: DateTime(2025, 1, 10),
        workoutType: WorkoutType.TEMPO,
        workoutSport: WorkoutSport.SWIMMING,
        durationSec: 40,
        distanceMeters: 1000,
        day: "Lundi",
      ),
      WorkoutClass(
        id: 4,
        name: "EF vélo soir",
        done: false,
        Date: DateTime(2025, 1, 10),
        workoutType: WorkoutType.EF,
        workoutSport: WorkoutSport.CYCLING,
        durationSec: 110,
        distanceMeters: 50,
        day: "Vendredi",
      ),
    ];
  }

  void _openWorkoutDetail(WorkoutClass w) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => WorkoutDetailPage(workout: w)));
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
                username == null
                    ? const SizedBox(
                        height: 38,
                      ) // reserve space to avoid layout shift
                    : Text(
                        "Bonjour $username",
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
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
                    InkWell(
                      onTap: () => _openWorkoutDetail(w),
                      child: workoutCard(
                        title: "Test",
                        subtitle: "test subtitle",
                        workout: w,
                      ),
                    ),
                    const SizedBox(height: 15),
                  ],
                ],

                for (WorkoutClass w in weeklyWokouts) ...[
                  if (w.done) ...[
                    InkWell(
                      onTap: () => _openWorkoutDetail(w),
                      child: workoutCard(
                        title: "Test",
                        subtitle: "test subtitle",
                        workout: w,
                      ),
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
