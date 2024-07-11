import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BudgetCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      color: Colors.blue,
      child: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      getBudgetCardTitle(),
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
                Positioned(
                  top: 0.0,
                  right: 0.0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: getBudgetStatusColor(),
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20.0),
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
            SizedBox(height: 16.0),
            LinearProgressIndicator(
              value: getBudgetCardIndicatorValue(),
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation(Colors.grey[800]),
            ),
            SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Spent:'),
                Text(getBudgetCardSpent()),
              ],
            ),
            SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Remaining:'),
                Text(getBudgetCardRemaining()),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // TODO: Get Data From Firebase 
  Color getBudgetStatusColor() {
    return Colors.green;
  }

  String getBudgetCardTitle() {
    return 'Test Title';
  }

  double getBudgetCardIndicatorValue() {
    return 0.7;
  }

  String getBudgetCardSpent() {
    return 'Test Spent';
  }

  String getBudgetCardRemaining() {
    return 'Test Remaining';
  }

}