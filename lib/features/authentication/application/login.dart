import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:travel_kakis/features/authentication/application/Register.dart';
import 'package:travel_kakis/features/authentication/application/forgot_password.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    const MaterialApp(home: Login()),
  );
  // runApp(const Login());
}

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void signUserIn() async {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text
      );
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {

      Navigator.pop(context);
      if (e.code == 'invalid-credential') {
        incorrectCredMsg();
      }
    }
  }

  void incorrectCredMsg() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AlertDialog(
          title: Text('Incorrect Credentials'),
          content: Text(
              'The email or password entered is invalid. Please try again'),
        );
      },
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          SizedBox(
            // alignment: Alignment.topCenter,
            height: double.infinity,
            child: SingleChildScrollView(
              //enable scrolling in case phone size is small
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(
                horizontal: 40.0,
                vertical: 200.0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Travel Kakis',
                      style: GoogleFonts.caveat(
                        textStyle: Theme.of(context).textTheme.displayLarge,
                        fontSize: 48,
                        fontWeight: FontWeight.w700,
                        color: Colors.blue,
                      )),

                  // const //email textfield
                  Padding(
                      padding: const EdgeInsets.only(top: 50.0),
                      child: TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(color: Colors.blue)),
                            hintText: 'Email',
                            hintStyle: TextStyle(color: Colors.blue),
                            prefixIcon: Icon(
                              Icons.email,
                              color: Colors.blue,
                            )),
                      )),

                  //password textfield
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
                    child: TextField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(color: Colors.blue)),
                            hintText: 'Password',
                            hintStyle: TextStyle(color: Colors.blue),
                            prefixIcon: Icon(
                              Icons.lock,
                              color: Colors.blue,
                            ))),
                  ),

                  //forgot password
                  //  Align(
                  //     alignment: Alignment.centerRight,
                  //     child: TextButton(
                  //       onPressed: () {
                  //         _navigateToForgotPassword(context);
                  //       },
                  //       child: const Text(
                  //         'Forgot Password',
                  //         style: TextStyle(color: Colors.blue),
                  //       ),
                  //     )),

                  //Login
                  ElevatedButton(
                    onPressed: signUserIn,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6), // <-- Radius
                        ),
                        minimumSize: const Size(double.infinity, 40)),
                    child: const Text(
                        style: TextStyle(color: Colors.white), 'Login'),
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
                              color: Colors.blue, fontWeight: FontWeight.bold),
                        ),
                      )),

                  //Divider
                  // Row(children: <Widget>[
                  //   Expanded(
                  //     child: Container(
                  //         margin: const EdgeInsets.only(right: 10.0),
                  //         child: const Divider(
                  //           color: Colors.blue,
                  //           height: 36,
                  //         )),
                  //   ),
                  //   const Text(
                  //     "Or",
                  //     style: TextStyle(color: Colors.blue),
                  //   ),
                  //   Expanded(
                  //     child: Container(
                  //         margin: const EdgeInsets.only(left: 10.0),
                  //         child: const Divider(
                  //           color: Colors.blue,
                  //           height: 36,
                  //         )),
                  //   ),
                  // ]),

                  //Login with google
                  // Container(
                  //   margin: const EdgeInsets.only(top: 10.0),
                  //   child: ElevatedButton(
                  //     onPressed: () {},
                  //     style: ElevatedButton.styleFrom(
                  //         shape: RoundedRectangleBorder(
                  //           borderRadius: BorderRadius.circular(6),
                  //         ),
                  //         minimumSize: const Size(double.infinity, 40)),
                  //     child: const Text('Login with Google'),
                  //   ),
                  // )
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

//navigate to forgot password page
void _navigateToForgotPassword(context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const Forgetpassword()),
  );
}
