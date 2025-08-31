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
    // Sets that the training plan is in loading process.
    setState(() {
      isLoading = true;
    });

    try{
      final plan = await TrainingPlanService().getTrainingPlan();
      setState(() {
        // HTTP Code 200 = trainingPlan, sinon null.
        trainingPlan = plan;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading){
      return const Center(child: CircularProgressIndicator());
    }

    if (trainingPlan == null){      
      return IntroScreen(
        onPlanCreated: (plan) {
          setState(() {
            trainingPlan = plan;
          });
        },
      );
    } 

    return TrainingPlanScreen(trainingPlan: trainingPlan!);
  }
}