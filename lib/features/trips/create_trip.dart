import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:travel_kakis/utils/user_information.dart' as user_info;
import 'package:travel_kakis/features/trips/overview_of_trips.dart' as overview_trips;

class CreateTrip extends StatefulWidget {
  //final Function callback;
  CreateTrip({
    super.key,
    //required this.callback
  });

  @override
  _CreateTripState createState() => _CreateTripState();
}

class _CreateTripState extends State<CreateTrip> {
  final _tripTitleController = TextEditingController();
  final _tripLocationController = TextEditingController();
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();
  final _collaborationsController = TextEditingController();

  //to write data
  void addData() async {
    CollectionReference trips = FirebaseFirestore.instance.collection('trips');
    CollectionReference user = FirebaseFirestore.instance.collection('users');

    //TODO: update this part to also create an array

    //adding the trip to the database
    await trips.add({
      'tripCollaborators': _collaborationsController.text,
      'tripEndDate': _endDateController.text,
      'tripLocation': _tripLocationController.text,
      'tripStartDate': _startDateController.text,
      'tripTitle': _tripTitleController.text,
      'activities': <DocumentReference>[]
    }).then((value) {
      //adding this trip ID to the user ID as well
      user.doc(user_info.getID()).update({
        // 'trips': FieldValue.arrayUnion(['trips/${value.id}']),
        'trips': FieldValue.arrayUnion([value]),
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
        title: const Text('Create Trip'),
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
                        controller: _tripTitleController,
                        decoration: const InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey)),
                          hintText: 'Title',
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                      )),
                  //Location
                  Padding(
                      padding: EdgeInsets.only(top: 20.0),
                      child: TextField(
                        controller: _tripLocationController,
                        decoration: const InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey)),
                          hintText: 'Location',
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                      )),
                  //Start date
                  Padding(
                      padding: EdgeInsets.only(top: 20.0),
                      child: TextField(
                        controller: _startDateController,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.calendar_month),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey)),
                          labelText: 'Start date',
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                        readOnly: true,
                        onTap: () {
                          _selectDate(context, _startDateController);
                        },
                      )),
                  //End date
                  Padding(
                      padding: EdgeInsets.only(top: 20.0),
                      child: TextField(
                        controller: _endDateController,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.calendar_month),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey)),
                          hintText: 'Select End Date',
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                        readOnly: true,
                        onTap: () {
                          _selectDate(context, _endDateController);
                        },
                      )),
                  //collaborators
                  Padding(
                      padding: EdgeInsets.only(top: 20.0),
                      child: TextField(
                        controller: _collaborationsController,
                        decoration: const InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey)),
                          hintText: 'Collaborators',
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
