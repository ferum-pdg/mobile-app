import 'package:ferum/models/training_plan_model.dart';
import 'package:ferum/widgets/daily_plan_card.dart';

import 'package:ferum/widgets/progress_pie_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
                Text(
                  "État programme",
                  style: GoogleFonts.volkhov(
                    fontSize: 32,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 8),                           
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: ProgressPieChart(
                        current: widget.trainingPlan!.currentWeekNb, 
                        total: widget.trainingPlan!.totalNbOfWeeks, 
                        title: "Semaines", 
                      )
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ProgressPieChart(
                        current: widget.trainingPlan!.currentNbOfWorkouts, 
                        total: widget.trainingPlan!.totalNbOfWorkouts, 
                        title: "Séances", 
                      )
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Text(
                  "Plan d'entraînement",
                  style: GoogleFonts.volkhov(
                    fontSize: 24,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 10),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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