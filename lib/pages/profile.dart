import 'package:ferum/widgets/inforSectionCard.dart';
import 'package:flutter/material.dart';

import '../widgets/infoCard.dart';

class ProfilePage extends StatelessWidget {

  static const routeName = '/profilePage';

  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
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

                const Text(
                  'Statistiques',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 12),
                
                GridView.count(
                  crossAxisCount: 2, // 2 colonnes
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 1.2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    InfoCard(
                      title: "156", 
                      subtitle: "Séances"
                    ),
                    InfoCard(
                      title: "1247",
                      subtitle: "Kilomètres",
                    ),
                    InfoCard(
                      title: "89",
                      subtitle: "Jours actifs",
                    ),
                    InfoCard(
                      title: "85%",
                      subtitle: "Progression",
                    ),
                  ],
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

                const Text(
                  'Appareils connectés',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 12),

                GridView.count(
                  crossAxisCount: 2, // 2 colonnes
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 1.2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    InfoCard(
                      title: "Garmin", 
                      subtitle: "Forerunner 255"
                    ),
                    InfoCard(
                      title: "Apple",
                      subtitle: "Watch Series 9",
                    ),                                    
                  ],
                ),

                const SizedBox(height: 18),

                Center(
                  child:
                    ElevatedButton(                                            
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)
                        )
                      ), 
                      child: Text("Modifier le profil")
                    )
                )
              ],
          ),
        )
      )
    );
  }
}
