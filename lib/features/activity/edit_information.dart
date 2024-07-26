//import 'dart:nativewrappers/_internal/vm/lib/ffi_allocation_patch.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:travel_kakis/features/activity/activity.dart';

class EditInformation extends StatefulWidget {
  final DocumentSnapshot documentSnapshot;
  final Function callback;

  EditInformation({
    super.key,
    required this.documentSnapshot,
    required this.callback,
  });

  @override
  _EditInformationState createState() => _EditInformationState();
}

class _EditInformationState extends State<EditInformation> {

  late final TextEditingController _activityTitleController;
  late final TextEditingController _activityDateController;
  late final TextEditingController _activityDescriptionController;
  late final TextEditingController _activityCostController;
  late final TextEditingController _activityTimeController;
  late final TextEditingController _activityDurationController;
  late final TextEditingController _activityLocationController;
  late final TextEditingController _activityPhoneController;
  late final TextEditingController _activityWebsiteController;

  late final _startDate;

  @override
  void initState() {
    super.initState();
    final data = widget.documentSnapshot.data() as Map<String, dynamic>;

    _startDate = DateTime.parse(data['date']);

    _activityTitleController = TextEditingController(text: data['title']);
    _activityDateController = TextEditingController(text: data['date']);
    _activityDescriptionController =
        TextEditingController(text: data['description']);
    _activityCostController = TextEditingController(text: data['cost']);
    _activityTimeController = TextEditingController(text: data['time']);
    _activityDurationController = TextEditingController(text: data['duration']);
    _activityLocationController = TextEditingController(text: data['location']);
    _activityPhoneController = TextEditingController(text: data['phone']);
    _activityWebsiteController = TextEditingController(text: data['website']);
  }

  //to write data
  void updateData(BuildContext context, documentSnapshot) async {
    CollectionReference activity =
        FirebaseFirestore.instance.collection('activity');

    String docID = widget.documentSnapshot.id;

    await activity.doc(docID).update({
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
    });
    //
    widget.callback();

    Navigator.pop(context);
  }

//Calendar
  Future<void> _selectDate(context, controller) async {
    DateTime? datePicked = await showDatePicker(
        context: context,
        // initialDate: widget.startDate,
        initialDate: _startDate,
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
        title: const Text('Edit Information'),
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
                    child: TextFormField(
                      decoration: InputDecoration(
                          hintText: 'Title',
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          )),
                      controller: _activityTitleController,
                    ),

                    // child: TextField(
                    //   controller: _activityTitleController,
                    //   decoration: InputDecoration(
                    //     enabledBorder: OutlineInputBorder(
                    //         borderRadius: BorderRadius.circular(10.0),
                    //         borderSide: BorderSide(color: Colors.grey)),
                    //     hintText: 'Title',
                    //     hintStyle: TextStyle(color: Colors.grey),
                    //   ),
                    // )
                  ),
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
                      onPressed: () =>
                          updateData(context, widget.documentSnapshot),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6), // <-- Radius
                        ),
                        minimumSize: const Size(double.infinity, 40),
                      ),
                      child: const Text(
                          style: TextStyle(color: Colors.white), 'Edit'),
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
