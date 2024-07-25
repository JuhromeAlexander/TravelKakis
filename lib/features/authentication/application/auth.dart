import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:travel_kakis/features/authentication/application/login.dart';
import 'package:travel_kakis/home_page.dart';
import 'package:travel_kakis/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travel_kakis/utils/user_information.dart' as user_info;

class Auth extends StatelessWidget {

  const Auth({super.key});

  void getData() async{

    final DocumentReference currUserDoc = await FirebaseFirestore.instance.collection('users')
      .doc(user_info.getID());

    currUserDoc.get().then(
        (DocumentSnapshot doc) {
          final data = doc.data() as Map<String, dynamic>;
          user_info.setUsername(data['name']);
          user_info.setDesc(data['desc']);
          user_info.setEmail(data['email']);
          user_info.setProfilePicture(data['profilePicture']);
          user_info.setJoinedDate(data['dateJoined']);
        },
      onError: (e) => print("Error getting document: $e"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //sticks the bot nav to the bottom of the phone when keyboard appears
        resizeToAvoidBottomInset: false,
        body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            //If the User Is Logged In
            if (snapshot.hasData) {
              getData();
              return const HomePage();
            } else {
              //If the User is not Logged In
              return const Login();
            }
          },
        ));
  }
}