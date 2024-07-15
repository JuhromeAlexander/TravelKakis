import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


void main() async {
  runApp(
    const MaterialApp(home: Forgetpassword()),
  );
  // runApp(const Login());
}

class Forgetpassword extends StatefulWidget {
  const Forgetpassword({super.key});

  @override
  _ForgetpasswordState createState() => _ForgetpasswordState();
}


class _ForgetpasswordState extends State<Forgetpassword> {
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
                    child: Text('Forgot Password',
                        style: GoogleFonts.roboto(
                          textStyle: Theme.of(context).textTheme.displayLarge,
                          fontSize: 38,
                          color: Colors.white,
                        )),
                  ),

                  //Email textbox
                  const Padding(
                      padding: EdgeInsets.only(top: 30.0),
                      child: TextField(
                        keyboardType: TextInputType.emailAddress,
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

                  //Register
                  Container(
                    margin: const EdgeInsets.only(top: 20.0),
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(6), // <-- Radius
                          ),
                          minimumSize: const Size(double.infinity, 40)),
                      child: const Text('Send'),
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
