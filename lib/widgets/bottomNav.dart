import 'package:ferum/pages/training_plan/training_plan_wrapper.dart';
import 'package:flutter/material.dart';

import '../pages/profile_screen.dart';
import '../pages/home.dart';
import '../models/user_model.dart';
import 'package:ferum/pages/workouts.dart';

class BottomNav extends StatefulWidget {
  final User? user;

  const BottomNav({
    super.key,
    required this.user
  });

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int selectedIndex = 0;

  PageController pageController = PageController();

  void onTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
    pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pageController,
        children: [MyHomePage(), TrainingPlanWrapper(), ProfilePage(user: widget.user)],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Accueil',
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sports),
            label: 'Entrainements',
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
            backgroundColor: Colors.blue,
          ),
        ],
        onTap: onTapped,
      ),
    );
  }
}
