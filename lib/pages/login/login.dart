import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

void main() async {
  runApp(MaterialApp(home: Login()),
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
      body: Stack(children: <Widget>[
        Container(
          // alignment: Alignment.topCenter,
          height: double.infinity, //why infinity
          child: const SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(
                horizontal: 40.0,
                vertical: 120.0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Travel Kakis',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'OpenSans',
                      fontSize: 40.0,
                      fontWeight:  FontWeight.bold,
                    ),
                  ),

                  //email textfield
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)
                          ),
                          hintText: 'email',
                          prefixIcon: Icon(Icons.email, color: Colors.white,)
                      ),
                    )),

                  //password textfield
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        obscureText: true,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)
                            ),

                            hintText: 'Password',
                            prefixIcon: Icon(Icons.lock, color: Colors.white,)
                        ),
                      ),),

                  //forgot password
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      onPressed: null,
                      child: Text('Forgot Password'),
                    )
                  ),

                  //Login
                  SizedBox(
                      width: 1000.0,
                      height: 50.0,
                      child: OutlinedButton(
                        style: ButtonStyle(),
                          onPressed: null,
                          child: Text('Login'))
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