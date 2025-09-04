import 'package:ferum/pages/signin_screen.dart';
import 'package:ferum/services/auth_service.dart';
import 'package:ferum/services/user_service.dart';
import 'package:ferum/widgets/bottomNav.dart';
import 'package:ferum/widgets/form_text_field.dart';
import 'package:flutter/material.dart';


class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formSignUpKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  final _fcMaxController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                child: Center(
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/img/f.png',
                        width: 300,
                        height: 60,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 7,
              child: Container(
                padding: const EdgeInsets.fromLTRB(25.0, 50.0, 25.0, 20.0),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF0D47A1), Colors.purple],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40.0),
                    topRight: Radius.circular(40.0),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formSignUpKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 20),
                        Text(
                          "Rejoins nous !",
                          style: TextStyle(
                            fontSize: 30.0,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 30),
                        FormTextField(
                          controller: _emailController, 
                          label: "Email",
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 15),
                        FormTextField(
                          controller: _passwordController, 
                          label: "Mot de passe",
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: true,
                        ),
                        const SizedBox(height: 15),
                        FormTextField(
                          controller: _firstNameController, 
                          label: "Prénom",
                          keyboardType: TextInputType.name,
                        ),
                        const SizedBox(height: 15),
                        FormTextField(
                          controller: _lastNameController, 
                          label: "Nom",
                          keyboardType: TextInputType.name,
                        ),
                        const SizedBox(height: 15),
                        FormTextField(
                          controller: _phoneController, 
                          label: "Numéro de téléphone",
                          keyboardType: TextInputType.phone,
                        ),
                        const SizedBox(height: 15),                                          
                        FormTextField(
                          controller: _birthDateController, 
                          label: "Date de naissance",                           
                          isDateField: true,
                        ),
                        const SizedBox(height: 15), 
                        FormTextField(
                          controller: _weightController, 
                          label: "Poids (kg)", 
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: 15),                         
                        FormTextField(
                          controller: _heightController, 
                          label: "Taille (cm)", 
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: 15),                         
                        FormTextField(
                          controller: _fcMaxController, 
                          label: "Fréquence cardiaque max", 
                          keyboardType: TextInputType.number,
                        ),                        
                        const SizedBox(width: 50),                        
                        const SizedBox(height: 15),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async {
                              if (_formSignUpKey.currentState!.validate()) {
                                try {
                                  bool success = await AuthService().register(
                                    _emailController.text,
                                    _passwordController.text,
                                    _firstNameController.text,
                                    _lastNameController.text,
                                    _phoneController.text,
                                    _birthDateController.text,
                                    double.parse(_weightController.text),
                                    double.parse(_heightController.text),
                                    int.parse(_fcMaxController.text),
                                  );

                                  if (success) {
                                    // Fetch user after registration.
                                    final loggedInUser = await UserService().getUser();
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(builder: (_) => BottomNav(user: loggedInUser)),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text("Sign up failed.")),
                                    );
                                  }
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text("Sign up failed: $e")),
                                  );
                                }
                              }
                            },
                            child: const Text('Sign up'),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Vous avez déjà un compte ?',
                              style: TextStyle(
                                  color: Colors.white,
                              ),                              
                            ),
                            const SizedBox(width: 4),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context, 
                                  MaterialPageRoute(
                                    builder: (e) => const SignInScreen()
                                  )
                                );
                              },
                              child: Text(
                                'Sign in!',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),                                              
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}