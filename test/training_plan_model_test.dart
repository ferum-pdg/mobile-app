import 'package:flutter_test/flutter_test.dart';
import 'package:ferum/models/training_plan_model.dart';

void main() {
  group("DailyPlan Model", () {
    final dailyPlanJson = {
      "id":"4472315b-05f7-449a-a8fb-a57263c2ddb6",
      "dayOfWeek":"MONDAY",
      "sport":"SWIMMING",
    };

    test("Conversion Json -> objet DailyPlan", () {
      final dailyPlan = DailyPlan.fromJson(dailyPlanJson);

      expect(dailyPlan.id, "4472315b-05f7-449a-a8fb-a57263c2ddb6");
      expect(dailyPlan.dayOfWeek, "MONDAY");
      expect(dailyPlan.sport, "SWIMMING");
    });

    test("Conversion objet DailyPlan -> Json", () {
      final dailyPlan = DailyPlan.fromJson(dailyPlanJson);
      expect(dailyPlan.toJson(), equals(dailyPlanJson));
    });
  });

  group("CurrentWeeklyPlan Model", () {
    final currentWeeklyPlanJson = {
      "id": "b967734c-910b-4963-8694-94b22ce10e8d",
      "weekNumber": 1,
      "dailyPlans": [
        {
          "id":"4472315b-05f7-449a-a8fb-a57263c2ddb6",
          "dayOfWeek":"MONDAY",
          "sport":"SWIMMING",
        },
        {
          "id":"5b7c1b52-0122-4bd0-831b-a9381381664e",
          "dayOfWeek":"MONDAY",
          "sport":"RUNNING",
        }
      ]
    };

    test("Conversion Json -> objet CurrentWeeklyPlan", () {
      final cwp = CurrentWeeklyPlan.fromJson(currentWeeklyPlanJson);

      expect(cwp.id, "b967734c-910b-4963-8694-94b22ce10e8d");
      expect(cwp.weekNumber, 1);
      expect(cwp.dailyPlans.length, 2);
      expect(cwp.dailyPlans.first.sport, "SWIMMING");
    });

    test("Conversion objet CurrentWeeklyPlan -> Json", () {
      final cwp = CurrentWeeklyPlan.fromJson(currentWeeklyPlanJson);
      expect(cwp.toJson(), equals(currentWeeklyPlanJson));
    });
  });

  group("TrainingPlan Model", () {
    final trainingPlanJson = {
      "id": "8841dec0-49c4-4cfb-8841-958e9c14c8d8",
      "currentWeekNb": 1,
      "totalNbOfWeeks": 12,
      "currentNbOfWorkouts": 0,
      "totalNbOfWorkouts": 60,
      "currentWeeklyPlan": {
        "id": "b967734c-910b-4963-8694-94b22ce10e8d",
        "weekNumber": 1,
        "dailyPlans": [
          {
            "id":"4472315b-05f7-449a-a8fb-a57263c2ddb6",
            "dayOfWeek":"MONDAY",
            "sport":"SWIMMING",
          },
          {
            "id":"5b7c1b52-0122-4bd0-831b-a9381381664e",
            "dayOfWeek":"MONDAY",
            "sport":"RUNNING",
          }
        ]
      }
    };

    test("Conversion Json -> objet TrainingPlan", () {
      final plan = TrainingPlan.fromJson(trainingPlanJson);

      expect(plan.id, "8841dec0-49c4-4cfb-8841-958e9c14c8d8");
      expect(plan.currentWeekNb, 1);
      expect(plan.totalNbOfWeeks, 12);
      expect(plan.currentNbOfWorkouts, 0);
      expect(plan.totalNbOfWorkouts, 60);
      expect(plan.currentWeeklyPlan.dailyPlans.length, 2);
    });

    test("Conversion objet TrainingPlan -> Json", () {
      final plan = TrainingPlan.fromJson(trainingPlanJson);
      expect(plan.toJson(), equals(trainingPlanJson));
    });
  });
}