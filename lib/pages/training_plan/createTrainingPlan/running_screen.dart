import 'package:ferum/models/goal_model.dart';
import 'package:ferum/services/goal_service.dart';
import 'package:ferum/widgets/goalCard.dart';
import 'package:ferum/widgets/goalHeader.dart';
import 'package:ferum/widgets/infoCard.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../widgets/gradientButton.dart';
import 'endDate_screen.dart';

class RunningScreen extends StatefulWidget {
  const RunningScreen({super.key});

  @override
  State<RunningScreen> createState() =>
      _RunningScreenState();
}

class _RunningScreenState extends State<RunningScreen> {
  DateTime selectedDay = DateTime.now();
  SharedPreferences? prefs;
  GoalsList? runningGoalsList;

  @override
  void initState() {
    super.initState();
    initPrefs();
    getRunningGoals();
  }

  Future<void> getRunningGoals() async {
    GoalsList? list = await GoalService().getGoalsBySport("RUNNING");
    setState(() {      
      runningGoalsList = list;
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
              subTitle: "Running", 
              icon: Icons.directions_run, 
              gradientColors: [Color(0xFF0D47A1), Colors.purple]
            ),
            if (runningGoalsList != null)...[
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(24.0),
                  itemCount: runningGoalsList?.goals.length,                        
                  itemBuilder: (context, index) {                    
                    final goal = runningGoalsList?.goals[index];
                    final isSelected = goal!.id == prefs!.getString('selectedRunningGoal');

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          if (isSelected){
                            prefs!.remove('selectedRunningGoal');
                          } else {                            
                            prefs!.setString('selectedRunningGoal', goal!.id);
                          }
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: GoalCard(
                          name: goal!.name, 
                          icon: Icons.directions_run,
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
