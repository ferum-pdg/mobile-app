import 'package:ferum/widgets/goalCard.dart';
import 'package:ferum/widgets/goalHeader.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Screen to select preferred training days of the week.
/// Selected days are persisted locally using SharedPreferences.
class DaysOfWeekScreen extends StatefulWidget {
  const DaysOfWeekScreen({super.key});

  @override
  State<DaysOfWeekScreen> createState() => _DaysOfWeekScreenState();
}

class _DaysOfWeekScreenState extends State<DaysOfWeekScreen> {
  SharedPreferences? prefs;
  
  // List of all weekdays.
  final List<String> days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
  
  // Store selected days as uppercase strings for consistency.
  final Set<String> selectedDay = {};
  
  @override
  void initState() {
    super.initState();
    _initPrefs();
  }

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
              title: "Jours", 
              subTitle: "Semaine", 
              icon: Icons.calendar_month, 
              gradientColors: [Color(0xFF0D47A1), Colors.purple]
            ),
            // List of weekdays with selection state.
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(24.0),
                itemCount: days.length,                        
                itemBuilder: (context, index) {                    
                  final day = days[index];

                  // Check if the day is selected.
                  final isSelected = selectedDay.contains(day.toUpperCase());

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        // Toggle selection state.
                        if (isSelected){
                          selectedDay.remove(day.toUpperCase());
                        } else {                            
                          selectedDay.add(day.toUpperCase());
                        }
                        // Persist selected days in SharedPreferences.
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