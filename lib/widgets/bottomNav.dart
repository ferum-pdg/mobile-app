import 'package:ferum/pages/training_plan/training_plan_wrapper.dart';
import 'package:flutter/material.dart';

import '../pages/profile_screen.dart';
import '../pages/home.dart';
import '../models/user_model.dart';

// Main bottom navigation wrapper: switches between Home, Training Plan, and Profile
class BottomNav extends StatefulWidget {
  final User? user;

  const BottomNav({super.key, required this.user});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  // Tracks which tab is currently selected
  int selectedIndex = 0;

  // Controls PageView to sync with BottomNavigationBar
  PageController pageController = PageController();

  // Handle bottom nav tap: update index and jump to the corresponding page
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
        // Each tab's root widget: Home, Training Plan, Profile
        children: [
          MyHomePage(),
          TrainingPlanWrapper(),
          ProfilePage(user: widget.user),
        ],
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
