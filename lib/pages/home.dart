import 'package:ferum/pigeons/healthkit_workout.g.dart';
import 'package:ferum/widgets/workoutCard.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../pigeons/healthkit_authorization.g.dart';

import '../widgets/circularProgressBar.dart';

import '../models/workout_model.dart';
import '../models/enum.dart';

import '../utils/sharedPreferences.dart';
import '../services/HKWorkouts_service.dart';
import '../utils/HKWorkouts_to_json.dart';
import 'workoutDetailPage.dart';
import '../models/workoutLight_model.dart';
import '../services/WorkoutsLight_service.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<WorkoutLightClass>? weeklyWokouts;
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
  late final HKWorkoutAPI = HealthKitWorkoutApi();
  final workoutLightService = WorkoutLightService();

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

  Future<void> loadWorkouts() async {
    HKWorkouts = await HKWorkoutAPI.getWorkouts();
  }

  Future<void> initWeeklyWorkouts() async {
    final fetched = await workoutLightService.fetchWorkoutsLight();
    setState(() {
      weeklyWokouts = fetched;
    });
  }

  void _openWorkoutDetail(WorkoutLightClass w) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => WorkoutDetailPage(id: w.id)));
  }

  @override
  Widget build(BuildContext context) {
    int? currentWeek;
    int? nextWeek;
    if (weeklyWokouts != null && weeklyWokouts!.isNotEmpty) {
      final weeks = weeklyWokouts!.map((w) => w.week).toSet().toList()..sort();
      currentWeek = weeks.first;
      if (weeks.length > 1) {
        nextWeek = weeks.last;
      }
    }
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
                // Section: Semaine actuelle
                Text(
                  "Séances de la semaine",
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 25),
                if (weeklyWokouts != null && weeklyWokouts!.isNotEmpty) ...[
                  // Liste des séances NON terminées de la semaine actuelle
                  for (WorkoutLightClass w in weeklyWokouts!) ...[
                    if ((currentWeek != null && w.week == currentWeek) &&
                        (w.status != WorkoutStatut.COMPLETED)) ...[
                      InkWell(
                        onTap: () => _openWorkoutDetail(w),
                        child: workoutLightCard(
                          title: "Test",
                          subtitle: "test subtitle",
                          workout: w,
                        ),
                      ),
                      const SizedBox(height: 15),
                    ],
                  ],

                  // Liste des séances terminées de la semaine actuelle
                  for (WorkoutLightClass w in weeklyWokouts!) ...[
                    if ((currentWeek != null && w.week == currentWeek) &&
                        (w.status == WorkoutStatut.COMPLETED)) ...[
                      InkWell(
                        onTap: () => _openWorkoutDetail(w),
                        child: workoutLightCard(
                          title: "Test",
                          subtitle: "test subtitle",
                          workout: w,
                        ),
                      ),
                      const SizedBox(height: 15),
                    ],
                  ],
                ] else ...[
                  Text.rich(
                    TextSpan(
                      text:
                          "Vous n'avez pas encore de séance planifiée.\nCréez un plan d'entraînement depuis la page ",
                      style: TextStyle(fontSize: 18, color: Colors.black),
                      children: [
                        TextSpan(
                          text: "Entraînement",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.purple,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(text: " pour commencer."),
                      ],
                    ),
                  ),
                ],

                // Section: Semaine prochaine (si présente)
                if (nextWeek != null) ...[
                  const SizedBox(height: 32),
                  Text(
                    "Semaine prochaine",
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 25),

                  // Liste des séances NON terminées de la semaine prochaine
                  for (WorkoutLightClass w in weeklyWokouts!) ...[
                    if (w.week == nextWeek &&
                        (w.status != WorkoutStatut.COMPLETED)) ...[
                      InkWell(
                        onTap: () => _openWorkoutDetail(w),
                        child: workoutLightCard(
                          title: "Test",
                          subtitle: "test subtitle",
                          workout: w,
                        ),
                      ),
                      const SizedBox(height: 15),
                    ],
                  ],

                  // Liste des séances terminées de la semaine prochaine
                  for (WorkoutLightClass w in weeklyWokouts!) ...[
                    if (w.week == nextWeek &&
                        (w.status == WorkoutStatut.COMPLETED)) ...[
                      InkWell(
                        onTap: () => _openWorkoutDetail(w),
                        child: workoutLightCard(
                          title: "Test",
                          subtitle: "test subtitle",
                          workout: w,
                        ),
                      ),
                      const SizedBox(height: 15),
                    ],
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
