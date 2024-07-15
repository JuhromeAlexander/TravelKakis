import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:travel_kakis/features/activity/upload_file.dart';

class IndividualActivity extends StatefulWidget {
  final DocumentSnapshot documentSnapshot;

  const IndividualActivity({super.key, required this.documentSnapshot});

  @override
  _IndividualActivityState createState() => _IndividualActivityState();
}

class _IndividualActivityState extends State<IndividualActivity> {
  // Reading the data from trip collection
  printInformation(Map<String, dynamic> data) {
    return ListView(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Text(
                "Description",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Text(
                data['cost'],
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 20.0),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Text(data['description']),
        ),
        const Divider(
          color: Colors.grey,
          height: 10,
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Text(
            "Location",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Text(data['location']),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Text(
            "Phone",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Text(data['phone']),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Text(
            "Website",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Text(data['website']),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Text(
            "Time",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Text(data['time']),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Text(
            "Duration (Hrs)",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Text(data['duration']),
        ),
      ],
    );

    // return Container(
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.documentSnapshot.data() as Map<String, dynamic>;
    return Scaffold(
      appBar: AppBar(
        title: Text(data['title']),
      ),
      floatingActionButton: SpeedDial(
        backgroundColor: Colors.blue,
        spaceBetweenChildren: 10,
        spacing: 10,
        icon: Icons.add,
        children: [
          SpeedDialChild(
              child: const Icon(Icons.train), label: 'Edit Transport', onTap: () {}),
          SpeedDialChild(
              child: const Icon(Icons.upload_file),
              label: 'Upload file',
              onTap: () {}),
          SpeedDialChild(
              child: const Icon(Icons.info_sharp),
              label: 'Edit Information',
              onTap: () {}),
        ],
      ),
      body: Column(
        children: <Widget>[
          //top half
          // Expanded(
          // flex: 3,
          // child: Container(
          //   color: Colors.black87,
          // )),
          //bottom half
          Expanded(
              flex: 7,
              child: DefaultTabController(
                  length: 3,
                  child: Scaffold(
                    appBar: AppBar(
                      automaticallyImplyLeading: false,
                      title: const TabBar(
                        tabs: [
                          Tab(
                            text: 'Information',
                          ),
                          Tab(text: 'Documents'),
                          Tab(text: 'Transport'),
                        ],
                      ),
                    ),
                    body: TabBarView(children: [
                      printInformation(data),
                      const UploadFile(),
                      const Center(child: Text('3')),
                    ]),
                  ))),
        ],
      ),
    );
  }
}
