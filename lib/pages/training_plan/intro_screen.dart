import 'package:ferum/models/training_plan_model.dart';
import 'package:ferum/pages/training_plan/createTrainingPlan/cycling_screen.dart';
import 'package:ferum/pages/training_plan/createTrainingPlan/end_date_screen.dart';
import 'package:ferum/pages/training_plan/createTrainingPlan/running_screen.dart';
import 'package:ferum/pages/training_plan/createTrainingPlan/swimming_screen.dart';
import 'package:ferum/pages/training_plan/createTrainingPlan/days_of_week_screen.dart';
import 'package:ferum/services/training_plan_service.dart';
import 'package:ferum/widgets/gradientButton.dart';

import 'package:flutter/material.dart';

// Onboarding flow for creating a training plan: sequence of screens, ends by calling TrainingPlanService
class IntroScreen extends StatefulWidget {
  final Function(TrainingPlan) onPlanCreated;

  const IntroScreen({super.key, required this.onPlanCreated});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final PageController _pageController = PageController();
  // Tracks the current page index.
  int _currentPage = 0;

  // The list of all setup screens.
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    // Initialize the list of pages in the onboarding flow.
    _pages = [
      _welcomeScreen(),
      RunningScreen(),
      SwimmingScreen(),
      CyclingScreen(),
      DaysOfWeekScreen(),
      EndDateScreen(),
    ];
  }

  /// Navigate to the next page.
  /// If it's the last page, attempt to create the training plan.
  void _nextPage() async {
    if (_currentPage < _pages.length - 1) {
      // Move to the next page with animation.
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    } else {
      // Last page: call the service to create the training plan.
      try {
        // Attempt to create the plan with the backend when reaching the last page
        final plan = await TrainingPlanService().createTrainingPlan();

        if (plan != null) {
          widget.onPlanCreated(plan);
        }
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  /// First screen displayed: introduction and motivation text.
  Widget _welcomeScreen() {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          Text(
            "Bienvenue !",
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Text(
            "Ici vous pourrez créer un plan d'entraînement qui vous permettra d'atteindre des sommets!",
            style: TextStyle(fontSize: 19),
          ),
          // Illustration for the intro screen
          Image.asset("assets/img/icon-tp.png", height: 350),
          const SizedBox(height: 20),
          Text(
            "Rejoins des centaines d'utilisateur-ices satisfait-e-s!",
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Swipeable pages for each setup step
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              children: _pages,
            ),
          ),

          // Bottom button to go to the next page or create the plan.
          Padding(
            padding: const EdgeInsets.all(16.0),
            // Bottom CTA: label changes depending on whether it's the last step
            child: GradientButton(
              text: _currentPage < _pages.length - 1
                  ? "Suivant"
                  : "Je crée mon plan",
              onTap: _nextPage,
              height: 60.0,
            ),
          ),
        ],
      ),
    );
  }
}
