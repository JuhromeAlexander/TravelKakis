import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:travel_kakis/utils/user_information.dart' as user_info;
import 'package:cloud_firestore/cloud_firestore.dart';


class ProfileSetting extends StatefulWidget {
  final Function callback;

  const ProfileSetting({super.key, required this.callback});

  @override
  _ProfileSettingState createState() => _ProfileSettingState();
}

class _ProfileSettingState extends State<ProfileSetting> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();

  void updateProfile() async {
    CollectionReference userRef =  await FirebaseFirestore.instance.collection('users');
    
    await userRef.doc(user_info.getID()).update({
      'name': nameController.text,
      'email': emailController.text
    });

    user_info.setEmail(emailController.text);
    user_info.setUsername(nameController.text);

    widget.callback();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Edit Profile'),
        ),
        body: Stack(children: <Widget>[
          Container(
            height: double.infinity,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(
                horizontal: 30.0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                   Padding(
                      padding: const EdgeInsets.only(top: 30.0),
                      child: TextField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey)),
                          hintText: 'Name',
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                      )),
                   Padding(
                      padding: const EdgeInsets.only(top: 30.0),
                      child: TextField(
                        controller: emailController,
                        decoration: const InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey)),
                          hintText: 'Email',
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                      )),
                  Container(
                    margin: const EdgeInsets.only(top: 20.0),
                    child: ElevatedButton(
                      onPressed: () {
                        updateProfile();
                      },
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(6), // <-- Radius
                          ),
                          minimumSize: const Size(double.infinity, 40)),
                      child: const Text('Save'),
                    ),
                  )
                ],
              ),
            ),
          )
        ]));
  }
}
