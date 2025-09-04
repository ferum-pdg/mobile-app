// High-level training plan summary: current progress and the active weekly plan
class TrainingPlan {
  final String id;
  // 1-based index of the current week within the plan
  final int currentWeekNb;
  // Total number of weeks in the plan
  final int totalNbOfWeeks;
  // Workouts completed so far (across the whole plan)
  final int currentNbOfWorkouts;
  // Total workouts in the full plan
  final int totalNbOfWorkouts;
  final CurrentWeeklyPlan currentWeeklyPlan;

  TrainingPlan({
    required this.id,
    required this.currentWeekNb,
    required this.totalNbOfWeeks,
    required this.currentNbOfWorkouts,
    required this.totalNbOfWorkouts,
    required this.currentWeeklyPlan,
  });

  factory TrainingPlan.fromJson(Map<String, dynamic> json) {
    return TrainingPlan(
      id: json['id'],
      currentWeekNb: json['currentWeekNb'],
      totalNbOfWeeks: json['totalNbOfWeeks'],
      currentNbOfWorkouts: json['currentNbOfWorkouts'],
      totalNbOfWorkouts: json['totalNbOfWorkouts'],
      // Nested object: the plan for the current week
      currentWeeklyPlan: CurrentWeeklyPlan.fromJson(json['currentWeeklyPlan']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'currentWeekNb': currentWeekNb,
    'totalNbOfWeeks': totalNbOfWeeks,
    'currentNbOfWorkouts': currentNbOfWorkouts,
    'totalNbOfWorkouts': totalNbOfWorkouts,
    'currentWeeklyPlan': currentWeeklyPlan.toJson(),
  };
}

// The currently active week: list of daily plans and the week number
class CurrentWeeklyPlan {
  final String id;
  final List<DailyPlan> dailyPlans;
  final int weekNumber;

  CurrentWeeklyPlan({
    required this.id,
    required this.dailyPlans,
    required this.weekNumber,
  });

  factory CurrentWeeklyPlan.fromJson(Map<String, dynamic> json) {
    // Decode the array of daily plans
    var list = json['dailyPlans'] as List;
    // Map each JSON item to a DailyPlan model
    List<DailyPlan> dailyPlans = list
        .map((i) => DailyPlan.fromJson(i))
        .toList();

    return CurrentWeeklyPlan(
      id: json['id'],
      dailyPlans: dailyPlans,
      weekNumber: json['weekNumber'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'dailyPlans': dailyPlans.map((i) => i.toJson()).toList(),
    'weekNumber': weekNumber,
  };
}

// Minimal description of a day in the week: weekday label + sport
class DailyPlan {
  final String id;
  // Weekday name (e.g., MONDAY); used for localization in the UI
  final String dayOfWeek;
  // Sport as a string; later mapped to enum/icons in the UI
  final String sport;

  DailyPlan({required this.id, required this.dayOfWeek, required this.sport});

  factory DailyPlan.fromJson(Map<String, dynamic> json) {
    return DailyPlan(
      id: json['id'],
      dayOfWeek: json['dayOfWeek'],
      sport: json['sport'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'dayOfWeek': dayOfWeek,
    'sport': sport,
  };
}
