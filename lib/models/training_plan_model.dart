class TrainingPlan {
  final String id;
  final int currentWeekNb;
  final int totalNbOfWeeks;
  final int currentNbOfWorkouts;
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

  factory TrainingPlan.fromJson(Map<String, dynamic> json){
    return TrainingPlan(
      id: json['id'], 
      currentWeekNb: json['currentWeekNb'],
      totalNbOfWeeks: json['totalNbOfWeeks'],
      currentNbOfWorkouts: json['currentNbOfWorkouts'],
      totalNbOfWorkouts: json['totalNbOfWorkouts'],
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

class CurrentWeeklyPlan {
  final String id;
  final List<DailyPlan> dailyPlans;
  final int weekNumber;

  CurrentWeeklyPlan({
    required this.id,
    required this.dailyPlans,
    required this.weekNumber,
  });

  factory CurrentWeeklyPlan.fromJson(Map<String, dynamic> json){
    var list = json['dailyPlans'] as List;
    List<DailyPlan> dailyPlans = list.map((i) => DailyPlan.fromJson(i)).toList();

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

class DailyPlan {
  final String id;
  final String dayOfWeek;
  final String sport;

  DailyPlan({
    required this.id,
    required this.dayOfWeek,
    required this.sport,
  });

  factory DailyPlan.fromJson(Map<String, dynamic> json){
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