// Wrapper for a list of goals, useful for decoding arrays from backend
class GoalsList {
  final List<Goal> goals;

  GoalsList({required this.goals});

  factory GoalsList.fromJson(List<dynamic> json) {
    // Map each JSON object in the list to a Goal model
    List<Goal> goals = json.map((i) => Goal.fromJson(i)).toList();

    return GoalsList(goals: goals);
  }
}

// Single training goal with weekly frequency, duration, and distance/elevation targets
class Goal {
  final String id;
  final String sport;
  final String name;
  // Planned number of workouts per week
  final int nbOfWorkoutsPerWeek;
  // Total number of weeks the goal should last
  final int nbOfWeek;
  // Target distance (kilometers)
  final double targetDistance;
  // Target elevation gain (meters)
  final double elevationGain;

  Goal({
    required this.id,
    required this.sport,
    required this.name,
    required this.nbOfWorkoutsPerWeek,
    required this.nbOfWeek,
    required this.targetDistance,
    required this.elevationGain,
  });

  // Decode a Goal object from a JSON map
  factory Goal.fromJson(Map<String, dynamic> json) {
    return Goal(
      id: json['id'],
      sport: json['sport'],
      name: json['name'],
      nbOfWorkoutsPerWeek: json['nbOfWorkoutsPerWeek'],
      nbOfWeek: json['nbOfWeek'],
      targetDistance: json['targetDistance'],
      elevationGain: json['elevationGain'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'sport': sport,
    'name': name,
    'nbOfWorkoutsPerWeek': nbOfWorkoutsPerWeek,
    'nbOfWeek': nbOfWeek,
    'targetDistance': targetDistance,
    'elevationGain': elevationGain,
  };
}
