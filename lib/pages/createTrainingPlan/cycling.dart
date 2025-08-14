import 'package:ferum/widgets/infoCard.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../widgets/gradientButton.dart';
import 'running.dart';

class cyclingPageTrainingPlan extends StatefulWidget {
  const cyclingPageTrainingPlan({super.key});

  @override
  State<cyclingPageTrainingPlan> createState() =>
      _cyclingPageTrainingPlanState();
}

class _cyclingPageTrainingPlanState extends State<cyclingPageTrainingPlan> {
  DateTime selectedDay = DateTime.now();
  SharedPreferences? prefs;
  String? selectedCardTitle;
  String? selectedCardDenivele;

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
                      'Objectif Vélo',
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
                              if (selectedCardTitle == "20km") {
                                selectedCardTitle = null;
                              } else {
                                selectedCardTitle = "20km";
                              }
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: selectedCardTitle == "20km"
                                  ? const LinearGradient(
                                      colors: [
                                        Color(0xFF0D47A1),
                                        Colors.purple,
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    )
                                  : null,
                              border: selectedCardTitle == "20km"
                                  ? null
                                  : Border.all(color: Colors.transparent),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: InfoCard(title: "20km", size: 110),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              if (selectedCardTitle == "40km") {
                                selectedCardTitle = null;
                              } else {
                                selectedCardTitle = "40km";
                              }
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: selectedCardTitle == "40km"
                                  ? const LinearGradient(
                                      colors: [
                                        Color(0xFF0D47A1),
                                        Colors.purple,
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    )
                                  : null,
                              border: selectedCardTitle == "40km"
                                  ? null
                                  : Border.all(color: Colors.transparent),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: InfoCard(title: "40km", size: 110),
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
                              if (selectedCardTitle == "100km") {
                                selectedCardTitle = null;
                              } else {
                                selectedCardTitle = "100km";
                              }
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: selectedCardTitle == "100km"
                                  ? const LinearGradient(
                                      colors: [
                                        Color(0xFF0D47A1),
                                        Colors.purple,
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    )
                                  : null,
                              border: selectedCardTitle == "100km"
                                  ? null
                                  : Border.all(color: Colors.transparent),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: InfoCard(title: "100km", size: 110),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              if (selectedCardTitle == "180km") {
                                selectedCardTitle = null;
                              } else {
                                selectedCardTitle = "180km";
                              }
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: selectedCardTitle == "180km"
                                  ? const LinearGradient(
                                      colors: [
                                        Color(0xFF0D47A1),
                                        Colors.purple,
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    )
                                  : null,
                              border: selectedCardTitle == "180km"
                                  ? null
                                  : Border.all(color: Colors.transparent),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: InfoCard(title: "180km", size: 110),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Dénivelé',
                      style: TextStyle(
                        fontSize: 24,
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
                              if (selectedCardDenivele == "faible") {
                                selectedCardDenivele = null;
                              } else {
                                selectedCardDenivele = "faible";
                              }
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: selectedCardDenivele == "faible"
                                  ? const LinearGradient(
                                      colors: [
                                        Color(0xFF0D47A1),
                                        Colors.purple,
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    )
                                  : null,
                              border: selectedCardDenivele == "faible"
                                  ? null
                                  : Border.all(color: Colors.transparent),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: InfoCard(title: "faible", size: 90),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              if (selectedCardDenivele == "moyen") {
                                selectedCardDenivele = null;
                              } else {
                                selectedCardDenivele = "moyen";
                              }
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: selectedCardDenivele == "moyen"
                                  ? const LinearGradient(
                                      colors: [
                                        Color(0xFF0D47A1),
                                        Colors.purple,
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    )
                                  : null,
                              border: selectedCardDenivele == "moyen"
                                  ? null
                                  : Border.all(color: Colors.transparent),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: InfoCard(title: "moyen", size: 90),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              if (selectedCardDenivele == "élevé") {
                                selectedCardDenivele = null;
                              } else {
                                selectedCardDenivele = "élevé";
                              }
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: selectedCardDenivele == "élevé"
                                  ? const LinearGradient(
                                      colors: [
                                        Color(0xFF0D47A1),
                                        Colors.purple,
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    )
                                  : null,
                              border: selectedCardDenivele == "élevé"
                                  ? null
                                  : Border.all(color: Colors.transparent),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: InfoCard(title: "élevé", size: 90),
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
                    await p.setString(
                      'selectedCyclingDenivele',
                      selectedCardDenivele!,
                    );
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const runningPageTrainingPlan(),
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
