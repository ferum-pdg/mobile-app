import 'package:ferum/models/goal_model.dart';
import 'package:ferum/services/goal_service.dart';
import 'package:ferum/widgets/goalCard.dart';
import 'package:ferum/widgets/goalHeader.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CyclingScreen extends StatefulWidget {
  const CyclingScreen({super.key});

  @override
  State<CyclingScreen> createState() =>
      _CyclingScreenState();
}

class _CyclingScreenState extends State<CyclingScreen> {
  DateTime selectedDay = DateTime.now();
  SharedPreferences? prefs;
  String? selectedGoalUID;
  GoalsList? cyclingGoalsList;

  @override
  void initState() {
    super.initState();
    initPrefs();
    getCyclingGoals();
  }

  Future<void> getCyclingGoals() async {
    GoalsList? list = await GoalService().getGoalsBySport("CYCLING");
    setState(() {      
      cyclingGoalsList = list;
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
              subTitle: "Cycling", 
              icon: Icons.directions_bike, 
              gradientColors: [Color(0xFF0D47A1), Colors.purple]
            ),
            if (cyclingGoalsList != null)...[
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(24.0),
                  itemCount: cyclingGoalsList?.goals.length,                        
                  itemBuilder: (context, index) {                    
                    final goal = cyclingGoalsList?.goals[index];
                    final isSelected = goal!.id == prefs!.getString('selectedCyclingGoal');

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          if (isSelected){
                            prefs!.remove('selectedCyclingGoal');
                          } else {                            
                            prefs!.setString('selectedCyclingGoal', goal!.id);
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
