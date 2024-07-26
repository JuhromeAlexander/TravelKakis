import 'package:travel_kakis/utils/user_information.dart' as user_info;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../budget/Budgets.dart';
import 'Expense.dart';

class EditExpense extends StatefulWidget {
  Expense indivExpense;

  EditExpense({
    super.key,
    required this.indivExpense
  });

  @override
  _EditExpenseState createState() => _EditExpenseState();

}

class _EditExpenseState extends State<EditExpense> {

  Budgets? _selectedBudget;
  List expenseType = ['Income', 'Expense'];
  String? _selectedCategory;
  String? _selectedExpenseType;

  late TextEditingController _expenseNameController = TextEditingController(text: widget.indivExpense.expenseName);
  late TextEditingController _expenseDescController = TextEditingController(text: widget.indivExpense.expenseDesc);
  late TextEditingController _expenseCostController = TextEditingController(text: widget.indivExpense.expenseCost);
  final TextEditingController _budgetController = TextEditingController();
  final TextEditingController _expenseTypeController = TextEditingController();
  final TextEditingController _expenseCategoryController = TextEditingController();
  late TextEditingController _expenseDateController = TextEditingController(text: widget.indivExpense.expenseDate);

  //Editing Data
  void editExpense() async {
    String documentID = '';
    CollectionReference expense = FirebaseFirestore.instance.collection('expenses');
    QuerySnapshot querySnapshot = await expense
        .where("userName", isEqualTo: widget.indivExpense.userName)
        .where("budgetName", isEqualTo: widget.indivExpense.budgetName)
        .where("expenseTitle", isEqualTo: widget.indivExpense.expenseName)
        .get();

    List<DocumentSnapshot> expenseDoc = querySnapshot.docs;
    expenseDoc.forEach((document) {
      documentID = document.id.toString();
    });

    expense.doc(documentID).update({
      'expenseTitle' : _expenseNameController.text,
      'expenseDesc' : _expenseDescController.text,
      'expenseCost' : _expenseCostController.text,
      'userName' : user_info.getUsername(),
      'budgetName' : _selectedBudget?.budgetTitle,
      'categoryName' : _selectedCategory,
      'expenseType' : _selectedExpenseType,
      'expenseDate' : _expenseDateController.text
    });

    Navigator.pop(context);
  }

  Future<List> getIncomeCategoryData() async {
    List categoryList = [];

    CollectionReference categoryRef =
    FirebaseFirestore.instance.collection('categories');

    QuerySnapshot querySnapshot = await categoryRef.where("categoryType", isEqualTo: "Income").get();

    categoryList = querySnapshot.docs.map(
            (doc) => doc.get('categoryName')
    ).toList();

    return categoryList;
  }

  Future<List> getExpenseCategoryData() async {
    List categoryList = [];

    CollectionReference categoryRef =
    FirebaseFirestore.instance.collection('categories');

    QuerySnapshot querySnapshot = await categoryRef.where("categoryType", isEqualTo: "Expense").get();

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

    setState(() {
      controller.text = datePicked.toString().split(' ')[0];
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
          refLength = data['budgets'].length;
          budgetDoc = data['budgets'];
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

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Expenses'),
      ),
      body: Container(
        padding: const EdgeInsets.all(10.0),
        child: FutureBuilder(
          future: Future.wait([getBudgetData(), getIncomeCategoryData(), getExpenseCategoryData()]),
          builder: (context, AsyncSnapshot snapshot) {
            if(!snapshot.hasData) {
              return const CircularProgressIndicator();
            }
            if (snapshot.hasData) {
              List<Budgets> budgetData = snapshot.data[0];
              List incomeCategoryData = snapshot.data[1];
              List expenseCategoryData = snapshot.data[2];

              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: TextField(
                      controller: _expenseNameController  ,
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
                    padding: const EdgeInsets.only(top: 10.0),
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
                    padding: const EdgeInsets.only(top: 10.0),
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
                    padding: const EdgeInsets.only(top: 30.0),
                    child: DropdownMenu(
                      width: MediaQuery.sizeOf(context).width - 25,
                      controller: _budgetController,
                      label: const Text('Select Budget'),
                      initialSelection: widget.indivExpense.budgetName,
                      onSelected: (value) {
                        setState(() {
                          _selectedBudget = value as Budgets?;
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
                    padding: const EdgeInsets.only(top: 10.0),
                    child: DropdownMenu(
                      width: MediaQuery.sizeOf(context).width - 25,
                      controller: _expenseTypeController,
                      initialSelection: widget.indivExpense.expenseType,
                      label: const Text('Select Expense Type'),
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
                    padding: const EdgeInsets.only(top: 10.0),
                    child: DropdownMenu(
                      width: MediaQuery.sizeOf(context).width - 25,
                      controller: _expenseCategoryController,
                      label: const Text('Select Category'),
                      initialSelection: widget.indivExpense.categoryName,
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
                    padding: const EdgeInsets.all(10.0),
                    child: DropdownMenu(
                      width: MediaQuery.sizeOf(context).width - 25,
                      controller: _expenseCategoryController,
                      label: const Text('Select Category'),
                      initialSelection: widget.indivExpense.expenseName,
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
                    padding: const EdgeInsets.only(top: 20.0),
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
                      onPressed: (){
                        editExpense();
                      },
                      child: const Text('Edit Expense')
                  ),
                ],
              );

            }
            return const Text("You Should not Be Seeing This!");
          },
        ),
      ),
    );
  }

}