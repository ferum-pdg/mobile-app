import 'package:ferum/models/training_plan_model.dart';
import 'package:ferum/pages/training_plan/createTrainingPlan/cycling_screen.dart';
import 'package:ferum/pages/training_plan/createTrainingPlan/endDate_screen.dart';
import 'package:ferum/pages/training_plan/createTrainingPlan/running_screen.dart';
import 'package:ferum/pages/training_plan/createTrainingPlan/swimming_screen.dart';
import 'package:ferum/pages/training_plan/createTrainingPlan/daysOfWeek_screen.dart';
import 'package:ferum/services/training_plan_service.dart';
import 'package:ferum/widgets/gradientButton.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class IntroScreen extends StatefulWidget {
  final Function(TrainingPlan) onPlanCreated;
  
  const IntroScreen({
    super.key,
    required this.onPlanCreated,
  });

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  
  late final List<Widget> _pages;

  @override
  void initState() {    
    super.initState();
    _pages = [
      _welcomeScreen(),
      RunningScreen(),
      SwimmingScreen(),
      CyclingScreen(),
      DaysOfWeekScreen(),
      EndDateScreen()
    ];
  }

  void _nextPage() async {
    if (_currentPage < _pages.length - 1){
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300), 
        curve: Curves.easeOut,
      );
    } else {
    // Last page : plan is created
    try {
      final plan = await TrainingPlanService().createTrainingPlan();

      if (plan != null) {
        widget.onPlanCreated(plan);
      } 
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }
  }

  Widget _welcomeScreen(){
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          Text(
            "Bienvenue !",
            style: GoogleFonts.volkhov(
              fontSize: 14,
              color: Colors.black,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            "Ici vous pourrez créer un plan d'entraînement qui vous permettra d'atteindre des sommets!",
            style: GoogleFonts.volkhov(
              fontSize: 14,
              color: Colors.black,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          Image.asset(
            "assets/img/icon-tp.png",
            height: 400,
          ),
          const SizedBox(height: 20),
          Text(
            "Rejoins des centaines d'utilisateur-ices satisfait-e-s!",
            style: GoogleFonts.volkhov(
              fontSize: 14,
              color: Colors.black,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),            
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
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              children: _pages,
            )
          ),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: GradientButton(
              text: _currentPage < _pages.length - 1 ? "Suivant" : "Je crée mon plan", 
              onTap: _nextPage,
              height: 60.0,
            ),
          )
        ],
      ),
    );
  }
}