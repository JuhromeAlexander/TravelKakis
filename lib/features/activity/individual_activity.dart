import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travel_kakis/features/activity/activity.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class IndividualActivity extends StatefulWidget {
  final DocumentSnapshot documentSnapshot;

  const IndividualActivity({
    super.key,
    required this.documentSnapshot
  });

  @override
  _IndividualActivityState createState() => _IndividualActivityState();
}

class _IndividualActivityState extends State<IndividualActivity> {
  // Reading the data from trip collection
  printInformation(Map<String, dynamic> data) {
    return Container(
      child: Column(children: <Widget>[
        Text(data['description']),
        const Divider(
          color: Colors.grey,
          height: 36,
        ),
        Text(data['location']),
        Text(data['phone']),
        Text(data['website']),
        Text(data['time']),
        Text(data['duration']),
        Text(data['cost']),
      ],),
    );
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.documentSnapshot.data() as Map<String, dynamic>;
    return Scaffold(
      appBar: AppBar(
        title: Text(data['title']),
      ),
      floatingActionButton: SpeedDial(
        spaceBetweenChildren: 10,
        spacing: 10,
        icon: Icons.add,
        children: [
          SpeedDialChild(
              child: Icon(Icons.train),
              label: 'Edit Transport',
              onTap: (){}
          ),
          SpeedDialChild(
              child: Icon(Icons.upload_file),
              label: 'Upload file',
              onTap: (){}
          ),
          SpeedDialChild(
              child: Icon(Icons.info_sharp),
              label: 'Edit Information',
              onTap: (){
              }
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          //top half
          Expanded(
              flex: 3,
              child: Container(
                color: Colors.black87,
              )),
          //bottom half
          Expanded(
              flex: 7,
              child:DefaultTabController(
                  length: 3,
                  child: Scaffold(
                    appBar: AppBar(
                      automaticallyImplyLeading: false,
                      title: const TabBar(
                        tabs: [
                          Tab(text:'Information',),
                          Tab(text:'Documents'),
                          Tab(text:'Transport'),
                        ],
                      ),
                    ),
                    body: TabBarView(
                        children: [
                          printInformation(data),
                          Center(child: Text('2')),
                          Center(child: Text('3')),
                        ]
                    ),
                  )
              )
          ),
        ],
      ),
    );
  }
}
