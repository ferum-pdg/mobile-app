import 'dart:convert';

import 'package:ferum/models/goal_model.dart';
import 'package:ferum/services/goal_service.dart';
import 'package:ferum/widgets/goalCard.dart';
import 'package:ferum/widgets/goalHeader.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SwimmingScreen extends StatefulWidget {
  const SwimmingScreen({super.key});

  @override
  State<SwimmingScreen> createState() =>
      _SwimmingScreenState();
}

class _SwimmingScreenState extends State<SwimmingScreen> {
  DateTime selectedDay = DateTime.now();
  SharedPreferences? prefs;
  GoalsList? swimmingGoalsList;

  @override
  void initState() {
    super.initState();
    initPrefs();
    getSwimmingGoals();
  }

  Future<void> getSwimmingGoals() async {
    GoalsList? list = await GoalService().getGoalsBySport("SWIMMING");
    setState(() {      
      swimmingGoalsList = list;
    });
  }

  Future<void> initPrefs() async {
    SharedPreferences p = await SharedPreferences.getInstance();
    setState(() {
      prefs = p;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GoalHeader(
              title: "Objectif", 
              subTitle: "Swimming", 
              icon: Icons.pool, 
              gradientColors: [Color(0xFF0D47A1), Colors.purple]
            ),
            if (swimmingGoalsList != null)...[
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(24.0),
                  itemCount: swimmingGoalsList?.goals.length,                        
                  itemBuilder: (context, index) {                    
                    final goal = swimmingGoalsList?.goals[index];
                    final isSelected = goal!.id == prefs!.getString('selectedSwimmingGoal');

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          if (isSelected){
                            prefs!.remove('selectedSwimmingGoal');
                          } else {                            
                            prefs!.setString('selectedSwimmingGoal', jsonEncode(goal.toJson()));
                          }
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: GoalCard(
                          name: goal!.name, 
                          icon: Icons.pool,
                          isSelected: isSelected,
                        ),
                      ),
                    );
                  }
                )
              ),
            ]        
          ],
        ),
      ),
    );
  }
}
