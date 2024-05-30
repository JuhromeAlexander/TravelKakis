import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:travel_kakis/features/authentication/application/login.dart';
import 'package:travel_kakis/home_page.dart';
import 'package:travel_kakis/main.dart';

class Auth extends StatelessWidget {
  const Auth({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          //If the User Is Logged In
          if (snapshot.hasData) {
            return HomePage();
          } else {
            //If the User is not Logged In
            return Login();
          }
        },
      )
    );
  }
}