import 'package:flutter/material.dart';

class bottomNavigation extends StatelessWidget {
  int currentIndex;
  /*
  used valuechanged instead of valueSetter
  value setter ->  callback is called even if the underlying value has not changed
  valueChange might lead to a better performance (?)
   */
  ValueChanged<int> onClicked;

  //constructor for bottom navigation
  bottomNavigation({super.key, required this.currentIndex, required this.onClicked});

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      //changes which page it be at
      onDestinationSelected: (int index) {
        onClicked(index);
      },
      indicatorColor: Colors.blueAccent,
      selectedIndex: currentIndex,
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
        //floating action button
        NavigationDestination(
          icon: Icon(Icons.cloud),
          label: 'Weather',
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
