import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/gradientButton.dart';
import 'training_plan/createTrainingPlan/swimming_screen.dart';

// Workouts screen: calendar selection + entry point to create a training plan
class WorkoutsPage extends StatefulWidget {
  const WorkoutsPage({super.key});

  @override
  State<WorkoutsPage> createState() => _WorkoutsPageState();
}

class _WorkoutsPageState extends State<WorkoutsPage> {
  // Currently selected date in the calendar (defaults to today)
  DateTime selectedDay = DateTime.now();
  // Cached SharedPreferences instance used to read simple flags (e.g., hasTrainingPlan)
  SharedPreferences? prefs;

  @override
  void initState() {
    super.initState();
    // Ensure French locale data is loaded for TableCalendar titles/labels
    initializeDateFormatting('fr_FR', null);
    // Load SharedPreferences asynchronously and store in state
    initPrefs();
  }

  // Update the selected day when the user taps a date
  void _onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      selectedDay = day;
    });
  }

  Future<void> initPrefs() async {
    // Obtain a single SharedPreferences instance (async)
    SharedPreferences p = await SharedPreferences.getInstance();

    setState(() {
      prefs = p;
    });
  }

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
                const Text(
                  'Entrainements',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                // Monthly calendar (French locale) with Monday as the first day
                TableCalendar(
                  headerStyle: HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                  ),
                  locale: 'fr_FR',
                  startingDayOfWeek: StartingDayOfWeek.monday,
                  availableGestures: AvailableGestures.all,
                  // Tell the calendar which day is selected for styling
                  selectedDayPredicate: (day) => isSameDay(day, selectedDay),
                  // Center the calendar on the selected day
                  focusedDay: selectedDay,
                  // Visible range of the calendar
                  firstDay: DateTime.utc(2020, 10, 10),
                  lastDay: DateTime.utc(2030, 10, 10),
                  onDaySelected: _onDaySelected,
                  calendarStyle: CalendarStyle(
                    // Today’s cell: semi-transparent gradient circle
                    todayDecoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.purple.withValues(alpha: 0.7),
                          Color(0xFF0D47A1).withValues(alpha: 0.7),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                    ),
                    // Selected day: solid gradient circle
                    selectedDecoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF0D47A1), Colors.purple],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                // If no training plan exists yet, show the CTA to create one
                if (!(prefs?.getBool('hasTrainingPlan') ?? false)) ...[
                  const SizedBox(height: 10),
                  GradientButton(
                    text: "Créer un plan d'entraînement",
                    onTap: () {
                      // Navigate to the plan creation flow (starts with SwimmingScreen)
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SwimmingScreen(),
                        ),
                      );
                    },
                    height: 60,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
