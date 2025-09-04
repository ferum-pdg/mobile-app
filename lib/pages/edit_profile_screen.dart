import 'dart:convert';

import 'package:ferum/models/user_model.dart';
import 'package:ferum/services/user_service.dart';
import 'package:ferum/widgets/bottomNav.dart';
import 'package:ferum/widgets/form_text_field.dart';
import 'package:ferum/widgets/gradientButton.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Edit profile screen: allows the user to update basic fields (name, weight, height, HR max)
class EditProfilePage extends StatefulWidget {
  final User? user;

  const EditProfilePage({super.key, required this.user});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  User? _user;
  late TextEditingController _firstNameController = TextEditingController();
  late TextEditingController _lastNameController = TextEditingController();
  late TextEditingController _weightController = TextEditingController();
  late TextEditingController _heightController = TextEditingController();
  late TextEditingController _fcMaxController = TextEditingController();
  final _formEditProfileKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Cache the user passed via navigation for display (name/email in header)
    _user = widget.user;
    // Pre-fill the form controllers with the current profile values
    // initialize controllers with current user values.
    _firstNameController = TextEditingController(
      text: widget.user?.firstName ?? "",
    );
    _lastNameController = TextEditingController(
      text: widget.user?.lastName ?? "",
    );
    _weightController = TextEditingController(
      text: widget.user?.weight.toString() ?? "",
    );
    _heightController = TextEditingController(
      text: widget.user?.height.toString() ?? "",
    );
    _fcMaxController = TextEditingController(
      text: widget.user?.fcMax.toString() ?? "",
    );
  }

  // Validate and persist profile changes, then return to the main app
  Future<void> _saveProfile() async {
    if (_formEditProfileKey.currentState!.validate()) {
      // Build a new User object from the form fields (parse numbers safely)
      User updatedUser = User(
        id: widget.user!.id,
        email: widget.user!.email,
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        phoneNumber: widget.user!.phoneNumber,
        birthDate: widget.user!.birthDate,
        weight: double.tryParse(_weightController.text) ?? 0.0,
        height: double.tryParse(_heightController.text) ?? 0.0,
        fcMax: int.tryParse(_fcMaxController.text) ?? 0,
      );

      // Persist a copy in SharedPreferences for quick local reads
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("user", jsonEncode(updatedUser.toJson()));

      // Update the backend/session user as the source of truth
      await UserService().setUser(updatedUser);

      if (mounted) {
        // Replace current screen with the app shell using the updated user
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => BottomNav(user: updatedUser)),
        );
      }
    }
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // HEADER avec dégradé
            Container(
              width: double.infinity,
              height: 280,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0D47A1), Colors.purple],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                // Rounded bottom corners to visually separate the header
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Placeholder avatar (local asset)
                  const CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage("assets/img/profile.png"),
                  ),
                  const SizedBox(height: 10),
                  // Display name and email from `_user`
                  Text(
                    _user?.firstName ?? '',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    _user?.email ?? '',
                    style: const TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                decoration: BoxDecoration(
                  // Gradient background for the form card
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0D47A1), Colors.purple],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  // Subtle elevation to lift the card from the background
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  // Form uses `_formEditProfileKey` for validation before saving
                  child: Form(
                    key: _formEditProfileKey,
                    child: Column(
                      children: [
                        FormTextField(
                          controller: _firstNameController,
                          label: "Prénom",
                          color: Colors.white,
                          fillColor: Colors.white12,
                        ),
                        const SizedBox(height: 12),
                        FormTextField(
                          controller: _lastNameController,
                          label: "Nom",
                          color: Colors.white,
                          fillColor: Colors.white12,
                        ),
                        const SizedBox(height: 12),
                        // Weight in kilograms (parsed as double)
                        FormTextField(
                          controller: _weightController,
                          label: "Poids (kg)",
                          keyboardType: TextInputType.number,
                          color: Colors.white,
                          fillColor: Colors.white12,
                        ),
                        const SizedBox(height: 12),
                        // Height in centimeters (parsed as double)
                        FormTextField(
                          controller: _heightController,
                          label: "Taille (cm)",
                          keyboardType: TextInputType.number,
                          color: Colors.white,
                          fillColor: Colors.white12,
                        ),
                        const SizedBox(height: 12),
                        // Max heart rate in bpm (parsed as integer)
                        FormTextField(
                          controller: _fcMaxController,
                          label: "Fréquence cardiaque max",
                          keyboardType: TextInputType.number,
                          color: Colors.white,
                          fillColor: Colors.white12,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),
            // Save button: runs validation then calls `_saveProfile`
            GradientButton(
              text: "Enregistrer",
              height: 60,
              onTap: _saveProfile,
              width: 350,
            ),
          ],
        ),
      ),
    );
  }
}
