//import 'dart:nativewrappers/_internal/vm/lib/ffi_allocation_patch.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
        initialDate: widget.startDate,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100));

    setState(() {
      controller.text = datePicked.toString().split(' ')[0];
    });
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

    if (selectedTime != null) {
      setState(() {
        controller.text = selectedTime.format(context);
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
          SizedBox(
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
                      padding: const EdgeInsets.only(top: 30.0),
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
                      padding: const EdgeInsets.only(top: 20.0),
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
                  //Description
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: SizedBox(
                      height: 200, //     <-- TextField expands to this height.
                      child: TextField(
                        controller: _activityDescriptionController,
                        maxLines: null,
                        // Set this
                        expands: true,
                        // and this
                        keyboardType: TextInputType.multiline,
                        decoration: const InputDecoration(
                          enabledBorder: OutlineInputBorder(
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
                        controller: _activityCostController,
                        decoration: const InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey)),
                          hintText: 'Cost',
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                      )),
                  // date
                  Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: TextField(
                        readOnly: true,
                        onTap: () =>
                            _selectTime(context, _activityTimeController),
                        controller: _activityTimeController,
                        decoration: const InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey)),
                          hintText: 'Time',
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                      )),

                  Padding(
                      padding: const EdgeInsets.only(top: 20.0),
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
                  //collaborators
                  Padding(
                      padding: const EdgeInsets.only(top: 20.0),
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
                      padding: const EdgeInsets.only(top: 20.0),
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
                      padding: const EdgeInsets.only(top: 20.0),
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
                    margin: const EdgeInsets.only(top: 20.0, bottom: 20.0),
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
