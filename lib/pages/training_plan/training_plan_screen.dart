import 'dart:convert';

import 'package:ferum/models/training_plan_model.dart';
import 'package:ferum/widgets/daily_plan_card.dart';
import 'package:ferum/widgets/gradientButton.dart';
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
                        current: 2, 
                        total: 8, 
                        title: "Semaines", 
                      )
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ProgressPieChart(
                        current: 45, 
                        total: 51, 
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
                DailyPlanCard(
                  dayOfWeek: "Monday",
                  sport: "Running",
                  workoutType: "EF"
                ),
                const SizedBox(height: 10),
                DailyPlanCard(
                  dayOfWeek: "Tuesday",
                  sport: "Repos",
                  workoutType: "Rest"
                ),                
                
              ],
            ),
          ),          
        ),
      ),
    );
  }
}