import 'dart:ui';

import 'package:ferum/pages/training_plan/createTrainingPlan/running_screen.dart';
import 'package:ferum/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/sharedPreferences.dart';
import '../widgets/gradientButton.dart';
import 'training_plan/createTrainingPlan/swimming_screen.dart';

class WorkoutsPage extends StatefulWidget {
  const WorkoutsPage({super.key});

  @override
  State<WorkoutsPage> createState() => _WorkoutsPageState();
}

class _WorkoutsPageState extends State<WorkoutsPage> {
  DateTime selectedDay = DateTime.now();
  SharedPreferences? prefs;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('fr_FR', null);
    initPrefs();
  }

  void _onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      selectedDay = day;
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
                TableCalendar(
                  headerStyle: HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                  ),
                  locale: 'fr_FR',
                  startingDayOfWeek: StartingDayOfWeek.monday,
                  availableGestures: AvailableGestures.all,
                  selectedDayPredicate: (day) => isSameDay(day, selectedDay),
                  focusedDay: selectedDay,
                  firstDay: DateTime.utc(2020, 10, 10),
                  lastDay: DateTime.utc(2030, 10, 10),
                  onDaySelected: _onDaySelected,
                  calendarStyle: CalendarStyle(
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
                if (!(prefs?.getBool('hasTrainingPlan') ?? false)) ...[
                  const SizedBox(height: 10),
                  GradientButton(
                    text: "Créer un plan d'entraînement",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const SwimmingScreen(),
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
