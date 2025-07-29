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
                'Informations personnelles',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),

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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text('Âge', style: TextStyle(fontSize: 16, color: Colors.black)),
                        Text('28 ans', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black))
                      ],
                    ),

                    const SizedBox(height: 8),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text('Poids', style: TextStyle(fontSize: 16, color: Colors.black)),
                        Text('72 kg', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black))
                      ],
                    ),

                    const SizedBox(height: 8),


                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text('Taille', style: TextStyle(fontSize: 16, color: Colors.black)),
                        Text('175 cm', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black))
                      ],
                    ),

                    const SizedBox(height: 8),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text('Niveau', style: TextStyle(fontSize: 16, color: Colors.black)),
                        Text('Intermédiaire', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black))
                      ],
                    )
                  ],
                ),
              ),

              const Text(
                'Objectifs',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),

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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text('Poids', style: TextStyle(fontSize: 16, color: Colors.black)),
                        Text('70 kg', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black))
                      ],
                    ),

                    const SizedBox(height: 8),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text('Dist hebdo', style: TextStyle(fontSize: 16, color: Colors.black)),
                        Text('30 km', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black))
                      ],
                    ),

                    const SizedBox(height: 8),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text('Fréquence', style: TextStyle(fontSize: 16, color: Colors.black)),
                        Text('5 par sem', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black))
                      ],
                    ),
                  ],
                ),
              )
            ],
        ),
      )
    );
  }
}
