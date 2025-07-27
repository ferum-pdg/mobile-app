import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {

  static const routeName = '/profilePage';

  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(30.0),        
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 100),
              const Text(
                'Bienvenue, Alex',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                "Résumé de votre activité et informations personnelles",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),

              // Profile card.
              Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(vertical: 20),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.black, width: 1.5),                                
                ),
                child: Column(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blue,
                      ),
                      child: const Center(
                        child: Icon(Icons.person, color: Colors.black),
                      ),
                    ),
                    const SizedBox(width: 24),
                    const Text(
                      'Alex Dupont',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              const Text(
                'Statistiques',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),

              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 1.2,
                  children: [
                    Container(
                    width: 50,
                    height: 50,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blue,
                    ),
                    child: const Center(
                      child: Icon(Icons.person, color: Colors.black),
                    ),
                    ),
                    const SizedBox(width: 24),
                    const Text(
                      'Alex Dupont',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                )
              )

            ],
      ),
    );
  }
}
