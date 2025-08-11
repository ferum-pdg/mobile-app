import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/sharedPreferences.dart';

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
    super.initState;
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
                Text("${selectedDay.toString()}"),
                TableCalendar(
                  headerStyle: HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                  ),
                  locale: 'fr_FR',
                  availableGestures: AvailableGestures.all,
                  selectedDayPredicate: (day) => isSameDay(day, selectedDay),
                  focusedDay: selectedDay,
                  firstDay: DateTime.utc(2020, 10, 10),
                  lastDay: DateTime.utc(2030, 10, 10),
                  onDaySelected: _onDaySelected,
                ),
                Text(
                  "Bonjour ${prefs?.getString('username') ?? 'Athlète'}",
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
