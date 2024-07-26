//import 'dart:nativewrappers/_internal/vm/lib/ffi_allocation_patch.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CreateActivity extends StatefulWidget {
  //document snapshot of trip
  final DocumentSnapshot documentSnapshot;

  //the date of the current selected
  final DateTime startDate;
  Function callback;

  CreateActivity(
      {super.key,
      required this.documentSnapshot,
      required this.startDate,
      required this.callback});

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
      'tripID': widget.documentSnapshot.id.toString(),
      'source': '',
      'destination': '',

    }).then((value) {
      widget.documentSnapshot.reference.update({
        'activities': FieldValue.arrayUnion([value]),
      });
    });

    widget.callback();

    Navigator.pop(context);
  }

//Calendar
  Future<void> _selectDate(context, controller) async {
    DateTime? datePicked = await showDatePicker(
        context: context,
        initialDate: widget.startDate,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100));

    if (datePicked != null) {
      setState(() {
        controller.text = datePicked.toString().split(' ')[0];
      });
    }
  }

  //picking the time
  Future<void> _selectTime(context, controller) async {
    final TimeOfDay? selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        builder: (BuildContext context, Widget? child) {
          return MediaQuery(
              data:
                  MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
              child: child!);
        });

    if (selectedTime != null)
      setState(() {
        controller.text = selectedTime?.format(context);
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Activity'),
      ),
      body: Stack(
        children: <Widget>[
          SizedBox(
            height: double.infinity,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(
                horizontal: 30.0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  //Title
                  Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: TextField(
                        controller: _activityTitleController,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(color: Colors.grey)),
                          hintText: 'Title',
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                      )),
                  Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: TextField(
                        controller: _activityDateController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.calendar_month),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(color: Colors.grey)),
                          labelText: 'Date',
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                        readOnly: true,
                        onTap: () {
                          _selectDate(context, _activityDateController);
                        },
                      )),
                  // date
                  Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: TextField(
                        readOnly: true,
                        onTap: () =>
                            _selectTime(context, _activityTimeController),
                        controller: _activityTimeController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.alarm),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(color: Colors.grey)),
                          labelText: 'Time',
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                      )),
                  //Description
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: SizedBox(
                      height: 150, //     <-- TextField expands to this height.
                      child: TextField(
                        controller: _activityDescriptionController,
                        maxLines: null,
                        // Set this
                        expands: true,
                        // and this
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(color: Colors.grey)),
                          hintText: 'Description',
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                  ),

                  Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: TextField(
                        keyboardType: TextInputType.number,
                        controller: _activityCostController,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(color: Colors.grey)),
                          hintText: 'Cost',
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                      )),

                  Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: TextField(
                        keyboardType: TextInputType.number,
                        controller: _activityDurationController,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(color: Colors.grey)),
                          hintText: 'Duration',
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                      )),
                  //collaborators
                  Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: TextField(
                        controller: _activityLocationController,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(color: Colors.grey)),
                          hintText: 'Location',
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                      )),

                  Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: TextField(
                        controller: _activityPhoneController,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(color: Colors.grey)),
                          hintText: 'Phone',
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                      )),

                  Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: TextField(
                        controller: _activityWebsiteController,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(color: Colors.grey)),
                          hintText: 'Website',
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                      )),

                  Container(
                    margin: const EdgeInsets.only(top: 20.0, bottom: 20.0),
                    child: ElevatedButton(
                      onPressed: () => addData(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6), // <-- Radius
                        ),
                        minimumSize: const Size(double.infinity, 40),
                      ),
                      child: const Text(
                          style: TextStyle(color: Colors.white), 'Create'),
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
