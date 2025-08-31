import 'package:ferum/widgets/goalHeader.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EndDateScreen extends StatefulWidget {
  const EndDateScreen({super.key});

  @override
  State<EndDateScreen> createState() => _EndDateScreenState();
}

class _EndDateScreenState extends State<EndDateScreen> {
  DateTime endDateDay = DateTime.now().add(Duration(days: 84));
  SharedPreferences? prefs;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('fr_FR', null);
  }

  void _onDaySelected(DateTime day, DateTime focusedDay) async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      endDateDay = day;
    });

    String formattedDate = DateFormat('yyyy-MM-dd').format(day);
    await prefs.setString('endDate', formattedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(          
          children: [
            GoalHeader(
                  title: "Objectif", 
                  subTitle: "Date", 
                  icon: Icons.date_range, 
                  gradientColors: [Color(0xFF0D47A1), Colors.purple]
            ),
            const SizedBox(height: 20),
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
          ],
        ),        
      ),
    );
  }
}
