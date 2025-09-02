import 'dart:convert';

import 'package:ferum/models/goal_model.dart';
import 'package:ferum/services/goal_service.dart';
import 'package:ferum/widgets/goalCard.dart';
import 'package:ferum/widgets/goalHeader.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Screen that allows the user to select a cycling-related goal.
/// Goals are retrieved from the backend through [GoalService] and persisted
/// locally using SharedPreferences.
class CyclingScreen extends StatefulWidget {
  const CyclingScreen({super.key});

  @override
  State<CyclingScreen> createState() =>
      _CyclingScreenState();
}

class _CyclingScreenState extends State<CyclingScreen> {
  SharedPreferences? prefs;
  String? selectedGoalUID;
  GoalsList? cyclingGoalsList;

  @override
  void initState() {
    super.initState();
    _initPrefs();
    _getCyclingGoals();
  }

  /// Fetches the list of cycling goals from the backend service.
  Future<void> _getCyclingGoals() async {
    try {
      GoalsList? list = await GoalService().getGoalsBySport("CYCLING");
      setState(() {      
        cyclingGoalsList = list;
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
              subTitle: "Cycling", 
              icon: Icons.directions_bike, 
              gradientColors: [Color(0xFF0D47A1), Colors.purple]
            ),
            // Show list of cycling goals if they have been loaded.
            if (cyclingGoalsList != null)...[
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(24.0),
                  itemCount: cyclingGoalsList?.goals.length,                        
                  itemBuilder: (context, index) {                    
                    final goal = cyclingGoalsList?.goals[index];

                    // Retrieve locally saved goal from SharedPreferences.
                    final selectedGoalString = prefs!.getString('selectedCyclingGoal');
                    Goal? selectedGoal;

                    if (selectedGoalString != null){
                      selectedGoal = Goal.fromJson(jsonDecode(selectedGoalString));
                    }
                    
                    // Check if the current goal is the one selected by the user
                    final isSelected = selectedGoal != null && goal!.id == selectedGoal.id;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          // Toggle goal selection: save or remove from SharedPreferences.
                          if (isSelected){
                            prefs!.remove('selectedCyclingGoal');
                          } else {                            
                            prefs!.setString('selectedCyclingGoal', jsonEncode(goal.toJson()));
                          }
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: GoalCard(
                          name: goal!.name, 
                          icon: Icons.directions_bike,
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
