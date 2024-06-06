import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class bottomNavigation extends StatelessWidget {
  final selectedIndex;
  ValueChanged<int> onClicked;
  //constructor for bottom navigation
  bottomNavigation({this.selectedIndex, required this.onClicked});

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      //changes which page it be at
      onDestinationSelected: (int index) {
        onClicked(index);
      },
      indicatorColor: Colors.blueAccent,
      selectedIndex: selectedIndex,
      destinations: const <Widget>[
        //home page
        NavigationDestination(
          selectedIcon: Icon(Icons.home),
          icon: Icon(Icons.home_outlined),
          label: 'Home',
        ),
        //budget page
        NavigationDestination(
          icon: Icon(Icons.attach_money),
          label: 'Budget',
        ),
        //for the add function
        NavigationDestination(
          icon:  Icon(Icons.add),
          label: 'Add',
        ),
        //profile page
        NavigationDestination(
          icon: Icon(Icons.account_circle_rounded),
          label: 'Profile',
        ),
      ],
    );
  }
}
