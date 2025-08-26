import 'dart:ui';

import 'package:ferum/pages/createTrainingPlan/running.dart';
import 'package:ferum/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/sharedPreferences.dart';
import '../workouts.dart';
import '../../widgets/gradientButton.dart';

class goalDatePage extends StatefulWidget {
  const goalDatePage({super.key});

  @override
  State<goalDatePage> createState() => _goalDatePageState();
}

class _goalDatePageState extends State<goalDatePage> {
  DateTime selectedDay = DateTime.now().add(Duration(days: 84));
  SharedPreferences? prefs;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('fr_FR', null);
  }

  void _onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      selectedDay = day;
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
                  "Définir la date de l'objectif",
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
                  firstDay: DateTime.now().add(Duration(days: 82)),
                  lastDay: DateTime.utc(2030, 10, 10),
                  onDaySelected: _onDaySelected,
                  calendarStyle: CalendarStyle(
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
                    onTap: () async {
                      final p = prefs ?? await SharedPreferences.getInstance();
                      await p.setString(
                        'selectedRunningGoal',
                        selectedDay.toString(),
                      );
                      await p.setBool('hasTrainingPlan', true);

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const WorkoutsPage(),
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
