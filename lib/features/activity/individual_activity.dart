import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:provider/provider.dart';
import 'package:travel_kakis/features/activity/upload_file.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:travel_kakis/features/activity/edit_information.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:travel_kakis/utils/user_information.dart' as user_info;


class IndividualActivity extends StatefulWidget {
  final DocumentSnapshot activityDocumentSnapshot;
  final DocumentSnapshot tripDocumentSnapshot;
  final Function tripCallback;

  const IndividualActivity({
    super.key,
    required this.activityDocumentSnapshot,
    required this.tripDocumentSnapshot,
    required this.tripCallback,
  });

  @override
  _IndividualActivityState createState() => _IndividualActivityState();
}

class _IndividualActivityState extends State<IndividualActivity> {

  //refresh data
  void callBack() {
    widget.tripCallback();
    setState(() {});
  }

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
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
          child: InkWell(
            onTap: () => _launchUrl(Uri.parse(data['website'])),
            child: Text(
              data['website'],
              // (data['website']),
              style: const TextStyle(
                  decoration: TextDecoration.underline,
                  decorationColor: Colors.indigo,
                  color: Colors.indigo),
            ),
          ),

          // Text(data['website']),
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

  //for opening URL
  Future<void> _launchUrl(Uri url) async {
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  //for uploading of files
  Future selectFile() async {
    //TODO: limit the size of the file uploaded
    //select the file from the phone. only restrict to pdf, jpg and png files
    final pickedFile = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'png', 'jpeg'],

    );

    //TODO: the file folder must be unique so as to not overlap with other trips/activity/
    //TODO: maybe for every trip & activity created, it can be assigned a unique ID
    if (pickedFile != null) {
      final path =
          '${user_info.getID()}/${widget.tripDocumentSnapshot.id}/${widget.activityDocumentSnapshot.id}/${pickedFile.files.first.name}';
      final file = File(pickedFile.files.first.path!);

      final ref = FirebaseStorage.instance.ref().child(path);

      ref.putFile(file);

    }


    return;
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.activityDocumentSnapshot.data() as Map<String, dynamic>;
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
                child: Icon(Icons.train), label: 'Edit Transport', onTap: () {}),
            SpeedDialChild(
                child: Icon(Icons.upload_file),
                label: 'Upload file',
                onTap: () => selectFile()),
            SpeedDialChild(
                child: Icon(Icons.info_sharp),
                label: 'Edit Information',
                onTap: () => _navigateToEditInformation(
                    context, widget.activityDocumentSnapshot, callBack)),
          ],
        ),
        body: Column(
          children: <Widget>[
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
                        UploadFile(
                          activityDocumentSnapshot:
                              widget.activityDocumentSnapshot,
                          tripDocumentSnapshot: widget.tripDocumentSnapshot,
                        ),
                        Center(child: Text('3')),
                      ]),
                    ))),
          ],
        ),

    );
  }
}

//TODO: to navigate to edit information
void _navigateToEditInformation(context, documentSnapshot, callBack) {
  Navigator.push(
    context,
    MaterialPageRoute(
        builder: (context) => EditInformation(
              documentSnapshot: documentSnapshot,
              // startDate: startDate,
              callback: callBack,
            )),
  );
}
