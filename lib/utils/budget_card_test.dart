import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class BudgetCardTest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Card(
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
                          value: getBudgetCardIndicatorValue(),
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
                          getBudgetCardIndicatorValueText(),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  Text(
                    getBudgetCardSpent(),
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    getBudgetCardRemaining(),
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
                          getBudgetCardTitle(),
                          style: const TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          getBudgetCardStartDate(),
                          style: const TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          getBudgetCardEndDate(),
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
                        color: getBudgetStatusColor(),
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
    );
  }

  Color getBudgetStatusColor() {
    return Colors.green;
  }

  String getBudgetCardTitle() {
    return 'Test Title';
  }

  double getBudgetCardIndicatorValue() {
    return 0.7;
  }

  String getBudgetCardIndicatorValueText() {
    return "70%";
  }

  String getBudgetCardSpent() {
    return 'Test Spent';
  }

  String getBudgetCardRemaining() {
    return 'Test Remaining';
  }

  String getBudgetCardStartDate() {
    return "Test Start Date";
  }

  String getBudgetCardEndDate() {
    return "Test End Date";
  }
}