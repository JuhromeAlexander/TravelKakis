import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:travel_kakis/utils/bottom_navigation.dart';
import 'package:travel_kakis/utils/budget_card.dart';
import 'package:travel_kakis/utils/budget_card_test.dart';

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
    FirebaseAuth auth = FirebaseAuth.instance;

    User? currentUser = auth.currentUser;
    final uid = currentUser?.uid;

    CollectionReference users = db.collection('users');
    DocumentReference specificUser = users.doc(uid);

    await specificUser.get().then((DocumentSnapshot doc) {
      final data = doc.data() as Map<dynamic, dynamic>;
      refLength = data['budget'].length;
      budgetDoc = data['budget'];
    });

    for (int i = 0; i < refLength; i++) {
      await budgetDoc[i].get().then((DocumentSnapshot doc) {
        final data = doc.data() as Map<dynamic, dynamic>;
        budgetList.add(Budgets(

        ));
      });
    }

    return budgetList;
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
