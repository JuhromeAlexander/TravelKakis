import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:travel_kakis/features/budget/create_budget.dart';
import 'package:travel_kakis/features/budget/overview_of_budget.dart';
import 'package:travel_kakis/features/categories/add_category.dart';
import 'package:travel_kakis/features/categories/overview_categories.dart';
import 'package:travel_kakis/features/profile_page/profile.dart';
import 'package:travel_kakis/features/profile_page/profile_setting.dart';
import 'package:travel_kakis/features/suggestions/overview_of_suggestions.dart';
import 'package:travel_kakis/temp_for_add.dart';
import 'package:travel_kakis/utils/bottom_navigation.dart';
import 'package:travel_kakis/features/trips/overview_of_trips.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
//anything after this is to be removed after finish testing
import 'package:travel_kakis/features/trips/create_trip.dart';
import 'package:travel_kakis/features/trips/individual_trip.dart';
import 'package:travel_kakis/features/activity/weather_details.dart';


//This class controls the flow of the pages (i.e it contains bottom nav & screens

class HomePage extends StatefulWidget {

  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //current page for bottom nav
  int currentPageIndex = 0;

  callback() {
    setState(() {});
  }

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
      //sticks the floating action button to the bottom of the phone when keyboard appears
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('TravelKakis'),
        actions: [
          IconButton(
            onPressed: signUserOut,
            icon: Icon(Icons.logout),
          )
        ],
      ),
      //extended floating action button
      floatingActionButton: SpeedDial(
        backgroundColor: Colors.blue,
        spaceBetweenChildren: 10,
        spacing: 10,
        icon: Icons.add,
        children: [
          SpeedDialChild(
            child: Icon(Icons.airplanemode_active),
            label: 'Create Trip',
            onTap: (){
              _navigateToCreateTrip(context, callback);
            }
          ),
          SpeedDialChild(
              child: Icon(Icons.attach_money),
              label: 'Create budget',
              onTap: (){
                _navigateToCreateBudget(context);
              }
          )
        ],
      ),


      bottomNavigationBar: bottomNavigation(
          currentIndex: currentPageIndex,
          onClicked: botNavOnClick
      ),
      body: <Widget>[
        OverviewOfTrips(),
        OverviewOfBudget(),
        WeatherDetails(),
        // AddCategory(),
        Profile()
      ][currentPageIndex],
    );
  }
}

//navigate to create trip
void _navigateToCreateTrip(context, callback) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => CreateTrip(callback: callback,)),
  );
}

void _navigateToCreateBudget(context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => CreateBudget()),
  );
}
