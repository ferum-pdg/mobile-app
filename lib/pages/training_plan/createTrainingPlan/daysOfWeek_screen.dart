import 'package:ferum/widgets/goalCard.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DaysOfWeekScreen extends StatefulWidget {
  const DaysOfWeekScreen({super.key});

  @override
  State<DaysOfWeekScreen> createState() => _DaysOfWeekScreenState();
}

class _DaysOfWeekScreenState extends State<DaysOfWeekScreen> {
  SharedPreferences? prefs;
  final List<String> days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
  final Set<String> selectedDay = {};
  
  @override
  void initState() {
    super.initState();
    initPrefs();
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
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.calendar_month,
                    size: 32,
                    color: Color(0xFF0D47A1)
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    "Jours de la semaine",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple,
                      letterSpacing: 1.2
                    ),
                  ),
                ],
              ),              
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(24.0),
                itemCount: days.length,                        
                itemBuilder: (context, index) {                    
                  final day = days[index];
                  final isSelected = selectedDay.contains(day.toUpperCase());

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isSelected){
                          selectedDay.remove(day.toUpperCase());
                        } else {                            
                          selectedDay.add(day.toUpperCase());
                        }
                        prefs?.setStringList('selectedDays', selectedDay.toList());
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: GoalCard(
                        name: day, 
                        icon: Icons.calendar_view_day,
                        isSelected: isSelected,
                      ),
                    ),
                  );
                }
              )
            ),
          ]                  
        ),
      ),
    );
  }
}