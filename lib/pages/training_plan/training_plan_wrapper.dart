import 'package:ferum/models/training_plan_model.dart';
import 'package:ferum/pages/training_plan/intro_screen.dart';
import 'package:ferum/pages/training_plan/training_plan_screen.dart';
import 'package:ferum/services/training_plan_service.dart';

import 'package:flutter/material.dart';

/// Wrapper widget that decides whether to show:
/// - A loading indicator while fetching data
/// - The intro screen if no training plan exists
/// - Or the training plan screen if a plan is available.
class TrainingPlanWrapper extends StatefulWidget {
  const TrainingPlanWrapper({super.key});

  @override
  State<TrainingPlanWrapper> createState() => _TrainingPlanWrapperState();
}

class _TrainingPlanWrapperState extends State<TrainingPlanWrapper> {
  TrainingPlan? trainingPlan;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTrainingPlan();
  }


  /// Fetches the training plan from the backend using the TrainingPlanService.
  /// Displays a loading state while waiting and handles errors gracefully.
  Future<void> _loadTrainingPlan() async {
    // Set loading state to true before the request.
    setState(() {
      isLoading = true;
    });

    try{
      final plan = await TrainingPlanService().getTrainingPlan();
      setState(() {
        // If HTTP 200 → training plan returned, otherwise null.
        trainingPlan = plan;
        isLoading = false;
      });
    } catch (e) {  
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );    
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show loading indicator while fetching data.
    if (isLoading){
      return const Center(child: CircularProgressIndicator());
    }

    // If no training plan exists, show the intro wizard.
    if (trainingPlan == null){      
      return IntroScreen(
        // Once the plan is created, update state and show TrainingPlanScreen.
        onPlanCreated: (plan) {
          setState(() {
            trainingPlan = plan;
          });
        },
      );
    } 
    
    // If a training plan exists, display its screen.
    return TrainingPlanScreen(trainingPlan: trainingPlan!);
  }
}