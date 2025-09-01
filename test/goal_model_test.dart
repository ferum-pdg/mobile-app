import 'package:flutter_test/flutter_test.dart';
import 'package:ferum/models/goal_model.dart';

void main() {
  group("Goal Model", () {
    final goalJson = {
      "id": "850e8400-e29b-41d4-a716-44665544000c",
      "sport": "SWIMMING",
      "name": "Swimming 3900m",
      "nbOfWorkoutsPerWeek": 3,
      "nbOfWeek": 10,
      "targetDistance": 3.9,
      "elevationGain": 0.0,
    };
    test("Conversion Json -> objet Goal", () {
      final goal = Goal.fromJson(goalJson);

      expect(goal.id, "850e8400-e29b-41d4-a716-44665544000c");
      expect(goal.sport, "SWIMMING");
      expect(goal.name, "Swimming 3900m");
      expect(goal.nbOfWorkoutsPerWeek, 3);
      expect(goal.nbOfWeek, 10);
      expect(goal.targetDistance, 3.9);
      expect(goal.elevationGain, 0.0);
    });

    test("Conversion objet Goal -> Json", () {
      final goal = Goal.fromJson(goalJson);
      final json = goal.toJson();

      expect(json, equals(goalJson));
    });
  });

  group("GoalsList Model", () {
    final goalsListJson = [
      {
        "id":"850e8400-e29b-41d4-a716-44665544000b",
        "sport":"SWIMMING",
        "name":"Swimming 1800m",
        "nbOfWorkoutsPerWeek":3,
        "nbOfWeek":10,
        "targetDistance":1.8,
        "elevationGain":0.0,
      },
      {
        "id":"850e8400-e29b-41d4-a716-44665544000c",
        "sport":"SWIMMING",
        "name":"Swimming 3900m",
        "nbOfWorkoutsPerWeek":3,
        "nbOfWeek":10,
        "targetDistance":3.9,
        "elevationGain":0.0,
      }
    ];
  
    test("fromJson crée une liste de Goal valide", () {
      final goalsList = GoalsList.fromJson(goalsListJson);

      expect(goalsList.goals.length, 2);
      expect(goalsList.goals.first.name, "Swimming 1800m");
      expect(goalsList.goals.last.sport, "SWIMMING");
    });
  });
}