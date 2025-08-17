import 'package:ferum/widgets/gradientButton.dart';
import 'package:ferum/widgets/inforSectionCard.dart';
import 'package:flutter/material.dart';

import '../widgets/infoCard.dart';
import '../widgets/gradientButton.dart';

class ProfilePage extends StatelessWidget {

  static const routeName = '/profilePage';

  const ProfilePage({super.key});

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),        
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                const Text(
                  'Bienvenue, Alex',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),

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
                  'Informations personnelles',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),

                const InfoSectionCard(
                  fields: [
                    MapEntry("Âge", "28 ans"),
                    MapEntry("Poids", "72 kg"),
                    MapEntry("Taille", "175 cm"),
                    MapEntry("Niveau", "Intermédiaire"),
                  ]              
                ),

                const Text(
                  'Objectifs',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),

                const InfoSectionCard(
                  fields: [
                    MapEntry("Poids", "70 kg"),
                    MapEntry("Dist hebdo", "30 km"),
                    MapEntry("Fréquence", "5 par sem"),
                  ]              
                ),

                const SizedBox(height: 12),
                const SizedBox(height: 18),

                GradientButton(
                  text: "Modifier le profil", 
                  onTap: null
                )
              ],
          ),
        )
      )
    );
  }
}
