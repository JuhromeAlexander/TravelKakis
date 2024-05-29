import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:travel_kakis/pages/login/Register.dart';

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
            height: double.infinity,
            child: SingleChildScrollView(
              //enable scrolling in case phone size is small
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

                  // const //email textfield
                  const Padding(
                      padding: EdgeInsets.only(top: 50.0),
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
                    padding: EdgeInsets.only(top: 20.0),
                    child: TextField(
                        obscureText: true,
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
                  Align(
                      alignment: Alignment.center,
                      child: TextButton(
                        onPressed: () {
                          _navigateToRegister(context);
                        },
                        child: const Text(
                          'No account? Register here',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      )),

                  //Divider
                  Row(children: <Widget>[
                    Expanded(
                      child: Container(
                          margin: const EdgeInsets.only(right: 10.0),
                          child: const Divider(
                            color: Colors.white,
                            height: 36,
                          )),
                    ),
                    const Text(
                      "Or",
                      style: TextStyle(color: Colors.white),
                    ),
                    Expanded(
                      child: Container(
                          margin: const EdgeInsets.only(left: 10.0),
                          child: const Divider(
                            color: Colors.white,
                            height: 36,
                          )),
                    ),
                  ]),

                  //Login with google
                  Container(
                    margin: const EdgeInsets.only(top: 10.0),
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          minimumSize: const Size(double.infinity, 40)),
                      child: const Text('Login with Google'),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

//navigate to register page
void _navigateToRegister(context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const Register()),
  );
}
