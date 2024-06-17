import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:travel_kakis/utils/bottom_navigation.dart';
import 'package:travel_kakis/utils/budget_card.dart';

class OverviewOfBudget extends StatefulWidget {
  const OverviewOfBudget({super.key});

  @override
  _OverviewOfBudgetState createState() => _OverviewOfBudgetState();
}

class _OverviewOfBudgetState extends State<OverviewOfBudget> {
  @override
  Widget build(BuildContext context) {
    // return Center(
    //   child: Text("overview Of Budgets!"),
    // );
    return Scaffold(
      body: BudgetCard(),
    );
  }

}
