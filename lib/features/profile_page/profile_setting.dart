import 'package:flutter/material.dart';
import 'package:travel_kakis/features/profile_page/profile.dart';
import 'package:travel_kakis/utils/user_information.dart' as user_info;
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileSetting extends StatefulWidget {
  final Function callback;

  const ProfileSetting({super.key, required this.callback});

  @override
  _ProfileSettingState createState() => _ProfileSettingState();
}

class _ProfileSettingState extends State<ProfileSetting> {
  final nameController = TextEditingController(text: user_info.getUsername());
  final emailController = TextEditingController();

  void updateProfile(context) async {
    CollectionReference userRef =
        FirebaseFirestore.instance.collection('users');

    await userRef.doc(user_info.getID()).update({
      'name': nameController.text,
    });
    // .update({'name': nameController.text, 'email': emailController.text});

    // user_info.setEmail(emailController.text);
    user_info.setUsername(nameController.text);

    widget.callback();

    //go back to profile page
    _profileUpdated(context);
  }

  //a toast to tell user that the profile information has been updated
  void _profileUpdated(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      const SnackBar(
        content: Text("Profile updated!"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Edit Profile'),
        ),
        body: Stack(children: <Widget>[
          SizedBox(
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
                    child: TextFormField(
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      )),
                      controller: nameController,
                    ),
                  ),
                  //this is for email
                  // Padding(
                  //     padding: const EdgeInsets.only(top: 30.0),
                  //     child: TextField(
                  //       controller: emailController,
                  //       decoration: const InputDecoration(
                  //         enabledBorder: OutlineInputBorder(
                  //             borderSide: BorderSide(color: Colors.grey)),
                  //         hintText: 'Email',
                  //         hintStyle: TextStyle(color: Colors.grey),
                  //       ),
                  //     )),
                  Container(
                    margin: const EdgeInsets.only(top: 20.0),
                    child: ElevatedButton(
                      onPressed: () {
                        updateProfile(context);
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

//navigate back to the profile page
void _navigateToProfilePage(context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const Profile()),
  );
}
