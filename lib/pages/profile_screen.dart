import 'dart:convert';

import 'package:ferum/models/user_model.dart';
import 'package:ferum/widgets/gradientButton.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {

  const ProfilePage({super.key});  

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User? _user;

  @override
  void initState(){
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('user');
    final user = User.fromJson(jsonDecode(userJson));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [          
          Container(
            height: 290,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0D47A1), Colors.purple],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                const CircleAvatar(
                  radius: 50,
                  //backgroundImage: AssetImage("assets/images/profile.jpg"),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Alex",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  "alex@email.com",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 4,
                  child: ListTile(
                    leading: const Icon(Icons.person, color: Colors.purple),
                    title: const Text("Nom complet"),
                    subtitle: const Text("John Doe"),
                  ),
                ),
                const SizedBox(height: 10),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 4,
                  child: ListTile(
                    leading: const Icon(Icons.fitness_center, color: Colors.purple),
                    title: const Text("Poids"),
                    subtitle: const Text("75 kg"),
                  ),
                ),
                const SizedBox(height: 10),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 4,
                  child: ListTile(
                    leading: const Icon(Icons.height, color: Colors.purple),
                    title: const Text("Taille"),
                    subtitle: const Text("180 cm"),
                  ),
                ),
                const SizedBox(height: 10),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 4,
                  child: ListTile(
                    leading: const Icon(Icons.favorite, color: Colors.purple),
                    title: const Text("Fréquence Cardiaque Max"),
                    subtitle: const Text("190 bpm"),
                  ),
                ),

                const SizedBox(height: 20),

                GradientButton(
                  text: "Modifier le profil", 
                  height: 30,
                  onTap: () {
                    
                  },
                )
                
              ],
            ),
          )
        ],
      ),
    );
  }
}
