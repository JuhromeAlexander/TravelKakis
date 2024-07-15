import 'package:flutter/material.dart';
import 'package:travel_kakis/features/profile_page/profile_setting.dart';
import 'package:travel_kakis/utils/user_information.dart' as user_info;

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  _profileState createState() => _profileState();
}

class _profileState extends State<Profile> {

  callback() {
    setState(() {

    });
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
              ClipOval(
                child: SizedBox.fromSize(
                  size: const Size.fromRadius(60),
                  child: Image.network(
                    'https://images.pexels.com/photos/771742/pexels-photo-771742.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
                    fit: BoxFit.cover,
                  ),
                ),
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
                    // ElevatedButton(
                    //     onPressed:
                    //         () {setState(() {
                    //
                    //     }); },
                    //     child: Text('Refresh')
                    // )
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
              ListTile(
                onTap: () {},
                leading: const Icon(Icons.person),
                title: const Text('Friends'),
              ),
              const Divider(
                height: 0,
              ),
              ListTile(
                onTap: () {},
                leading: const Icon(Icons.favorite),
                title: const Text('Favourites'),
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
    MaterialPageRoute(builder: (context) => ProfileSetting(callback: callback,)),
  );
}
