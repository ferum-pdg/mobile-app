import 'package:ferum/widgets/infoCard.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../widgets/gradientButton.dart';
import 'cycling.dart';

class swimmingPageTrainingPlan extends StatefulWidget {
  const swimmingPageTrainingPlan({super.key});

  @override
  State<swimmingPageTrainingPlan> createState() =>
      _swimmingPageTrainingPlanState();
}

class _swimmingPageTrainingPlanState extends State<swimmingPageTrainingPlan> {
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
                      'Objectif natation',
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
                              if (selectedCardTitle == "500m") {
                                selectedCardTitle = null;
                              } else {
                                selectedCardTitle = "500m";
                              }
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: selectedCardTitle == "500m"
                                  ? const LinearGradient(
                                      colors: [
                                        Color(0xFF0D47A1),
                                        Colors.purple,
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    )
                                  : null,
                              border: selectedCardTitle == "500m"
                                  ? null
                                  : Border.all(color: Colors.transparent),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: InfoCard(title: "500m", size: 110),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              if (selectedCardTitle == "1000m") {
                                selectedCardTitle = null;
                              } else {
                                selectedCardTitle = "1000m";
                              }
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: selectedCardTitle == "1000m"
                                  ? const LinearGradient(
                                      colors: [
                                        Color(0xFF0D47A1),
                                        Colors.purple,
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    )
                                  : null,
                              border: selectedCardTitle == "1000m"
                                  ? null
                                  : Border.all(color: Colors.transparent),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: InfoCard(title: "1000m", size: 110),
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
                              if (selectedCardTitle == "1800m") {
                                selectedCardTitle = null;
                              } else {
                                selectedCardTitle = "1800m";
                              }
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: selectedCardTitle == "1800m"
                                  ? const LinearGradient(
                                      colors: [Colors.blue, Colors.purple],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    )
                                  : null,
                              border: selectedCardTitle == "1800m"
                                  ? null
                                  : Border.all(color: Colors.transparent),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: InfoCard(title: "1800m", size: 110),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              if (selectedCardTitle == "3900m") {
                                selectedCardTitle = null;
                              } else {
                                selectedCardTitle = "3900m";
                              }
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: selectedCardTitle == "3900m"
                                  ? const LinearGradient(
                                      colors: [
                                        Color(0xFF0D47A1),
                                        Colors.purple,
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    )
                                  : null,
                              border: selectedCardTitle == "3900m"
                                  ? null
                                  : Border.all(color: Colors.transparent),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: InfoCard(title: "3900m", size: 110),
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
                      'selectedSwimmingGoal',
                      selectedCardTitle!,
                    );
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const cyclingPageTrainingPlan(),
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
