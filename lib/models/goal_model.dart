class GoalsList {
  final List<Goal> goals;

  GoalsList({
    required this.goals,
  });


  factory GoalsList.fromJson(List<dynamic> json){
    List<Goal> goals = json.map((i)=>Goal.fromJson(i)).toList();

    return GoalsList(
      goals: goals
    );
  }
}

class Goal {
  final String id;
  final String sport;
  final String name;
  final int nbOfWorkoutsPerWeek;
  final int nbOfWeek;
  final double targetDistance;
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

  factory Goal.fromJson(Map<String, dynamic> json){
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