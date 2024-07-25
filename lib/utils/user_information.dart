library user_information;

import 'package:firebase_auth/firebase_auth.dart';

String _id = '';
String _username = '';
String _email = '';
String _description = '';
String _joinedDate = '';
String _profilePic = '';

String getUsername() {
  return _username;
}

String getID() {
  final FirebaseAuth auth = FirebaseAuth.instance;

  //it wont be null -> when user created, uid is auto created by firebase
  final User user = auth.currentUser!;
  final uid = user.uid;

  return uid;
}

String getEmail() {
  return _email;
}

String getDescription() {
  return _description;
}

String getJoinedDate() {
  return _joinedDate;
}

String getProfilePicture() {
  return _profilePic;
}

void setUsername(String username) {
  _username = username;
}

void setEmail(String email) {
  _email = email;
}

void setDesc(String desc) {
  _description = desc;
}

void setJoinedDate(String joinedDate) {
  _joinedDate = joinedDate;
}

void setProfilePicture(String profilePic) {
  _profilePic = profilePic;
}
