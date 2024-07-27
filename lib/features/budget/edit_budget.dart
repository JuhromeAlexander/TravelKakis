import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:travel_kakis/utils/user_information.dart' as user_info;
import '../../models/Categories.dart';
import '../trips/Trips.dart';
import 'edit_define_budget.dart';

class EditBudget extends StatefulWidget{
  String? budgetTitle;
  List? categoryList;


  EditBudget({
    super.key,
    this.budgetTitle,
    required this.categoryList,
  });

  @override
  _EditBudgetState createState() => _EditBudgetState();
}

class _EditBudgetState extends State<EditBudget> {

  //TODO Implement Logic for Editing Budget
  //Detailed Category Card - Budget + Categories
  //Name + Assigned Trip + Categories
  Trips? _selectedTrip;
  List _selectedCategories = [];
  late String budgetName = widget.budgetTitle.toString();

  final TextEditingController _tripController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  late TextEditingController _budgetNameController = TextEditingController(text: widget.budgetTitle.toString());
  final TextEditingController _totalBudgetController = TextEditingController();

  void editExpenseData() async {
    List documentID = [];
    print(widget.budgetTitle.toString());
    print(budgetName);
    CollectionReference expense = FirebaseFirestore.instance.collection('expenses');
    QuerySnapshot querySnapshot = await expense
      .where('budgetName', isEqualTo: budgetName)
      .where('userName', isEqualTo: user_info.getUsername())
      .get();

    List<DocumentSnapshot> expenseDoc = querySnapshot.docs;
    print(widget.budgetTitle.toString());
    print('LENGTH OF EXPENSE DOCS');
    print(expenseDoc.length);
    for (int i = 0; i < expenseDoc.length; i++) {
      //documentID[i] = expenseDoc[i].id.toString();
      documentID.add(expenseDoc[i].id.toString());
    }

    print(documentID[0]);
    for (int i = 0; i < documentID.length; i++) {
      print(documentID[i]);
      expense.doc(documentID[i]).update({
        'budgetName': _budgetNameController.text
      });
    }
  }

  void editBudgetData() async {
    String documentID = '';

    CollectionReference budget = FirebaseFirestore.instance.collection('budget');
    QuerySnapshot querySnapshot = await budget
      .where('budgetTitle', isEqualTo: widget.budgetTitle)
      .where('userName', isEqualTo: user_info.getUsername())
      .limit(1)
      .get();

    List<DocumentSnapshot> budgetDoc = querySnapshot.docs;
    budgetDoc.forEach((document) {
      documentID = document.id.toString();
    });

    budget.doc(documentID).update({
      'budgetTitle' : _budgetNameController.text,
      'tripName' : _selectedTrip?.getTripTitle(),
      'categoryList' : _selectedCategories,
    }).then((value) {
      Navigator.push(context, MaterialPageRoute(
        builder: (context) => EditDefineBudget(categories: _selectedCategories, documentID: documentID)));
    });
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

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Budget'),
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
                          borderSide: BorderSide(
                            color: CupertinoColors.systemGrey,
                          ),
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
                        return DropdownMenuEntry(
                          value: trip,
                          label: trip.tripTitle);
                      }).toList(),
                    ),
                  ),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: MultiSelectDialogField(
                        initialValue: widget.categoryList as List,
                        title: const Text('Select Categories'),
                        items: categoryData.map((category) {
                          return MultiSelectItem(category.categoryName, category.categoryName);
                        }).toList(),
                        onConfirm: (values) {
                          _selectedCategories = values;
                        },
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      editExpenseData();
                      editBudgetData();
                    },
                    child: const Text('Proceed with Updating'))
                ],
              );
            }
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }

}