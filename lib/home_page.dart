import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:travel_kakis/features/budget/overview_of_budget.dart';
import 'package:travel_kakis/features/profile_page/profile.dart';
import 'package:travel_kakis/temp_for_add.dart';
import 'package:travel_kakis/utils/bottom_navigation.dart';
import 'package:travel_kakis/features/trips/overview_of_trips.dart';

//This class controls the flow of the pages (i.e it contains bottom nav & screens

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //current page for bottom nav
  int currentPageIndex = 0;

  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  //function for bottom Nav Bar
  void botNavOnClick(int index) {
    setState(() {
      currentPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: signUserOut,
            icon: Icon(Icons.logout),
          )
        ],
      ),
      bottomNavigationBar: bottomNavigation(
        selectedIndex: currentPageIndex,
          onClicked: botNavOnClick
      ),
      body: <Widget>[
        OverviewOfTrips(),
        OverviewOfBudget(),
        TempForAdd(),
        Profile()

      ][currentPageIndex],
    );

  }
}
