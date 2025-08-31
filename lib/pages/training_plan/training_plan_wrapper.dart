import 'dart:convert';

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
  bool hasTrainingPlan = false;
  TrainingPlan? trainingPlan;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTrainingPlan();
  }


  Future<void> _loadTrainingPlan() async {
  prefs = await SharedPreferences.getInstance();
  final hasPlan = prefs!.getBool('hasTrainingPlan') ?? false;

  TrainingPlan? plan;
  if (hasPlan) {
    final trainingPlanString = prefs!.getString('trainingPlan');
    if (trainingPlanString != null) {
      plan = TrainingPlan.fromJson(jsonDecode(trainingPlanString));
    }
  }

  setState(() {
    hasTrainingPlan = hasPlan;
    trainingPlan = plan;
    isLoading = false;
  });
}

  @override
  Widget build(BuildContext context) {
    if (isLoading){
      return const Center(child: CircularProgressIndicator());
    }

    if (hasTrainingPlan){
      return TrainingPlanScreen(trainingPlan: trainingPlan);
    } else {
      return IntroScreen(
        onPlanCreated: () async {
          trainingPlan = await TrainingPlanService().createTrainingPlan();
          prefs!.setBool('hasTrainingPlan', true);
          setState(() {
            hasTrainingPlan = true;
          });
        },
      );
    }
  }
}