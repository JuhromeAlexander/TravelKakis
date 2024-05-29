import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  runApp(
    MaterialApp(home: Login()),
  );
  // runApp(const Login());
}

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: Stack(
        children: <Widget>[
          Container(
            // alignment: Alignment.topCenter,
            height: double.infinity, //why infinity
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(
                horizontal: 40.0,
                vertical: 120.0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Travel Kakis',
                      style: GoogleFonts.caveat(
                        textStyle: Theme.of(context).textTheme.displayLarge,
                        fontSize: 48,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      )),

                  const //email textfield
                  Padding(
                      padding: const EdgeInsets.only(
                          bottom: 0, left: 0, right: 0, top: 50.0),
                      child: TextField(
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)),
                            hintText: 'Email',
                            hintStyle: TextStyle(color: Colors.white),
                            prefixIcon: Icon(
                              Icons.email,
                              color: Colors.white,
                            )),
                      )),

                  //password textfield
                  const Padding(
                    padding: EdgeInsets.only(
                        bottom: 0, left: 0, right: 0, top: 20.0),
                    child: TextField(
                        obscureText: true,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)),
                            hintText: 'Password',
                            hintStyle: TextStyle(color: Colors.white),
                            prefixIcon: Icon(
                              Icons.lock,
                              color: Colors.white,
                            ))),
                  ),

                  //forgot password
                  const Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: null,
                        child: Text(
                          'Forgot Password',
                          style: TextStyle(color: Colors.white),
                        ),
                      )),

                  //Login
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6), // <-- Radius
                        ),
                        minimumSize: const Size(double.infinity, 40)),
                    child: const Text('Login'),
                  ),

                  //Registering a new account
                  const Align(
                      alignment: Alignment.center,
                      child: TextButton(
                        onPressed: null,
                        child: Text(
                          'No account? Register here',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      )),

                  //Divider
                  const Row(
                      children: <Widget>[
                        Expanded(
                            child: Divider(
                              color: Colors.white,
                            )
                        ),
                        Text(
                          "Or",
                          style: TextStyle(
                            color: Colors.white
                          ),
                        ),
                        Expanded(
                            child: Divider(
                              color: Colors.white,
                            )
                        ),
                      ]
                  ),

                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6), // <-- Radius
                        ),
                        minimumSize: const Size(double.infinity, 40)),
                    child: const Text('Login with Google'),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
