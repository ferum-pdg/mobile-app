import 'dart:convert';

import 'package:ferum/models/goal_model.dart';
import 'package:ferum/widgets/goalHeader.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Screen to select the end date of the training plan.
/// The minimum duration is calculated based on the selected goals.
class EndDateScreen extends StatefulWidget {
  const EndDateScreen({super.key});

  @override
  State<EndDateScreen> createState() => _EndDateScreenState();
}

class _EndDateScreenState extends State<EndDateScreen> {
  // Currently selected end date.
  DateTime endDateDay = DateTime.now();

  SharedPreferences? prefs;

  // Loading indicator.
  bool isLoading = true;

  // Default minimum duration in weeks if no goals are selected.
  int minWeeksRequired = 12;

  @override
  void initState() {
    super.initState();
    // Initialize French date formatting.
    initializeDateFormatting('fr_FR', null);
    // Load the minimum number of weeks from the selected goals.
    _loadMinWeeksRequired();
  }

  /// Loads the selected goals from SharedPreferences and calculates
  /// the maximum number of weeks required among them.
  Future<void> _loadMinWeeksRequired() async {
    final prefs = await SharedPreferences.getInstance();

    // Retrieve stored goals.
    final String? runningGoalString = prefs.getString('selectedRunningGoal');
    final String? swimmingGoalString = prefs.getString('selectedSwimmingGoal');
    final String? cyclingGoalString = prefs.getString('selectedCyclingGoal');

    final List<int> weeks = [];

    // Decode each goal and add its duration in weeks.
    if (runningGoalString != null) {
      final goal = Goal.fromJson(jsonDecode(runningGoalString));
      weeks.add(goal.nbOfWeek);
    }
    if (swimmingGoalString != null) {
      final goal = Goal.fromJson(jsonDecode(swimmingGoalString));
      weeks.add(goal.nbOfWeek);
    }
    if (cyclingGoalString != null) {
      final goal = Goal.fromJson(jsonDecode(cyclingGoalString));
      weeks.add(goal.nbOfWeek);
    }

    // Take the maximum number of weeks or default if no goals.
    final maxWeeks = weeks.isNotEmpty
        ? weeks.reduce((a, b) => a > b ? a : b)
        : minWeeksRequired;

    setState(() {
      minWeeksRequired = maxWeeks;
      endDateDay = DateTime.now()
          .add(Duration(days: maxWeeks * 7))
          .add(Duration(days: 1));
      isLoading = false;
    });
  }

  /// Called when a day is selected in the calendar.
  void _onDaySelected(DateTime day, DateTime focusedDay) async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      endDateDay = day;
    });

    // Save the selected end date in SharedPreferences.
    String formattedDate = DateFormat('yyyy-MM-dd').format(day);
    await prefs.setString('endDate', formattedDate);
  }

  @override
  Widget build(BuildContext context) {
    // Show loading indicator while calculating minWeeksRequired.
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              GoalHeader(
                title: "Objectif",
                subTitle: "Date",
                icon: Icons.date_range,
                gradientColors: [Color(0xFF0D47A1), Colors.purple],
              ),
              const SizedBox(height: 20),
              // Calendar widget to select the end date.
              TableCalendar(
                headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                ),
                locale: 'fr_FR',
                startingDayOfWeek: StartingDayOfWeek.monday,
                availableGestures: AvailableGestures.all,
                selectedDayPredicate: (day) => isSameDay(day, endDateDay),
                focusedDay: endDateDay,
                // The earliest selectable date is minWeeksRequired weeks from now.
                firstDay: DateTime.now()
                    .add(Duration(days: (minWeeksRequired * 7)))
                    .add(Duration(days: 1)),
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
            ],
          ),
        ),
      ),
    );
  }
}
