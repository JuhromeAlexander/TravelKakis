// import 'dart:js_interop';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    const MaterialApp(home: Register()),
  );
  // runApp(const Login());
}

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final emailController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  void registerUser() async {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text
      );

      createUser();
      Navigator.pop(context);
      Navigator.pop(context);
    }on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      if (e.code == 'weak-password') {
        weakPassword();
      } else if (e.code == 'email-already-in-use') {
        emailInUse();
      }
    }catch (e) {
      print(e);
    }
  }

  void weakPassword() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AlertDialog(
          title: Text('Weak Password'),
          content: Text(
              'Your password is too weak, please choose a stronger password'),
        );
      },
    );
  }

  void emailInUse() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AlertDialog(
          title: Text('Email in use'),
          content: Text(
              'The email address is already in use'),
        );
      },
    );
  }

  //create user databse
  void createUser() async{
    final String currYear = DateTime.now().year.toString();
    final FirebaseAuth auth = FirebaseAuth.instance;

    //it wont be null -> when user created, uid is auto created by firebase
    final User user = auth.currentUser!;
    final uid = user.uid;

    CollectionReference users = FirebaseFirestore.instance.collection('users');

    //create user database
    await users.doc(uid).set({
      'dateJoined': currYear,
      'email': emailController.text,
      'name': usernameController.text,
      'desc': '',
      'trips': [],
      'profilePicture': ''
    });

    //set the user UID so that in auth, it knows what to update
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      //app bar
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: Colors.blue.withOpacity(0),
      ),

      body: Stack(
        children: <Widget>[
          SizedBox(
            height: double.infinity,
            child: SingleChildScrollView(
              //enable scrolling in case phone size is small
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(
                horizontal: 40.0,
                // vertical: 40.0,
              ),
                child: Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Register',
                        style: GoogleFonts.roboto(
                          textStyle: Theme.of(context).textTheme.displayLarge,
                          fontSize: 38,
                          color: Colors.white,
                        )),
                  ),

                  //Email textbox
                  Padding(
                      padding: const EdgeInsets.only(top: 30.0),
                      child: TextField(
                        //Not Sure Why this is giving me Errors, but i think may need your help to check
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)),
                            hintText: 'Email',
                            hintStyle: TextStyle(color: Colors.white),
                            prefixIcon: Icon(
                              Icons.email,
                              color: Colors.white,
                            )),
                      )),

                  //Username
                  Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: TextField(
                          controller: usernameController,
                          decoration: const InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                            hintText: 'User',
                            hintStyle: TextStyle(color: Colors.white),
                            prefixIcon: Icon(
                              Icons.account_circle,
                              color: Colors.white,
                            )),
                      )),

                  //password
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: TextField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)),
                            hintText: 'Password',
                            hintStyle: TextStyle(color: Colors.white),
                            prefixIcon: Icon(
                              Icons.lock,
                              color: Colors.white,
                            ))),
                  ),

                  //Register
                  Container(
                    margin: const EdgeInsets.only(top: 20.0),
                    child: ElevatedButton(
                      onPressed: () {
                        registerUser();
                      },
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(6), // <-- Radius
                            ),
                            minimumSize: const Size(double.infinity, 40)),
                        child: const Text('Register'),
                      ),
                    )
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
