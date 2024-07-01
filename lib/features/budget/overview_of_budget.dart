import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:travel_kakis/features/budget/individual_budget.dart';
import 'package:travel_kakis/utils/bottom_navigation.dart';
import 'package:travel_kakis/utils/budget_card.dart';
import 'package:travel_kakis/utils/budget_card_test.dart';
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
      print(data['budgets']);
      print(refLength);
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
            budgetCardIndicatorValue: (data['budgetSpent'] / data['totalBudget']) * 100,
            budgetStatusColor: data['budgetStatusColor'],
            categoryList: data['categoryList']
        ));
      });
    }
    print("hello");
    print(budgetList);
    return budgetList;
  }

  DateTime returnDate(String date) {

    DateTime dateFormat = DateTime(
        int.parse(date.split('-')[0]),
        int.parse(date.split('-')[1]),
        int.parse(date.split('-')[2]));

    return dateFormat;
  }

  _individualTile(context, data) {
    return ListView.separated(
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => IndividualBudget(
                        budgetTitle: data[index].getBudgetTitle(),
                        budgetStartDate: returnDate(data[index].getBudgetStartDate()),
                        budgetEndDate: returnDate(data[index].getBudgetEndDate()),
                        totalBudget: data[index].getTotalBudget(),
                        budgetSpent: data[index].getBudgetSpent(),
                        budgetRemaining: data[index].getBudgetRemaining(),
                        budgetCardIndicatorValue:
                             data[index].getBudgetCardIndicatorValue(),
                        budgetStatusColor: data[index].getBudgetStatusColor(),
                        categoryList: data[index].getCategoryList()
                )),
              );
            },
            title: Text(
              data[index].getBudgetTitle(),
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              data[index].getTotalBudget().toString(),
            ),
          );
        },
        separatorBuilder: (context, index) {
          return Divider();
        },
        itemCount: data.length);
  }

  printCard() {
    return FutureBuilder(
      future: getData(),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          List data = snapshot.data;
          return Flexible(
            child: _individualTile(context, data)
          );
        }
        if (!snapshot.hasData) {
          return const Text('No Budgets, add one now!');
        }
        if (snapshot.hasError) {
          return Text('Error Loading Budgets ${snapshot.error.toString()}');
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
      body: Column(
        children: <Widget>[
          printCard(),
        ],
      ),
    );
  }
}
