//import 'dart:nativewrappers/_internal/vm/lib/ffi_allocation_patch.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CreateActivity extends StatefulWidget {
  //document snapshot of trip
  final DocumentSnapshot documentSnapshot;
  Function callback;

  CreateActivity({super.key, required this.documentSnapshot, required this.callback});

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
  void addData(BuildContext context) async {
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
      'tripID': widget.documentSnapshot.id.toString()
    }).then((value) {
      widget.documentSnapshot.reference.update({
        'activities': FieldValue.arrayUnion([value]),
      });
    });

    // widget.callback();

    Navigator.pop(context);
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
                        keyboardType: TextInputType.number,
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
                      onPressed: () => addData(context),
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
