import 'package:ferum/models/training_plan_model.dart';
import 'package:ferum/pages/training_plan/intro_screen.dart';
import 'package:ferum/pages/training_plan/training_plan_screen.dart';
import 'package:ferum/services/training_plan_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TrainingPlanWrapper extends StatefulWidget {
  const TrainingPlanWrapper({super.key});

  @override
  State<TrainingPlanWrapper> createState() => _TrainingPlanWrapperState();
}

class _TrainingPlanWrapperState extends State<TrainingPlanWrapper> {
  SharedPreferences? prefs;
  bool? hasTrainingPlan;
  TrainingPlan? trainingPlan;

  @override
  void initState() {
    super.initState();
    initPrefs();
  }

  Future<void> initPrefs() async {
    SharedPreferences p = await SharedPreferences.getInstance();

    bool? plan = p.getBool('hasTrainingPlan');
    setState(() {
      prefs = p;
      hasTrainingPlan = true ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (hasTrainingPlan == true || trainingPlan != null){
      return TrainingPlanScreen(trainingPlan: trainingPlan);
    } else {
      return IntroScreen(
        onPlanCreated: () async {
          trainingPlan = await TrainingPlanService().createTrainingPlan();
          prefs?.setBool('hasTrainingPlan', true);
          setState(() {
            hasTrainingPlan = true;
          });
        },
      );
    }
  }
}