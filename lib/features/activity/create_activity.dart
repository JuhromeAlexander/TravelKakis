import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:travel_kakis/utils/user_information.dart' as user_info;

class CreateActivity extends StatefulWidget {
  final DocumentSnapshot documentSnapshot;

  CreateActivity({super.key, required this.documentSnapshot});

  @override
  _CreateActivityState createState() => _CreateActivityState();
}

class _CreateActivityState extends State<CreateActivity> {
  final _activityTitleController = TextEditingController();
  final _activityDateController = TextEditingController();
  final _activityDescriptionController = TextEditingController();
  final _activityCostController = TextEditingController();
  final _activityTimeController = TextEditingController();
  final _activityDurationController = TextEditingController();
  final _activityLocationController = TextEditingController();
  final _activityPhoneController = TextEditingController();
  final _activityWebsiteController = TextEditingController();

  //to write data
  void addData() async {
    CollectionReference activity =
        FirebaseFirestore.instance.collection('activity');

    await activity.add({
      'cost': _activityCostController.text,
      'date': _activityDateController.text,
      'description': _activityDescriptionController.text,
      'duration': _activityDurationController.text,
      'location': _activityLocationController.text,
      'phone': _activityPhoneController.text,
      'time': _activityTimeController.text,
      'title': _activityTitleController.text,
      'website': _activityWebsiteController.text,
    }).then((value) {
      widget.documentSnapshot.reference.update({
        'activities': FieldValue.arrayUnion([value]),
      });
    });

  }

//Calendar
  Future<void> _selectDate(context, controller) async {
    DateTime? datePicked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100));

    if (datePicked != null) {
      setState(() {
        controller.text = datePicked.toString().split(' ')[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Activity'),
      ),
      body: Stack(
        children: <Widget>[
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
                  //Title
                  Padding(
                      padding: EdgeInsets.only(top: 30.0),
                      child: TextField(
                        controller: _activityTitleController,
                        decoration: const InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey)),
                          hintText: 'Title',
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                      )),
                  Padding(
                      padding: EdgeInsets.only(top: 20.0),
                      child: TextField(
                        controller: _activityDateController,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.calendar_month),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey)),
                          labelText: 'Date',
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                        readOnly: true,
                        onTap: () {
                          _selectDate(context, _activityDateController);
                        },
                      )),
                  //Location
                  Padding(
                      padding: EdgeInsets.only(top: 20.0),
                      child: TextField(
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        style: TextStyle(height: 5),
                        controller: _activityDescriptionController,
                        decoration: const InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey)),
                          hintText: 'Description',
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                      )),
                  Padding(
                      padding: EdgeInsets.only(top: 20.0),
                      child: TextField(
                        controller: _activityCostController,
                        decoration: const InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey)),
                          hintText: 'Cost',
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                      )),
                  //Start date

                  Padding(
                      padding: EdgeInsets.only(top: 20.0),
                      child: TextField(
                        controller: _activityTimeController,
                        decoration: const InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey)),
                          hintText: 'Time',
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                      )),

                  Padding(
                      padding: EdgeInsets.only(top: 20.0),
                      child: TextField(
                        controller: _activityDurationController,
                        decoration: const InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey)),
                          hintText: 'Duration',
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                      )),
                  //End date
                  //collaborators
                  Padding(
                      padding: EdgeInsets.only(top: 20.0),
                      child: TextField(
                        controller: _activityLocationController,
                        decoration: const InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey)),
                          hintText: 'Location',
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                      )),
                  Padding(
                      padding: EdgeInsets.only(top: 20.0),
                      child: TextField(
                        controller: _activityPhoneController,
                        decoration: const InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey)),
                          hintText: 'Phone',
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                      )),
                  Padding(
                      padding: EdgeInsets.only(top: 20.0),
                      child: TextField(
                        controller: _activityWebsiteController,
                        decoration: const InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey)),
                          hintText: 'Website',
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                      )),

                  Container(
                    margin: const EdgeInsets.only(top: 20.0),
                    child: ElevatedButton(
                      onPressed: addData,
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(6), // <-- Radius
                          ),
                          minimumSize: const Size(double.infinity, 40)),
                      child: const Text('Create'),
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
