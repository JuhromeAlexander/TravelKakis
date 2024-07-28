import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:travel_kakis/features/profile_page/profile_setting.dart';
import 'package:travel_kakis/utils/user_information.dart' as user_info;
import 'package:image_picker/image_picker.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  _profileState createState() => _profileState();
}

class _profileState extends State<Profile> {
  String image = user_info.getProfilePicture();

  callback() {
    setState(() {});
  }

  //adding the profile picture document
  void updateProfilePicture(String profilePicture) async {
    CollectionReference userRef =
        await FirebaseFirestore.instance.collection('users');

    await userRef
        .doc(user_info.getID())
        .update({'profilePicture': profilePicture});

    //update the profilePicture from the user class
    user_info.setProfilePicture(profilePicture);
  }

  Future selectImage() async {
    //open gallary
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) return;

    updateProfilePicture(image.path);

    //update the image path
    setState(() {
      this.image = image.path;
    });
  }

  //the blue colour edit icon located at the bottom right of the image
  Widget editButton() {
    return const CircleAvatar(
      radius: 20,
      backgroundColor: Colors.blue,
      child: Icon(
        Icons.add_a_photo,
        color: Colors.white,
      ),
    );
  }

  Widget profilePicture(ImageProvider image) {
    return Stack(
      children: <Widget>[
        GestureDetector(
            onTap: selectImage,
            child: Stack(
              children: [
                Container(
                  height: 128,
                  width: 128,
                  child: CircleAvatar(
                    backgroundImage: image,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: editButton(),
                ),
              ],
            )),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
          //this is for the profile pic + info on the right
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Stack(
                children: <Widget>[
                  if (image != '')
                    profilePicture(FileImage(File(image)))
                  else
                    profilePicture(const NetworkImage(
                        'https://images.pexels.com/photos/771742/pexels-photo-771742.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2'))
                ],
              ),
              Container(
                margin: const EdgeInsets.only(left: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    //Username
                    Text(
                      user_info.getUsername(),
                      style: const TextStyle(
                        fontSize: 24,
                      ),
                    ),
                    //email
                    Text(
                      user_info.getEmail(),
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    //joined date
                    Text(
                      'Joined ${user_info.getJoinedDate()}',
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Expanded(
              child: ListView(
            children: <Widget>[
              ListTile(
                onTap: () {
                  _navigateToEditProfile(context, callback);
                },
                leading: const Icon(Icons.edit),
                title: const Text('Edit Profile'),
              ),
              const Divider(
                height: 0,
              ),
            ],
          ))
        ]));
  }
}

//navigate to edit Profile
void _navigateToEditProfile(context, Function callback) {
  Navigator.push(
    context,
    MaterialPageRoute(
        builder: (context) => ProfileSetting(
              callback: callback,
            )),
  );
}
