
import 'package:flutter/material.dart';

class BudgetCard extends StatelessWidget {
  const BudgetCard({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      color: Colors.blue,
      child: Container(
        padding: const EdgeInsets.all(20.0),
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
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
                Positioned(
                  top: 0.0,
                  right: 0.0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: getBudgetStatusColor(),
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(20.0),
                        bottomLeft: Radius.circular(20.0),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                    child: const Text(
                      'Status',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            LinearProgressIndicator(
              value: getBudgetCardIndicatorValue(),
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation(Colors.grey[800]),
            ),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Spent:'),
                Text(getBudgetCardSpent()),
              ],
            ),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Remaining:'),
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