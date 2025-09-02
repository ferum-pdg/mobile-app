import 'dart:convert';

import 'package:ferum/models/user_model.dart';
import 'package:ferum/widgets/form_text_field.dart';
import 'package:ferum/widgets/gradientButton.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfilePage extends StatefulWidget {
  final User? user;

  const EditProfilePage({
    super.key,
    required this.user
  });

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

  @override
  void initState() {    
    super.initState();
    _user = widget.user;
    // initialize controllers with current user values.
    _firstNameController = TextEditingController(text: widget.user?.firstName ?? "");
    _lastNameController = TextEditingController(text: widget.user?.lastName ?? "");
    _weightController = TextEditingController(text: widget.user?.weight.toString() ?? "");
    _heightController = TextEditingController(text: widget.user?.height.toString() ?? "");
    _fcMaxController = TextEditingController(text: widget.user?.fcMax.toString() ?? "");

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

          FormTextField(controller: _firstNameController, label: _user!.firstName, color: Colors.black,),





        ],
      ),    
    );
  }
}
