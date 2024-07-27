import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:travel_kakis/features/budget/Budgets.dart';
import 'package:travel_kakis/utils/user_information.dart' as user_info;

class CreateExpense extends StatefulWidget {

  const CreateExpense({super.key});

  @override
  _CreateExpenseState createState() => _CreateExpenseState();
}

class _CreateExpenseState extends State<CreateExpense> {
  Budgets? _selectedBudget;
  List expenseType = ['Income', 'Expense'];
  String? _selectedCategory;
  String? _selectedExpenseType;

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

  void updateBudget() async {
    String documentID = '';
    var expenseCost;
    CollectionReference budget = FirebaseFirestore.instance.collection('budget');
    QuerySnapshot querySnapshot = await budget
      .where('budgetTitle', isEqualTo: _budgetController.text)
      .where('userName', isEqualTo: user_info.getUsername())
      .get();

    List<DocumentSnapshot> budgetDoc = querySnapshot.docs;
    budgetDoc.forEach((document) {
      documentID = document.id.toString();
      expenseCost = document.get('budgetSpent')
          + double.parse(_expenseCostController.text);
    });

    print(documentID);
    budget.doc(documentID).update({
      'budgetSpent' : expenseCost
    });
    Navigator.pop(context);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Expense'),
      ),
      body: Container(
        padding: const EdgeInsets.all(10.0),
        child: FutureBuilder(
          future: Future.wait([getBudgetData(),getIncomeCategoryData(),getExpenseCategoryData()]),
          builder: (context, AsyncSnapshot snapshot) {
            if(!snapshot.hasData) {
              debugPrint('Testing has no data');
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
                    padding: const EdgeInsets.only(top: 10.0),
                    child: DropdownMenu(
                      width: MediaQuery.sizeOf(context).width - 25,
                      controller: _expenseTypeController,
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
                    padding: const EdgeInsets.only(top: 10.0),
                    child: DropdownMenu(
                      width: MediaQuery.sizeOf(context).width - 25,
                      controller: _expenseCategoryController,
                      label: const Text('Select Category'),
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
                    onPressed: () {
                      addExpense();
                      updateBudget();
                    },
                    child: const Text('Create')
                  ),
                ],
              );
            }
            return const Text("You Should not Be Seeing This");
          }
        ),
      ),
    );
  }

}