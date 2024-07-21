import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:travel_kakis/models/Categories.dart';
import 'package:travel_kakis/utils/user_information.dart' as user_info;
import 'dart:math' as math;

import 'Budgets.dart';

class IndividualBudget extends StatefulWidget {
  final String? budgetTitle;
  final DateTime? budgetStartDate;
  final DateTime? budgetEndDate;
  final int? totalBudget;
  final int? budgetSpent;
  final int? budgetRemaining;
  final double? budgetCardIndicatorValue;
  final String? budgetStatusColor;
  final List? categoryList;

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

    expenseList = querySnapshot.docs.map((doc) => doc.data()).toList();

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

  // List<PieChartSectionData> getPieChartData() {
  //   List<PieChartSectionData> pieChartData = [];
  //   Future<List> collatedExpenseList = getCollatedExpenses();
  //
  //   for (int i = 0; i < collatedExpenseList.length; i++) {
  //     pieChartData[i] = PieChartSectionData(
  //         value: collatedExpenseList[i],
  //         title: widget.categoryList?[i],
  //         color: Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
  //             .withOpacity(1.0));
  //   }
  //
  //   return pieChartData;
  // }

  //Logic to Calculate Collated Expenses and Categories
  Future<List> getCollatedExpenses() async {
    List collatedValues = [];

    for (int i = 0; i < widget.categoryList!.length; i++) {
        String? categoryName = widget.categoryList?[i];
        String? budgetName = widget.budgetTitle;
        double expenseValue = 0.0;

        print(i);
        print(widget.categoryList!.length);
        CollectionReference expensesRef =
            FirebaseFirestore.instance.collection('expenses');
        QuerySnapshot querySnapshot = await expensesRef
            .where('categoryName', isEqualTo: categoryName)
            .where('budgetName', isEqualTo: budgetName)
            .where('userName', isEqualTo: user_info.getUsername())
            .get();

        print('After QuerySnapshot');

        List<DocumentSnapshot> expenseDocs = querySnapshot.docs;
        expenseDocs.forEach((document) {
          expenseValue = double.parse(document.get('expenseCost').toString()) +
              expenseValue;
        });

        print('After Map');
        print('ExpenseValue');
        print(expenseValue);
        collatedValues.add(expenseValue);
        print('CollatedValues[i]');
        print(collatedValues[i]);
    }
    print('Printing Collated Values');
    print(collatedValues);
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
                color: Colors.red,
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
                        flex: 8,
                        child: LinearProgressIndicator(
                          value: widget.budgetCardIndicatorValue,
                          backgroundColor: Colors.grey[300],
                          valueColor: AlwaysStoppedAnimation(Colors.grey[800]),
                        ),
                      ),
                      const SizedBox(
                        width: 20.0,
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          widget.budgetCardIndicatorValue.toString(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  Text(
                    widget.budgetSpent.toString(),
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    widget.budgetRemaining.toString(),
                    style: const TextStyle(
                      color: Colors.grey,
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
              color: Colors.blue,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20.0),
                bottomRight: Radius.circular(20.0),
              ),
            ),
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
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          widget.budgetStartDate.toString(),
                          style: const TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          widget.budgetEndDate.toString(),
                          style: const TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      color: widget.budgetStatusColor == "Colors.green"
                          ? Colors.green
                          : Colors.red,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(20.0),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 4.0,
                    ),
                    child: const Text(
                      'Status',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
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
              width: MediaQuery.sizeOf(context).width,
              height: 400.0,
              margin: EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'At A Glance',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.sizeOf(context).width,
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

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.budgetTitle.toString()),
      ),
      body: ListView(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _individualCardStateless(),
              //TODO: Implement Collaborator
              _pieChartWidget(),
            ],
          ),
        ],
      ),
    );
  }
}
