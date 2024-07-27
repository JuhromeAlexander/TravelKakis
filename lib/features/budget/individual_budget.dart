import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:travel_kakis/features/budget/edit_budget.dart';
import 'package:travel_kakis/features/categories/overview_categories.dart';
import 'package:travel_kakis/features/expenses/Expense.dart';
import 'package:travel_kakis/features/expenses/create_expense.dart';
import 'package:travel_kakis/features/expenses/edit_expense.dart';
import 'package:travel_kakis/features/expenses/individual_expense.dart';
import 'package:travel_kakis/home_page.dart';
import 'package:travel_kakis/utils/user_information.dart' as user_info;
import 'dart:math' as math;

import 'Budgets.dart';

class IndividualBudget extends StatefulWidget {
  final String? budgetTitle;
  final DateTime? budgetStartDate;
  final DateTime? budgetEndDate;
  final num? totalBudget;
  final num? budgetSpent;
  final num? budgetRemaining;
  final num? budgetCardIndicatorValue;
  final String? budgetStatusColor;
  final List? categoryList;
  final String? userName;

  const IndividualBudget({
    super.key,
    this.budgetTitle,
    this.budgetStartDate,
    this.budgetEndDate,
    this.totalBudget,
    this.budgetSpent,
    this.budgetRemaining,
    this.budgetCardIndicatorValue,
    this.budgetStatusColor,
    this.categoryList,
    this.userName
  });

  @override
  _IndividualBudgetState createState() => _IndividualBudgetState();
}

class _IndividualBudgetState extends State<IndividualBudget> {
  // Reading the Data from Budget Collection
  Future<List> getExpensesData() async {
    List expenseList = [];

    CollectionReference expenseRef =
    FirebaseFirestore.instance.collection('expenses');
    QuerySnapshot querySnapshot = await expenseRef
        .where('userName', isEqualTo: user_info.getUsername())
        .where('budgetName', isEqualTo: widget.budgetTitle.toString())
        .get();

    List<DocumentSnapshot> expenseDocs = querySnapshot.docs;
    expenseDocs.forEach((document) {
      expenseList.add(Expense(
          expenseName: document.get('expenseTitle'),
          expenseDesc: document.get('expenseDesc'),
          expenseCost: document.get('expenseCost'),
          userName: document.get('userName'),
          budgetName: document.get('budgetName'),
          categoryName: document.get('categoryName'),
          expenseType: document.get('expenseType'),
          expenseDate: document.get('expenseDate')));
    });
    return expenseList;
  }

  Future<List> getBudgetData() async {
    List budgetDoc = [];
    List budgetList = [];
    int refLength = 0;

    //Grabbing the Budgets that belongs to the user
    CollectionReference user = FirebaseFirestore.instance.collection('users');
    DocumentReference specificUser = user.doc(user_info.getID());

    await specificUser.get().then((DocumentSnapshot doc) {
      final data = doc.data() as Map<String, dynamic>;
      refLength = data['budgets'].length;
      budgetDoc = data['budgets'];
    });

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
            budgetCardIndicatorValue:
            (data['budgetSpent'] / data['totalBudget']) * 100,
            budgetStatusColor: data['budgetStatusColor'],
            categoryList: data['categoryList']));
      });
    }
    return budgetList;
  }

  Future<List> getCategoryData() async {
    List categoryList = [];

    CollectionReference categoryRef =
    FirebaseFirestore.instance.collection('categories');
    QuerySnapshot querySnapshot = await categoryRef.get();

    categoryList =
        querySnapshot.docs.map((doc) => doc.get('categoryName')).toList();

    return categoryList;
  }

  //Logic to Calculate Collated Expenses and Categories
  Future<List> getCollatedExpenses() async {
    List collatedValues = [];

    for (int i = 0; i < widget.categoryList!.length; i++) {
      String? categoryName = widget.categoryList?[i];
      String? budgetName = widget.budgetTitle;
      double expenseValue = 0.0;

      CollectionReference expensesRef =
      FirebaseFirestore.instance.collection('expenses');
      QuerySnapshot querySnapshot = await expensesRef
          .where('categoryName', isEqualTo: categoryName)
          .where('budgetName', isEqualTo: budgetName)
          .where('userName', isEqualTo: user_info.getUsername())
          .get();

      List<DocumentSnapshot> expenseDocs = querySnapshot.docs;
      expenseDocs.forEach((document) {
        expenseValue = double.parse(document.get('expenseCost').toString()) +
            expenseValue;
      });
      collatedValues.add(expenseValue);
    }
    return collatedValues;
  }

  Widget _individualCardStateless() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Stack(
        children: [
          Container(
            height: 200.0,
            decoration: const BoxDecoration(
                color: CupertinoColors.darkBackgroundGray,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                  bottomLeft: Radius.circular(20.0),
                  bottomRight: Radius.circular(20.0),
                )),
            child: Container(
              margin: const EdgeInsets.only(
                top: 120.0,
                left: 20.0,
                right: 10.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 7,
                        child: LinearProgressIndicator(
                          value: widget.budgetCardIndicatorValue?.toDouble(),
                          backgroundColor: CupertinoColors.white,
                          valueColor: AlwaysStoppedAnimation(CupertinoColors.systemGrey),
                        ),
                      ),
                      const SizedBox(
                        width: 20.0,
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          '${widget.budgetCardIndicatorValue.toString()}%',
                          style: const TextStyle(
                            color: CupertinoColors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                  Text(
                    'Budget Spent: \$${widget.budgetSpent.toString()}',
                    style: const TextStyle(
                      color: CupertinoColors.systemGrey,
                    ),
                  ),
                  (widget.budgetRemaining! < 0) ? Text(
                    'Budget Remaining: \$${widget.budgetRemaining.toString()}',
                    style: const TextStyle(
                      color: CupertinoColors.systemRed,
                    ),
                  ) : Text(
                    'Budget Remaining: \$${widget.budgetRemaining.toString()}',
                    style: const TextStyle(
                      color: CupertinoColors.systemGreen,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            //Contains Status Bar and Budget Title
            height: 100.0,
            decoration: const BoxDecoration(
              color: CupertinoColors.systemGrey,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20.0),
                bottomRight: Radius.circular(20.0),
              ),
            ),
            child: Container(
              width: MediaQuery.sizeOf(context).width,
              margin: EdgeInsets.all(15.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text(
                            widget.budgetTitle.toString(),
                            style: const TextStyle(
                              color: CupertinoColors.black,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            widget.budgetStartDate.toString(),
                            style: const TextStyle(
                              color: CupertinoColors.black,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            widget.budgetEndDate.toString(),
                            style: const TextStyle(
                              color: CupertinoColors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Container(
              decoration: BoxDecoration(
                color: widget.budgetStatusColor.toString() == 'CupertinoColors.systemGreen' ? CupertinoColors.systemGreen : CupertinoColors.systemRed,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20.0),
                ),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 29.0,
                vertical: 4.0,
              ),
              child: widget.budgetStatusColor.toString() == 'CupertinoColors.systemGreen' ? const Text(
                'Open',
                style: TextStyle(
                  color: Colors.white,
                ),
              ) : const Text(
                'Close',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _pieChartWidget() {
    //List<PieChartSectionData>? pieChartData = getPieChartData();
    return FutureBuilder(
        future: getCollatedExpenses(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            List<PieChartSectionData> pieChartData = [];
            List collatedExpense = snapshot.data;
            print('Widget Category List');
            print(widget.categoryList);
            for (int i = 0; i < collatedExpense.length; i++) {
              print(widget.categoryList![i]);
              print(collatedExpense[i]);
              pieChartData.add(PieChartSectionData(
                  value: collatedExpense[i],
                  title: widget.categoryList![i],
                  color: Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
                      .withOpacity(1.0)));
            }
            print('Printing pieChartData');
            print(pieChartData);
            return Container(
              color: Colors.red,
              width: MediaQuery
                  .sizeOf(context)
                  .width,
              height: 400.0,
              margin: EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    'At A Glance',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery
                        .sizeOf(context)
                        .width,
                    height: 350.0,
                    child: PieChart(
                      PieChartData(
                        sections: pieChartData,
                      ),
                    ),
                  )
                ],
              ),
            );
          }
          if (!snapshot.hasData) {
            return const Text('No Data');
          }
          if (snapshot.hasError) {
            return Text('Error Loading ${snapshot.error.toString()}');
          }
          return const CircularProgressIndicator();
        });
  }
  
  Future<List> getBudgetDataValueList() async {
    String documentID = '';
    late List budgetValueData;
    CollectionReference budget = FirebaseFirestore.instance.collection('budget');
    QuerySnapshot querySnapshot = await budget
      .where('budgetTitle', isEqualTo: widget.budgetTitle)
      .where('userName', isEqualTo: user_info.getUsername())
      .get();

    List<DocumentSnapshot> budgetDoc = querySnapshot.docs;
    for (int i = 0; i < budgetDoc.length; i++) {
      documentID = budgetDoc[i].id.toString();
    }

    DocumentReference exactBudgetDoc = budget.doc(documentID);
    await exactBudgetDoc.get().then((document) {
      budgetValueData = document.get('budgetList');
    });

    return budgetValueData;
  }

  _individualCategoryRow(context, expenseData, budgetData) {
    return ListView.separated(
      itemBuilder: (context, index) {
        return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Container(
              width: MediaQuery.sizeOf(context).width,
              height: 150.0,
              margin: const EdgeInsets.all(5.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    (widget.categoryList?[index]).toString(),
                    style: const TextStyle(
                      color: CupertinoColors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 8,
                        child: LinearProgressIndicator(
                          borderRadius:  BorderRadius.circular(20.0),
                          minHeight: 20,
                          value:  double.parse((expenseData[index] / widget.totalBudget).toStringAsFixed(1)),
                          backgroundColor: Colors.grey[300],
                          valueColor: AlwaysStoppedAnimation(Colors.grey[800]),
                        ),
                      ),
                      const SizedBox(
                        width: 15.0,
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          '${(((expenseData[index] / widget.totalBudget) * 100).toStringAsFixed(0)).toString()}%',
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: 20,
                    width: MediaQuery.sizeOf(context).width,
                  ),
                  Text(
                    'Total: \$${budgetData[index]}',
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w300,
                      color: CupertinoColors.black,
                    ),
                  ),
                  Text(
                    'Spent: \$${expenseData[index]}',
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w300,
                      color: CupertinoColors.black,
                    ),
                  ),
                  (widget.totalBudget! - expenseData[index]) < 0 ? Text(
                    'Remaining: \$${(widget.totalBudget! - expenseData[index])}',
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w300,
                      color: CupertinoColors.systemRed,
                    ),
                  ) : Text(
                    'Remaining: \$${(widget.totalBudget! - expenseData[index])}',
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w300,
                      color: CupertinoColors.systemGreen,
                    ),
                  ),
                ],
              ),
            )
        );
      },
      separatorBuilder: (context, index) {
        return Container(
          width: MediaQuery.sizeOf(context).width,
          height: 20.0,
        );
      },
      itemCount: expenseData.length
    );
  }

  _printCategoryCard() {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      height: 500.0,
      margin: EdgeInsets.all(20.0),
      color: CupertinoColors.systemGrey,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
        ),
        margin: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            FutureBuilder(
              future: Future.wait([getCollatedExpenses(), getBudgetDataValueList()]),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  List data = snapshot.data;
                  return Expanded(child: _individualCategoryRow(context, data[0], data[1]));
                }
                if (!snapshot.hasData) {
                  return const Text('No Detailed Categories Yet!');
                }
                if (snapshot.hasError) {
                  return Text('Error Loading Categories ${snapshot.error.toString()}');
                }
                return const CircularProgressIndicator();
              }
            ),
          ],
        ),
      ),
    );
  }
  
  void _navigateToEditExpensesPage(Expense indivExpense) {
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => EditExpense(indivExpense: indivExpense,))
    ).then((_) {
      setState(() {

      });
    });
  }

  void _navigateToIndivExpensesPage(Expense indivExpense) {
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => IndividualExpense(indivExpense: indivExpense,))
    ).then((_) {
      setState(() {

      });
    });
  }

  Widget _individualExpenseRow(context, data) {
    return ListView.separated(
          itemBuilder: (context, index) {
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: InkWell(
                onTap: () {
                  _navigateToIndivExpensesPage(data[index]);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data[index].getExpenseName(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: CupertinoColors.black,
                              fontSize: 16.0,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                data[index].getCategoryName(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w300,
                                  color: CupertinoColors.systemGrey,
                                  fontSize: 12.0,
                                ),
                              ),
                              Text(
                                data[index].getUserName(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w300,
                                  color: CupertinoColors.systemGrey,
                                  fontSize: 12.0,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        '\$${data[index].getExpenseCost()}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: CupertinoColors.systemRed,
                          fontSize: 16.0,
                        ),
                        textAlign: TextAlign.end,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: IconButton(
                        onPressed: () {
                          _navigateToEditExpensesPage(data[index]);
                        },
                        icon: const Icon(
                          Icons.edit,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
          separatorBuilder: (context, index) {
            return Container(
              width: MediaQuery
                  .sizeOf(context)
                  .width,
              height: 20.0,
            );
          },
          itemCount: data.length,
    );
  }

  _printExpenseCard() {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      height: 500.0,
      margin: const EdgeInsets.all(20.0),
      color: CupertinoColors.systemGrey,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
        ),
        margin: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            FutureBuilder(
                future: getExpensesData(),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    List data = snapshot.data;
                    return Expanded(child: _individualExpenseRow(context, data));
                  }
                  if (!snapshot.hasData) {
                    return const Text('No Expenses Yet');
                  }
                  if (snapshot.hasError) {
                    return Text('Error Loading Expenses ${snapshot.error.toString()}');
                  }
                  return const CircularProgressIndicator();
                }
            ),
          ],
        )
      ),
    );
  }

  //Navigation Methods
  void _navigateToCreateExpense(context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CreateExpense()),
    );
  }

  void _navigateToEditBudget(context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditBudget(budgetTitle: widget.budgetTitle, categoryList: widget.categoryList,)),
    );
  }

  void _navigateToManageCategories(context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => OverviewCategories()),
    );
  }

  void _closeBudgetStatus() async {
    String documentID = '';
    String budgetStatusColor = '';

    CollectionReference budget = FirebaseFirestore.instance.collection('budget');
    QuerySnapshot querySnapshot = await budget
      .where('budgetTitle', isEqualTo: widget.budgetTitle)
      .where('userName', isEqualTo: user_info.getUsername())
      .get();

    List<DocumentSnapshot> budgetDoc = querySnapshot.docs;

    for (int i = 0; i < budgetDoc.length; i++) {
      documentID = budgetDoc[i].id.toString();
    }

    DocumentReference exactBudgetDoc = budget.doc(documentID);
    await exactBudgetDoc.get().then((document) {
      budgetStatusColor = document.get('budgetStatusColor');
    });

    exactBudgetDoc.update({
      'budgetStatusColor': 'CupertinoColors.systemRed',
    });

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
    );
  }

  void _openBudgetStatus() async {
    String documentID = '';
    String budgetStatusColor = '';

    CollectionReference budget = FirebaseFirestore.instance.collection('budget');
    QuerySnapshot querySnapshot = await budget
        .where('budgetTitle', isEqualTo: widget.budgetTitle)
        .where('userName', isEqualTo: user_info.getUsername())
        .get();

    List<DocumentSnapshot> budgetDoc = querySnapshot.docs;

    for (int i = 0; i < budgetDoc.length; i++) {
      documentID = budgetDoc[i].id.toString();
    }

    DocumentReference exactBudgetDoc = budget.doc(documentID);
    await exactBudgetDoc.get().then((document) {
      budgetStatusColor = document.get('budgetStatusColor');
    });

    exactBudgetDoc.update({
      'budgetStatusColor': 'CupertinoColors.systemGreen',
    });

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.budgetTitle.toString()),
      ),
      floatingActionButton: SpeedDial(
        backgroundColor: Colors.blue,
        spaceBetweenChildren: 10,
        spacing: 10,
        icon: Icons.add,
        children: [
          SpeedDialChild(
              child: const Icon(Icons.receipt),
              label: 'Add Expense',
              onTap: (){
                _navigateToCreateExpense(context);
              }
          ),
          SpeedDialChild(
              child: const Icon(Icons.edit_attributes_sharp),
              label: 'Edit budget',
              onTap: (){
                _navigateToEditBudget(context);
              }
          ),
          widget.budgetStatusColor.toString() == 'CupertinoColors.systemGreen' ? SpeedDialChild(
              child: const Icon(Icons.close),
              label: 'Close Budget',
              onTap: (){
                setState(() {
                  _closeBudgetStatus();
                });
              }
          ) : SpeedDialChild(
              child: const Icon(Icons.close),
              label: 'Open Budget',
              onTap: (){
                setState(() {
                  _openBudgetStatus();
                });
              }
          ),
          SpeedDialChild(
              child: const Icon(Icons.category_sharp),
              label: 'Manage Categories',
              onTap: (){
                _navigateToManageCategories(context);
              }
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _individualCardStateless(),
            //TODO: Implement Collaborator
            _pieChartWidget(),
            const Text(
              'Detailed Category View',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: CupertinoColors.black,
                  fontSize: 16.0
              ),
            ),
            _printCategoryCard(),
            const Text(
              'Expenses',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: CupertinoColors.black,
                fontSize: 16.0
              ),
            ),
            _printExpenseCard(),
          ],
        ),
      ),
    );
  }
}
