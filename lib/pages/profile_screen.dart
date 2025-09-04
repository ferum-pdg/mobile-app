import 'package:ferum/models/user_model.dart';
import 'package:ferum/pages/edit_profile_screen.dart';
import 'package:ferum/pages/welcome_screen.dart';
import 'package:ferum/services/auth_service.dart';
import 'package:ferum/widgets/gradientButton.dart';
import 'package:flutter/material.dart';

// Profile screen: shows user's basic info and offers edit & logout actions
class ProfilePage extends StatefulWidget {
  final User? user;
  const ProfilePage({super.key, required this.user});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User? _user;

  @override
  void initState() {
    super.initState();
    // Cache the user passed from navigation; beware: code uses `_user!` later
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
              // Rounded bottom corners to visually separate the header from content
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                // Placeholder profile avatar (uses a local asset)
                const CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage("assets/img/profile.png"),
                ),
                const SizedBox(height: 10),
                // Display name and email pulled from `_user`
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
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Details list: read-only cards for key profile fields
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
                    leading: const Icon(
                      Icons.fitness_center,
                      color: Colors.purple,
                    ),
                    title: const Text("Poids"),
                    // Units: kilograms
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
                    // Units: centimeters
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
                    // Units: beats per minute (bpm)
                    subtitle: Text("${_user!.fcMax}"),
                  ),
                ),

                const SizedBox(height: 20),

                // Actions: edit profile or log out
                Row(
                  children: [
                    Expanded(
                      child: GradientButton(
                        text: "Modifier",
                        height: 60,
                        onTap: () {
                          // Go to profile edit screen and replace current page
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (e) => EditProfilePage(user: _user),
                            ),
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
                          // Clear session (e.g., JWT in storage) and redirect to Welcome
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
          ),
        ],
      ),
    );
  }
}
