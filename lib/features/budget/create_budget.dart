import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:travel_kakis/utils/user_information.dart' as user_info;

import '../trips/Trips.dart';

enum AssignedTrip {

}

class CreateBudget extends StatefulWidget {
  CreateBudget({super.key})

  @override
  _CreateBudgetState createState() => _CreateBudgetState();
  }

class _CreateBudgetState extends State<CreateBudget> {

  //Writing Data
  void addData() async {
    CollectionReference budgets = FirebaseFirestore.instance.collection('budgets');
    CollectionReference user = FirebaseFirestore.instance.collection('users');
  }

  Future<List> getData() async {
    List tripDoc = [];
    List tripList = [];
    int refLength = 0;

    //Grab Trips belonging to Logged in User
    CollectionReference user = FirebaseFirestore.instance.collection('users');
    DocumentReference specificUser = user.doc(user_info.getID());

    await specificUser.get().then((DocumentSnapshot doc) {
      final data = doc.data() as Map<String, dynamic>;
      refLength = data['trips'].length;
      tripDoc = data['trips'];
    });

    for (int i = 0; i < refLength; i++) {
      await tripDoc[i].get().then((DocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;
        tripList.add(Trips(
            tripStartDate: data['tripStartDate'].toString(),
            tripEndDate: data['tripEndDate'].toString(),
            tripLocation: data['tripLocation'].toString(),
            tripTitle: data['tripTitle'].toString(),
            documentSnapshot: doc,
            activitiy_list: data['activities']));
      });
    }
    return tripList;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Budget'),
      ),
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(
                horizontal: 30.0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //Budget Name
                  Padding(
                    padding: EdgeInsets.only(top: 30.0),
                    child: TextField(
                      controller: _budgetNameController,
                      decoration: const InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey)
                        ),
                        hintText: 'Budget Name',
                        hintStyle: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20.0),
                    child: FutureBuilder<List>(
                      future: getData(),
                      builder: (context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData) {
                          List data = snapshot.data;
                          return DropdownMenu(
                            initialSelection: 'Select Trip',
                            controller: tripController,
                            label: const Text('Trip'),
                            onSelected: ,
                            dropdownMenuEntries: dropdownMenuEntries);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}