import 'dart:convert';

import 'package:ferum/models/user_model.dart';
import 'package:ferum/pages/edit_profile_screen.dart';
import 'package:ferum/pages/welcome_screen.dart';
import 'package:ferum/services/auth_service.dart';
import 'package:ferum/widgets/gradientButton.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  final User? user;
  const ProfilePage({
    super.key,
    required this.user
  });  

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User? _user;

  @override
  void initState(){
    super.initState();
    _user = widget.user;
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
                  backgroundImage: AssetImage("assets/img/profile.png"),
                ),
                const SizedBox(height: 10),
                Text(
                  "${_user!.firstName}",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "${_user!.email}",
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
                    subtitle: Text("${_user!.firstName} ${_user!.lastName}"),
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
                    subtitle: Text("${_user!.weight}"),
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
                    subtitle: Text("${_user!.height}"),
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
                    subtitle: Text("${_user!.fcMax}"),
                  ),
                ),

                const SizedBox(height: 20),


                Row(
                  children: [
                    Expanded(
                      child: GradientButton(
                        text: "Modifier",
                        height: 60,
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (e) => EditProfilePage(user: _user)),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: GradientButton(
                        text: "Déconnecter",
                        height: 60,
                        onTap: () async {
                          // Removes the token and the user.
                          await AuthService().logout();                                                   
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (e) => WelcomeScreen()),
                          );
                        },
                      ),
                    ),
                  ],
                ),



                
              ],
            ),
          )
        ],
      ),
    );
  }
}
