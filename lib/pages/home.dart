import 'package:ferum/pigeons/healthkit_workout.g.dart';
import 'package:ferum/services/sync_service.dart';
import 'package:ferum/services/user_service.dart';
import 'package:ferum/widgets/workoutLightCard.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../pigeons/healthkit_authorization.g.dart';

import '../widgets/circularProgressBar.dart';

import '../models/enum.dart';

import '../services/HKWorkouts_service.dart';
import '../utils/HKWorkouts_to_json.dart';
import 'workoutDetailPage.dart';
import '../models/workoutLight_model.dart';
import '../services/WorkoutsLight_service.dart';

// Home screen: weekly summary, HealthKit sync, and lists of current/next week workouts
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<WorkoutLightClass>? weeklyWokouts;
  // Last fetched HealthKit workouts (via Pigeon API)
  List<HKWorkoutData?> hkWorkouts = [];
  // Cached SharedPreferences instance for lightweight flags
  SharedPreferences? prefs;
  // Display name fetched from backend
  String? username;
  // Aggregates used for the two circular progress bars
  double hoursDoneThisWeek = 0.0;
  double hoursPlannedThisWeek = 0.0;
  int doneSecondsThisWeek = 0;
  int plannedSecondsThisWeek = 0;
  bool _isLoadingWeekly = true;
  @override
  void initState() {
    super.initState();
    // Load "light" workouts and compute weekly aggregates
    initWeeklyWorkouts();
    // Prepare SharedPreferences for later use
    initPrefs();
    // Fetch the logged-in user's first name for greeting
    getUsername();

    // Optional backend sync (note: at init, weeklyWokouts is usually null/empty)
    if (weeklyWokouts != null && weeklyWokouts!.isNotEmpty) {
      final syncService = SyncService();
      syncService.sync();
    }

    // Ask HealthKit permission, then fetch workouts and forward eligible ones to backend
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

  // Pigeon-generated bridge to iOS HealthKit authorization
  final authHealthKit = HealthKitAuthorization(); //  classe générée Pigeon
  // Pigeon-generated API used to read workouts from HealthKit
  late final HKWorkoutAPI = HealthKitWorkoutApi();
  final workoutLightService = WorkoutLightService();

  Future<void> initPrefs() async {
    // Obtain a single SharedPreferences instance (async)
    SharedPreferences p = await SharedPreferences.getInstance();
    setState(() {
      prefs = p;
    });
  }

  Future<void> getUsername() async {
    // Retrieve user profile from backend to display greeting
    final loggedInUser = await UserService().getUser();
    setState(() {
      username = loggedInUser?.firstName;
    });
  }

  Future<void> loadWorkouts() async {
    // Pull raw workouts from HealthKit via Pigeon
    hkWorkouts = await HKWorkoutAPI.getWorkouts();
  }

  Future<void> initWeeklyWorkouts() async {
    // Set loading flag (guarded by `mounted` to avoid setState on disposed widget)
    if (mounted) {
      setState(() {
        _isLoadingWeekly = true;
      });
    } else {
      _isLoadingWeekly = true;
    }
    try {
      // Fetch condensed workouts for the dashboard (faster than full details)
      final fetched = await workoutLightService.fetchWorkoutsLight();

      // Calcule les heures planifiées et effectuées pour la semaine courante (à partir des workouts light)
      int plannedSeconds = 0;
      int doneSeconds = 0;
      // Determine the current week from available data (lowest week index)
      int? currentWeek;
      if (fetched.isNotEmpty) {
        final weeks = fetched.map((w) => w.week).toSet().toList()..sort();
        currentWeek = weeks.first;
      }
      if (currentWeek != null) {
        for (final w in fetched) {
          if (w.week == currentWeek) {
            // Duration can be int/double/string depending on source; normalize to seconds
            final int durSec = (w.duration is int)
                ? (w.duration as int)
                : (w.duration is double)
                ? (w.duration as double).round()
                : (w.duration is String)
                ? (int.tryParse(w.duration as String) ?? 0)
                : 0;
            plannedSeconds += durSec;
            if (w.status == WorkoutStatut.COMPLETED) {
              doneSeconds += durSec;
            }
          }
        }
      }

      // Convert to hours and round to one decimal for display
      final plannedHours = plannedSeconds / 3600.0;
      final doneHours = doneSeconds / 3600.0;

      if (!mounted) return;
      setState(() {
        weeklyWokouts = fetched;
        plannedSecondsThisWeek = plannedSeconds;
        doneSecondsThisWeek = doneSeconds;
        hoursPlannedThisWeek = double.parse(plannedHours.toStringAsFixed(1));
        hoursDoneThisWeek = double.parse(doneHours.toStringAsFixed(1));
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          weeklyWokouts = [];
        });
        // Surface a non-blocking error to the user if fetching failed
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors du chargement des séances : $e')),
        );
      } else {
        weeklyWokouts = [];
      }
    } finally {
      // Clear loading flag (guarded by `mounted`)
      if (mounted) {
        setState(() {
          _isLoadingWeekly = false;
        });
      } else {
        _isLoadingWeekly = false;
      }
    }
  }

  Future<void> _refreshAll() async {
    try {
      // 1) Refresh HealthKit data
      await loadWorkouts();

      // 2) Forward eligible workouts (running/cycling/swimming) to backend
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

      // 3) Recompute weekly aggregates and refresh UI
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

  // Navigate to the full workout detail page
  void _openWorkoutDetail(WorkoutLightClass w) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => WorkoutDetailPage(id: w.id)));
  }

  // Format seconds as `HhMM` or `MMmin` (e.g., 5400 -> 1h30)
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
    // Skeleton state while weekly data is loading; still supports pull-to-refresh
    if (_isLoadingWeekly) {
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
                        ? const SizedBox(height: 38)
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
                    // Intentionally render nothing else while loading to avoid flicker
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }
    // Identify current vs next week from the fetched dataset
    int? currentWeek;
    int? nextWeek;
    if (weeklyWokouts != null && weeklyWokouts!.isNotEmpty) {
      final weeks = weeklyWokouts!.map((w) => w.week).toSet().toList()..sort();
      currentWeek = weeks.first;
      if (weeks.length > 1) {
        nextWeek = weeks.last;
      }
    }
    // Count planned and completed sessions for the current week
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
                          // Avoid divide-by-zero: fall back to `done` when `planned` is 0
                          total: (sessionsPlanned > 0
                              ? sessionsPlanned.toDouble()
                              : (sessionsCompleted > 0
                                    ? sessionsCompleted.toDouble()
                                    : 0.0)),
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
                          // Same protection for hours progress
                          total: (hoursPlanned > 0
                              ? hoursPlanned
                              : (hoursDone > 0 ? hoursDone : 0.0)),
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
                    // Current week — first show incomplete sessions
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

                    // Then show completed sessions
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
                  ] else if (!_isLoadingWeekly) ...[
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
                  ] else ...[
                    SizedBox.shrink(),
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

                    // Next week — incomplete sessions
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

                    // Next week — completed sessions
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
