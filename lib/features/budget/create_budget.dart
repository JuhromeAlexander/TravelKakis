import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:multi_select_flutter/dialog/mult_select_dialog.dart';
import 'package:travel_kakis/utils/user_information.dart' as user_info;

import '../../models/Categories.dart';
import '../trips/Trips.dart';

class CreateBudget extends StatefulWidget {
  CreateBudget({super.key})

  @override
  _CreateBudgetState createState() => _CreateBudgetState();
}

class _CreateBudgetState extends State<CreateBudget> {

  String? _selectedTrip;
  List<Trips> _trips = [];
  List<Categories> _categories = [];
  List<Categories> _selectedCategories = [];

  final TextEditingController _tripController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _budgetNameController = TextEditingController();

  //Writing Data
  void addData() async {
    CollectionReference budgets = FirebaseFirestore.instance.collection('budgets');
    CollectionReference user = FirebaseFirestore.instance.collection('users');
  }

  Future<List<Trips>> fetchTripsData() async {
    List<Trips> trips = await getTripData();
    setState(() {
      _trips = trips;
    });

    return _trips;
  }

  Future<List<Trips>> getTripData() async {
    List tripDoc = [];
    List<Trips> tripList = [];
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
                      future: fetchTripsData(),
                      builder: (context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData) {
                          List data = snapshot.data;
                          return DropdownMenu(
                            initialSelection: 'Select Trip',
                            controller: _tripController,
                            label: const Text('Trip'),
                            dropdownMenuEntries: _trips.map<DropdownMenuEntry<Trips>>(
                                (Trips trip) {
                                  return DropdownMenuEntry<Trips>(
                                    value: trip,
                                    label: trip.tripTitle
                                  );
                                }
                            ).toList(),
                          );
                        }
                        if (!snapshot.hasData) {
                          return const Text('No Trips, add some!');
                        }
                        if (snapshot.hasError) {
                          return Text('Error Loading trips ${snapshot.error.toString()}');
                        }
                        return CircularProgressIndicator();
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20.0),
                    child: FutureBuilder<List>(
                      future: fetchCategoryData(),
                      builder: (context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData) {
                          List data = snapshot.data;
                          return MultiSelectDialog(
                            items: ,
                            initialValue: ,
                          );
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

  Future<List> getCategoryData() async {
    List<Categories> categoryList = [];
    int refLength = 0;

    CollectionReference categoryRef = FirebaseFirestore.instance.collection('categories');
    QuerySnapshot querySnapshot = await categoryRef.get();

    final allCategories = querySnapshot.docs.map((doc) => doc.data()).toList();

    return allCategories;
  }

  Future<List> fetchCategoryData() async {

  }
}