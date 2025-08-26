import 'package:ferum/widgets/infoCard.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../widgets/gradientButton.dart';
import 'goalDate.dart';

class runningPageTrainingPlan extends StatefulWidget {
  const runningPageTrainingPlan({super.key});

  @override
  State<runningPageTrainingPlan> createState() =>
      _runningPageTrainingPlanState();
}

class _runningPageTrainingPlanState extends State<runningPageTrainingPlan> {
  DateTime selectedDay = DateTime.now();
  SharedPreferences? prefs;
  String? selectedCardTitle;

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
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    const SizedBox(height: 24),
                    const Text(
                      'Objectif Running',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 50),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              if (selectedCardTitle == "5km") {
                                selectedCardTitle = null;
                              } else {
                                selectedCardTitle = "5km";
                              }
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: selectedCardTitle == "5km"
                                  ? const LinearGradient(
                                      colors: [
                                        Color(0xFF0D47A1),
                                        Colors.purple,
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    )
                                  : null,
                              border: selectedCardTitle == "5km"
                                  ? null
                                  : Border.all(color: Colors.transparent),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: InfoCard(title: "5km", size: 110),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              if (selectedCardTitle == "10km") {
                                selectedCardTitle = null;
                              } else {
                                selectedCardTitle = "10km";
                              }
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: selectedCardTitle == "10km"
                                  ? const LinearGradient(
                                      colors: [
                                        Color(0xFF0D47A1),
                                        Colors.purple,
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    )
                                  : null,
                              border: selectedCardTitle == "10km"
                                  ? null
                                  : Border.all(color: Colors.transparent),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: InfoCard(title: "10km", size: 110),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              if (selectedCardTitle == "21km") {
                                selectedCardTitle = null;
                              } else {
                                selectedCardTitle = "21km";
                              }
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: selectedCardTitle == "21km"
                                  ? const LinearGradient(
                                      colors: [
                                        Color(0xFF0D47A1),
                                        Colors.purple,
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    )
                                  : null,
                              border: selectedCardTitle == "21km"
                                  ? null
                                  : Border.all(color: Colors.transparent),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: InfoCard(title: "21km", size: 110),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              if (selectedCardTitle == "42") {
                                selectedCardTitle = null;
                              } else {
                                selectedCardTitle = "42";
                              }
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: selectedCardTitle == "42"
                                  ? const LinearGradient(
                                      colors: [
                                        Color(0xFF0D47A1),
                                        Colors.purple,
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    )
                                  : null,
                              border: selectedCardTitle == "42"
                                  ? null
                                  : Border.all(color: Colors.transparent),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: InfoCard(title: "42km", size: 110),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: GradientButton(
                text: "Suivant",
                onTap: () async {
                  if (selectedCardTitle != null) {
                    final p = prefs ?? await SharedPreferences.getInstance();
                    await p.setString(
                      'selectedRunningGoal',
                      selectedCardTitle!,
                    );
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const goalDatePage(),
                    ),
                  );
                },
                height: 60,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
