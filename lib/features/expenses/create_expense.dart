import 'dart:js_interop';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:travel_kakis/features/budget/Budgets.dart';
import 'package:travel_kakis/features/expenses/expense.dart';
import 'package:travel_kakis/models/Categories.dart';
import 'package:travel_kakis/utils/user_information.dart' as user_info;

class CreateExpense extends StatefulWidget {

  CreateExpense({super.key});

  @override
  _CreateExpenseState createState() => _CreateExpenseState();
}

class _CreateExpenseState extends State<CreateExpense> {
  Budgets? _selectedBudget;
  List expenseType = ['Income', 'Expense'];
  late String? _selectedCategory;
  late String? _selectedExpenseType;

  final TextEditingController _expenseNameController = TextEditingController();
  final TextEditingController _expenseDescController = TextEditingController();
  final TextEditingController _expenseCostController = TextEditingController();
  final TextEditingController _budgetController = TextEditingController();
  final TextEditingController _expenseTypeController = TextEditingController();
  final TextEditingController _expenseCategoryController = TextEditingController();
  final TextEditingController _expenseDateController = TextEditingController();

  //Writing Data
  void addExpense() async {
    CollectionReference expense = FirebaseFirestore.instance.collection('expenses');
    CollectionReference user = FirebaseFirestore.instance.collection('users');

    await expense.add({
      'expenseTitle' : _expenseNameController.text,
      'expenseDesc' : _expenseDescController.text,
      'expenseCost' : _expenseCostController.text,
      'userName' : user_info.getUsername(),
      'budgetName' : _selectedBudget?.budgetTitle,
      'categoryName' : _selectedCategory,
      'expenseType' : _selectedExpenseType,
      'expenseDate' : _expenseDateController.text
    }).then((value) {
      //Add ExpenseID to User Data
      user.doc(user_info.getID()).update({
        'expenses': FieldValue.arrayUnion([value]),
      });
    });
  }

  Future<List<Budgets>> getBudgetData() async {
    List budgetDoc = [];
    List<Budgets> budgetList = [];
    int refLength = 0;

    //Grab Budgets Belonging to User
    CollectionReference user = FirebaseFirestore.instance.collection('users');
    DocumentReference specificUser = user.doc(user_info.getID());

    await specificUser.get().then(
        (DocumentSnapshot doc) {
          final data = doc.data() as Map<String, dynamic>;
          refLength = data['budget'].length;
          budgetDoc = data['budget'];
        }
    );

    for (int i = 0; i < refLength; i++) {
      await budgetDoc[i].get().then((DocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;
        budgetList.add(Budgets(
            budgetTitle: data['budgetTitle'].toString(),
            budgetStartDate: data['budgetStartDate'].toString(),
            budgetEndDate: data['budgetEndDate'].toString(),
            totalBudget: data['totalBudget'],
            budgetSpent: data['budgetSpent'],
            budgetRemaining: data['totalBudget'] - data['budgetSpent'],
            budgetCardIndicatorValue: (data['budgetSpent'] / data['totalBudget']) * 100,
            budgetStatusColor: data['budgetStatusColor'],
            categoryList: data['categoryList']
        ));
      });
    }
    return budgetList;
  }

  Future<List> getIncomeCategoryData() async {
    List categoryList = [];

    CollectionReference categoryRef =
    FirebaseFirestore.instance.collection('categories');

    QuerySnapshot querySnapshot = await categoryRef.where("categoryType", isEqualTo: "income").get();

    categoryList = querySnapshot.docs.map(
        (doc) => doc.get('categoryName')
    ).toList();

    return categoryList;
  }

  Future<List> getExpenseCategoryData() async {
    List categoryList = [];

    CollectionReference categoryRef =
    FirebaseFirestore.instance.collection('categories');

    QuerySnapshot querySnapshot = await categoryRef.where("categoryType", isEqualTo: "expense").get();

    categoryList = querySnapshot.docs.map(
            (doc) => doc.get('categoryName')
    ).toList();

    return categoryList;
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
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Expense'),
      ),
      body: Container(
        padding: EdgeInsets.all(10.0),
        child: FutureBuilder(
          future: Future.wait([getBudgetData(),getIncomeCategoryData(),getExpenseCategoryData()]),
          builder: (context, AsyncSnapshot snapshot) {
            if(!snapshot.hasData) {
              return CircularProgressIndicator();
            }
            if (snapshot.hasData) {
              List<Budgets> budgetData = snapshot.data[0];
              List incomeCategoryData = snapshot.data[1];
              List expenseCategoryData = snapshot.data[2];

              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: TextField(
                      controller: _expenseNameController,
                      decoration:  const InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        hintText: 'Expense Name',
                        hintStyle: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: TextField(
                      controller: _expenseDescController,
                      decoration:  const InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        hintText: 'Expense Description',
                        hintStyle: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 30.0),
                    child: TextField(
                      controller: _expenseCostController,
                      decoration:  const InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        hintText: 'Expense Cost',
                        hintStyle: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 30.0),
                    child: DropdownMenu(
                      controller: _budgetController,
                      label: Text('Select Budget'),
                      onSelected: (value) {
                        setState(() {
                          _selectedBudget = value;
                        });
                      },
                      dropdownMenuEntries: budgetData.map((budget) {
                        return DropdownMenuEntry<Budgets>(
                          value: budget,
                          label: budget.budgetTitle!);
                      }).toList(),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: DropdownMenu(
                      controller: _expenseTypeController,
                      label: Text('Select Expense Type'),
                      onSelected: (value) {
                        setState(() {
                          _selectedExpenseType = value;
                          _selectedCategory = null;
                        });
                      },
                      dropdownMenuEntries: expenseType.map((type) {
                        return DropdownMenuEntry(
                          value: type,
                          label: type
                        );
                      }).toList(),
                    ),
                  ),
                  _selectedExpenseType != 'Income'
                  ? Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: DropdownMenu(
                      controller: _expenseCategoryController,
                      label: Text('Select Category'),
                      initialSelection: _selectedCategory,
                      onSelected: (newValue) {
                        setState(() {
                          _selectedCategory = newValue;
                        });
                      },
                      dropdownMenuEntries: expenseCategoryData.map((category) {
                        return DropdownMenuEntry(
                          value: category,
                          label: category);
                      }).toList(),
                    ),
                  )
                  : Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: DropdownMenu(
                      controller: _expenseCategoryController,
                      label: Text('Select Category'),
                      initialSelection: _selectedCategory,
                      onSelected: (newValue) {
                        setState(() {
                          _selectedCategory = newValue;
                        });
                      },
                      dropdownMenuEntries: incomeCategoryData.map((category) {
                        return DropdownMenuEntry(
                            value: category,
                            label: category);
                      }).toList(),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20.0),
                    child: TextField(
                      controller: _expenseDateController,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.calendar_month),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        hintText: 'Select Date',
                        hintStyle: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      readOnly: true,
                      onTap: () {
                        _selectDate(context, _expenseDateController);
                      },
                    ),
                  ),
                  ElevatedButton(
                    onPressed: addExpense,
                    child: const Text('Create')
                  ),
                ],
              );
            }
            return Text("You Should not Be Seeing This");
          }
        ),
      ),
    );
  }

}