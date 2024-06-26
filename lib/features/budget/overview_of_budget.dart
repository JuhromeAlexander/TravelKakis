import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:travel_kakis/utils/bottom_navigation.dart';
import 'package:travel_kakis/utils/budget_card.dart';
import 'package:travel_kakis/utils/budget_card_test.dart';
import 'package:travel_kakis/utils/user_information.dart' as user_info;

import 'Budgets.dart';

class OverviewOfBudget extends StatefulWidget {
  const OverviewOfBudget({super.key});

  @override
  _OverviewOfBudgetState createState() => _OverviewOfBudgetState();
}

class _OverviewOfBudgetState extends State<OverviewOfBudget> {

  Future<List> getData() async {
    List budgetDoc = [];
    List budgetList = [];
    int refLength = 0;

    //Grabbing the Budgets that belongs to the user
    FirebaseFirestore db = FirebaseFirestore.instance;

    CollectionReference users = db.collection('users');
    DocumentReference specificUser = users.doc(user_info.getID());
    await specificUser.get().then((DocumentSnapshot doc) {
      final data = doc.data() as Map<dynamic, dynamic>;
      refLength = data['budget'].length;
      budgetDoc = data['budget'];
    });

    for (int i = 0; i < refLength; i++) {
      await budgetDoc[i].get().then((DocumentSnapshot doc) {
        final data = doc.data() as Map<dynamic, dynamic>;
        budgetList.add(Budgets(
          budgetTitle: data['budgetTitle'].toString(),
          budgetStartDate: data['budgetStartDate'].toString(),
          budgetEndDate: data['budgetEndDate'].toString(),
          totalBudget: data['totalBudget'],
          budgetSpent: data['budgetSpent'],
          budgetRemaining: data['totalBudget'] - data['budgetSpent'],
          budgetCardIndicatorValue: data['budgetSpent'] / data['totalBudget'],
          budgetStatusColor: Colors.green,
          expensesList: data['expenses'],
          categoryList: data['categories']
        ));
      });
    }
    return budgetList;
  }

  printCard() {
    return FutureBuilder<List>(
        future: getData(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            List data = snapshot.data;
            return Flexible(
                child: ListView.builder(
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => IndividualBudget(
                              expensesList: data[index].getExpensesList(),
                              categoryList: data[index].getCategoryList(),
                            )),
                          );
                        },
                        child: Card(
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
                                              valueColor: AlwaysStoppedAnimation(Colors.grey[800]),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 20.0,
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Text(
                                              data[index].getBudgetCardIndicatorValue(),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 15.0,
                                      ),
                                      Text(
                                        data[index].getBudgetSpent(),
                                        style: TextStyle(
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Text(
                                        data[index].getBudgetRemaining(),
                                        style: TextStyle(
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
                                          color: data[index].getBudgetStatusColor(),
                                          borderRadius: BorderRadius.only(
                                            //topRight: Radius.circular(20.0),
                                            bottomLeft: Radius.circular(20.0),
                                          ),
                                        ),
                                        padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                                        child: Text(
                                          'Status',
                                          style: TextStyle(color: Colors.white),
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
                    }
                )
            );
          }
          if (!snapshot.hasData) {
            return const Text(
                'No Budgets! Add a Budget Now!'
            );
          }

          if (snapshot.hasError) {
            return Text(
              'Error Loading Budgets ${snapshot.error.toString()}'
            );
          }

          return CircularProgressIndicator();
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    // return Center(
    //   child: Text("overview Of Budgets!"),
    // );
    return Scaffold(
      body: BudgetCardTest(),
    );
  }

}
