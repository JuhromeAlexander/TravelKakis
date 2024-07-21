import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:travel_kakis/features/budget/individual_budget.dart';
import 'package:travel_kakis/utils/user_information.dart' as user_info;
import 'package:travel_kakis/features/budget/Budgets.dart';

class OverviewOfBudget extends StatefulWidget {
  const OverviewOfBudget({super.key});

  @override
  _OverviewOfBudgetState createState() => _OverviewOfBudgetState();
}

class _OverviewOfBudgetState extends State<OverviewOfBudget> {
  Color getBudgetStatusIndicator(String data) {
    if (data == "Colors.green") {
      return Colors.green;
    } else {
      return Colors.red;
    }
  }

  Future<List> getData() async {
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
    print('After GetUsert');
    for (int i = 0; i < refLength; i++) {
      await budgetDoc[i].get().then((DocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;
        print(data['categoryList']);
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
      print(i);
    }
    print(budgetList);
    return budgetList;
  }

  DateTime returnDate(String date) {
    DateTime dateFormat = DateTime(int.parse(date.split('-')[0]),
        int.parse(date.split('-')[1]), int.parse(date.split('-')[2]));
    return dateFormat;
  }

  Widget _individualCard(context, data) {
    return ListView.separated(
        itemBuilder: (context, index) {
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => IndividualBudget(
                          budgetTitle: data[index].getBudgetTitle(),
                          budgetStartDate:
                              returnDate(data[index].getBudgetStartDate()),
                          budgetEndDate:
                              returnDate(data[index].getBudgetEndDate()),
                          totalBudget: data[index].getTotalBudget(),
                          budgetSpent: data[index].getBudgetSpent(),
                          budgetRemaining: data[index].getBudgetRemaining(),
                          budgetCardIndicatorValue:
                              data[index].getBudgetCardIndicatorValue(),
                          budgetStatusColor: data[index].getBudgetStatusColor(),
                          categoryList: data[index].getCategoryList())),
                );
              },
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
                      ),
                    ),
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
                                  value: data[index].getBudgetCardIndicatorValue(),
                                  backgroundColor: Colors.grey[300],
                                  valueColor:
                                      AlwaysStoppedAnimation(Colors.grey[800]),
                                ),
                              ),
                              const SizedBox(
                                width: 20.0,
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(
                                  data[index].getBudgetCardIndicatorValue().toString(),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 15.0,
                          ),
                          Text(
                            data[index].getBudgetSpent().toString(),
                            style: const TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            data[index].getBudgetRemaining().toString(),
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
                                  data[index].getBudgetTitle(),
                                  style: const TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(
                                  data[index].getBudgetStartDate(),
                                  style: const TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  data[index].getBudgetEndDate(),
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
                                color: data[index].getBudgetStatusColor() == "Colors.green" ? Colors.green : Colors.red,
                                borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(20.0),
                                )
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
            ),
          );
        },
        separatorBuilder: (context, index) {
          return const Divider();
        },
        itemCount: data.length);
  }

  printCard() {
    return FutureBuilder(
        future: getData(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            List data = snapshot.data!;
            return Flexible(child: _individualCard(context, data));
          }
          if (!snapshot.hasData) {
            return const Text('No Budgets, add one now!');
          }
          if (snapshot.hasError) {
            return Text('Error Loading Budgets ${snapshot.error.toString()}');
          }
          return const CircularProgressIndicator();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          printCard(),
        ],
      ),
    );
  }
}
