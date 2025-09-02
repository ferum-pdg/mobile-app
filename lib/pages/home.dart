import 'package:ferum/pigeons/healthkit_workout.g.dart';
import 'package:ferum/services/sync_service.dart';
import 'package:ferum/services/user_service.dart';
import 'package:ferum/widgets/workoutLightCard.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../pigeons/healthkit_authorization.g.dart';

import '../widgets/circularProgressBar.dart';

import '../models/enum.dart';

import '../utils/sharedPreferences.dart';
import '../services/HKWorkouts_service.dart';
import '../utils/HKWorkouts_to_json.dart';
import 'workoutDetailPage.dart';
import '../models/workoutLight_model.dart';
import '../models/user_model.dart';
import '../services/WorkoutsLight_service.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<WorkoutLightClass>? weeklyWokouts;
  List<HKWorkoutData?> hkWorkouts = [];
  SharedPreferences? prefs;
  String? username;
  double hoursDoneThisWeek = 0.0;
  double hoursPlannedThisWeek = 0.0;
  int doneSecondsThisWeek = 0;
  int plannedSecondsThisWeek = 0;
  @override
  void initState() {
    super.initState();
    initWeeklyWorkouts();
    initPrefs();
    getUsername();

    //Sync with backend
    final syncService = SyncService();
    syncService.sync();

    // Demande authorisation
    authHealthKit
        .requestAuthorization()
        .then((isAuthorized) {
          if (isAuthorized == true) {
            loadWorkouts().then((_) async {
              // Délègue l'envoi au service dédié
              final svc = HKWorkoutService();
              for (HKWorkoutData? w in hkWorkouts) {
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
    });
  }

  Future<void> getUsername() async {
    final loggedInUser = await UserService().getUser();
    setState(() {
      username = loggedInUser?.firstName;
    });
  }

  Future<void> loadWorkouts() async {
    hkWorkouts = await HKWorkoutAPI.getWorkouts();
  }

  Future<void> initWeeklyWorkouts() async {
    final fetched = await workoutLightService.fetchWorkoutsLight();

    // Calcule les heures planifiées et effectuées pour la semaine courante (à partir des workouts light)
    int plannedSeconds = 0;
    int doneSeconds = 0;
    int? currentWeek;
    if (fetched.isNotEmpty) {
      final weeks = fetched.map((w) => w.week).toSet().toList()..sort();
      currentWeek = weeks.first;
    }
    if (currentWeek != null) {
      for (final w in fetched) {
        if (w.week == currentWeek) {
          final int durSec = (w.duration as int? ?? 0);
          plannedSeconds += durSec;
          if (w.status == WorkoutStatut.COMPLETED) {
            doneSeconds += durSec;
          }
        }
      }
    }

    final plannedHours = plannedSeconds / 3600.0;
    final doneHours = doneSeconds / 3600.0;

    setState(() {
      weeklyWokouts = fetched;
      plannedSecondsThisWeek = plannedSeconds;
      doneSecondsThisWeek = doneSeconds;
      hoursPlannedThisWeek = double.parse(plannedHours.toStringAsFixed(1));
      hoursDoneThisWeek = double.parse(doneHours.toStringAsFixed(1));
    });
  }

  Future<void> _refreshAll() async {
    try {
      // Recharge les workouts Apple Health
      await loadWorkouts();

      // Renvoie les workouts éligibles au backend
      final svc = HKWorkoutService();
      for (final w in hkWorkouts) {
        if (w != null &&
            (w.sport == "running" ||
                w.sport == "cycling" ||
                w.sport == "swimming")) {
          final hkWorkoutJson = hkWorkoutToJson(w);
          await svc.sendWorkout(hkWorkoutJson);
        }
      }

      // Recharge les workouts "light" depuis l'API et met à jour l'affichage
      await initWeeklyWorkouts();

      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Données synchronisées')));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la synchronisation : $e')),
      );
    }
  }

  void _openWorkoutDetail(WorkoutLightClass w) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => WorkoutDetailPage(id: w.id)));
  }

  String _formatHHMM(int totalSeconds) {
    final totalMinutes = (totalSeconds / 60).round();
    final hours = totalMinutes ~/ 60;
    final minutes = totalMinutes % 60;
    if (hours > 0) {
      return '${hours}h${minutes.toString().padLeft(2, '0')}';
    } else {
      return '${minutes}min';
    }
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
    int sessionsPlanned = 0;
    int sessionsCompleted = 0;
    if (weeklyWokouts != null) {
      for (final w in weeklyWokouts!) {
        if (currentWeek != null && w.week == currentWeek) {
          sessionsPlanned++;
          if (w.status == WorkoutStatut.COMPLETED) {
            sessionsCompleted++;
          }
        }
      }
    }
    final hoursDone = hoursDoneThisWeek;
    final hoursPlanned = hoursPlannedThisWeek;
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refreshAll,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
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
                          "Bonjour ${username}",
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
                      SizedBox(
                        width: 160,
                        height: 160,
                        child: circularPogressBar(
                          totalDone: sessionsCompleted.toDouble(),
                          total: (sessionsPlanned > 0
                              ? sessionsPlanned.toDouble()
                              : (sessionsCompleted > 0
                                    ? sessionsCompleted.toDouble()
                                    : 1.0)),
                          label: "Séances effectuées",
                          toInt: true,
                        ),
                      ),
                      const SizedBox(width: 24),
                      SizedBox(
                        width: 160,
                        height: 160,
                        child: circularPogressBar(
                          totalDone: hoursDone,
                          total: (hoursPlanned > 0
                              ? hoursPlanned
                              : (hoursDone > 0 ? hoursDone : 1.0)),
                          label: "Durée d'entraînement",
                          isHours: true,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
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
                          child: workoutLightCard(workout: w),
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
                          child: workoutLightCard(workout: w),
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
                          child: workoutLightCard(workout: w),
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
                          child: workoutLightCard(workout: w),
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
      ),
    );
  }
}
