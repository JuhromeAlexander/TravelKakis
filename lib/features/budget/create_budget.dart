import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:travel_kakis/models/Categories.dart';
import 'package:travel_kakis/utils/user_information.dart' as user_info;

import '../trips/Trips.dart';
import 'define_budget.dart';

class CreateBudget extends StatefulWidget {
  const CreateBudget({super.key});

  @override
  _CreateBudgetState createState() => _CreateBudgetState();
}

class _CreateBudgetState extends State<CreateBudget> {
  Trips? _selectedTrip;
  // List _trips = [];
  // List _categories = [];
  List _selectedCategories = [];

  final TextEditingController _tripController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _budgetNameController = TextEditingController();
  final TextEditingController _totalBudgetController = TextEditingController();

  //Writing Data
  void addData() async {
    CollectionReference budgets =
        FirebaseFirestore.instance.collection('budget');
    CollectionReference user = FirebaseFirestore.instance.collection('users');


    await budgets.add({
      'budgetTitle': _budgetNameController.text,
      'budgetStartDate': _selectedTrip?.getTripStartDate(),
      'budgetEndDate': _selectedTrip?.getTripEndDate(),
      'totalBudget': _totalBudgetController.text,
      'budgetStatusColor': "Colors.green",
      'categoryList': _selectedCategories,
      'userName': user_info.getUsername(),
    }).then((value) {
      //Add BudgetID to UserID as well
      user.doc(user_info.getID()).update({
        'budgets': FieldValue.arrayUnion([value]),
      });
      Navigator.push(context, MaterialPageRoute(
          builder: (context) => DefineBudget(categories: _selectedCategories, budgetUID: value))
      );
    });
  }

  // Future<List<Trips>> fetchTripsData() async {
  //   List trips = await getTripData();
  //   setState(() {
  //     _trips = trips;
  //   });
  //
  //   return _trips;
  // }

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
            activitiy_list: data['activities'],
            tripDocumentReference: null));
      });
    }
    return tripList;
  }

  Future<List> getCategoryData() async {
    List<Categories> categoryList = [];

    CollectionReference categoryRef =
        FirebaseFirestore.instance.collection('categories');
    //QuerySnapshot querySnapshot = await categoryRef.get();
    categoryRef.get().then(
        (querySnapshot) {
          for (var docSnapshot in querySnapshot.docs) {
            final data = docSnapshot.data() as Map<String, dynamic>;
            categoryList.add(Categories(
                categoryName: data['categoryName'].toString(),
                categoryType: data['categoryType'].toString(),
                categoryID: data['categoryID'].toString(),
              )
            );
          }
        }
    );
    // categoryList =
    //     querySnapshot.docs.map((doc) => doc.get('categoryName')).toList();
    return categoryList;
  }

  // Future<List> fetchCategoryData() async {
  //   List categories = await getCategoryData();
  //   setState(() {
  //     _categories = categories;
  //   });
  //
  //   return _categories;
  // }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Budget'),
      ),
      body: Container(
        padding: const EdgeInsets.all(10.0),
        child: FutureBuilder(
            future: Future.wait([getTripData(), getCategoryData()]),
            builder: (context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return const CircularProgressIndicator();
              }
              if (snapshot.hasData) {
                List<Trips> tripData = snapshot.data[0];
                List categoryData = snapshot.data[1];
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: TextField(
                        controller: _budgetNameController,
                        decoration: const InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          hintText: 'Budget Name',
                          hintStyle: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 30.0),
                      child: DropdownMenu(
                        controller: _tripController,
                        label: const Text('Select Trip'),
                        onSelected: (value) {
                          setState(() {
                            _selectedTrip = value;
                          });
                        },
                        dropdownMenuEntries: tripData.map((trip) {
                          return DropdownMenuEntry<Trips>(
                              value: trip, label: trip.tripTitle);
                        }).toList(),
                      ),
                    ),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: MultiSelectDialogField(
                          title: const Text('Select Categories'),
                          items: categoryData.map((category) {
                            return MultiSelectItem(category.categoryName, category.categoryName);
                          }).toList(),
                          onConfirm: (values) {
                            _selectedCategories = values;
                          },
                        ),
                        //child: Text(categoryData.toString()),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: addData,
                      child: const Text('Create')
                    ),
                  ],
                );
              }
              return const Text("Oops You Should Not be Seeing This");
            }),
      ),
    );
  }
}
