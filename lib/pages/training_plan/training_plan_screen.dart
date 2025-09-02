import 'package:ferum/models/training_plan_model.dart';
import 'package:ferum/widgets/circularProgressBar.dart';
import 'package:ferum/widgets/daily_plan_card.dart';

import 'package:ferum/widgets/progress_pie_chart.dart';
import 'package:flutter/material.dart';

/// Screen that displays the details of a TrainingPlan,
/// including progress charts and the weekly workout schedule.
class TrainingPlanScreen extends StatefulWidget {
  final TrainingPlan? trainingPlan;

  const TrainingPlanScreen({
    super.key,
    required this.trainingPlan,
  });

  @override
  State<TrainingPlanScreen> createState() => _TrainingPlanScreenState();
}

class _TrainingPlanScreenState extends State<TrainingPlanScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                Text(
                  "État programme",
                  style: TextStyle(
                    fontSize: 32,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                /// Section: Progress indicators (weeks and workouts).                      
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: circularPogressBar(
                        totalDone: widget.trainingPlan!.currentWeekNb.toDouble(), 
                        total: widget.trainingPlan!.totalNbOfWeeks.toDouble(), 
                        label: "Semaines",
                        toInt: true,
                      )
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: circularPogressBar(
                        totalDone: widget.trainingPlan!.currentNbOfWorkouts.toDouble(), 
                        total: widget.trainingPlan!.totalNbOfWorkouts.toDouble(), 
                        label: "Séances",
                        toInt: true,
                      )
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                /// Section: Weekly training plan.
                Text(
                  "Plan d'entraînement",
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,                    
                  ),
                ),
                const SizedBox(height: 10),
                
                /// List of daily plans in the current weekly plan.
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: widget.trainingPlan!.currentWeeklyPlan.dailyPlans.length,
                  itemBuilder: (context, index) {
                    final plan = widget.trainingPlan!.currentWeeklyPlan.dailyPlans[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: DailyPlanCard(
                        dayOfWeek: plan.dayOfWeek,
                        sport: plan.sport,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),          
        ),
      ),
    );
  }
}