import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class bottomNavigation extends StatelessWidget {
  final selectedIndex;
  ValueChanged<int> onClicked;
  //constructor for bottom navigation
  //onClick function MUST be place in every page that requires bottom nav bar
  bottomNavigation({this.selectedIndex, required this.onClicked});

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      onDestinationSelected: (int index) {

        onClicked(index);
      },
      indicatorColor: Colors.blueAccent,
      selectedIndex: selectedIndex,
      destinations: const <Widget>[
        NavigationDestination(
          selectedIcon: Icon(Icons.home),
          icon: Icon(Icons.home_outlined),
          label: 'Home',
        ),
        NavigationDestination(
          icon:  Icon(Icons.add),
          label: 'Add',
        ),
        NavigationDestination(
          icon: Icon(Icons.account_circle_rounded),
          label: 'Profile',
        ),
      ],
    );
  }
}
