import 'dart:convert';

import 'package:ferum/models/goal_model.dart';
import 'package:ferum/services/goal_service.dart';
import 'package:ferum/widgets/goalCard.dart';
import 'package:ferum/widgets/goalHeader.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


/// Screen that allows the user to select a swimming-related goal.
/// Goals are retrieved from the backend through [GoalService] and persisted
/// locally using SharedPreferences.
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
    _initPrefs();
    _getSwimmingGoals();
  }

  /// Fetches the list of swimming goals from the backend service.
  Future<void> _getSwimmingGoals() async {
    try {
      GoalsList? list = await GoalService().getGoalsBySport("SWIMMING");
      setState(() {      
        swimmingGoalsList = list;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  /// Initializes SharedPreferences instance used for persisting selected goal.
  Future<void> _initPrefs() async {
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
            // Show list of swimming goals if they have been loaded.
            if (swimmingGoalsList != null)...[
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(24.0),
                  itemCount: swimmingGoalsList?.goals.length,                        
                  itemBuilder: (context, index) {                    
                    final goal = swimmingGoalsList?.goals[index];

                    // Retrieve locally saved goal from SharedPreferences.
                    final selectedGoalString = prefs!.getString('selectedSwimmingGoal');
                    Goal? selectedGoal;

                    if (selectedGoalString != null){
                      selectedGoal = Goal.fromJson(jsonDecode(selectedGoalString));
                    }

                    // Check if the current goal is the one selected by the user.
                    final isSelected = selectedGoal != null && goal!.id == selectedGoal.id;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          // Toggle goal selection: save or remove from SharedPreferences.
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
