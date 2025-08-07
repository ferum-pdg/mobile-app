import 'package:flutter/material.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formSignInKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
        backgroundColor: Colors.white
      ),
      body: SafeArea(
        child: Column(
          children: [
            const Expanded(
              flex: 1,
              child: SizedBox(
                height: 10,
              )
            ),
            Expanded(
              flex: 7,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.purple,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40.0),
                    topRight: Radius.circular(40.0)
                  )
                ),
                child: Form(
                  key: _formSignInKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(                        
                        "Te revoilà !",
                        style: TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.w900,
                          color: Colors.white
                        ),
                      ),
                      const SizedBox(height: 30),
                      TextFormField(
                        style: const TextStyle(color: Colors.white),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer un email';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          label: const Text('Email'),
                          labelStyle: const TextStyle(
                            color: Colors.white
                          ),
                          filled: true,
                          fillColor: Colors.white12,                          
                          hintText: 'Entrer un email',
                          hintStyle: const TextStyle(
                            color: Colors.white70
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white, width: 2),
                            borderRadius: BorderRadius.circular(10),
                          )
                        ),                      
                      ),
                      const SizedBox(height: 15),
                      TextFormField(
                        style: const TextStyle(color: Colors.white),
                        obscureText: true,
                        obscuringCharacter: '*',
                        validator: (value) {
                          if(value == null || value.isEmpty) {
                            return 'Veuillez entrer un mot de passe.';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          label: const Text('Password'),
                          labelStyle: const TextStyle(
                            color: Colors.white
                          ),
                          hintText: 'Entrer un mot de passe',
                          hintStyle: const TextStyle(
                            color: Colors.white
                          ),
                          filled: true,
                          fillColor: Colors.white12,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white, width: 2),
                            borderRadius: BorderRadius.circular(10),
                          ),                       
                        ),
                      ),
                      const SizedBox(width: 50),
                    ],
                  )
                ),
              )
            )
          ],
      )
      
      ),
    );
  }
}