import 'package:flutter/material.dart';

class IndividualBudget extends StatefulWidget {
  final String? budgetTitle;
  final DateTime? budgetStartDate;
  final DateTime? budgetEndDate;
  final int? totalBudget;
  final int? budgetSpent;
  final int? budgetRemaining;
  final double? budgetCardIndicatorValue;
  final String? budgetStatusColor;
  final List? categoryList;

  const IndividualBudget({
    super.key,
    this.budgetTitle,
    this.budgetStartDate,
    this.budgetEndDate,
    this.totalBudget,
    this.budgetSpent,
    this.budgetRemaining,
    this.budgetCardIndicatorValue,
    this.budgetStatusColor,
    this.categoryList,
  });

  @override
  _IndividualBudgetState createState() => _IndividualBudgetState();
}

class _IndividualBudgetState extends State<IndividualBudget> {
  // Reading the Data from Budget Collection

  // Future<List> getExpensesData(List expensesData) async {
  //   int expensesLength = expensesData.length;
  //
  //   for (int i = 0; i < expensesLength; i++) {
  //     await expensesData[i].get().then((DocumentSnapshot doc) {
  //       if (doc.exists) {
  //         final data = doc.data() as Map<Expenses, Expenses>;
  //         expenses.add()
  //       }
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.budgetTitle.toString()),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Row(
              children: [
                const Text(
                  'Total Budget:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  widget.totalBudget.toString(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Row(
              children: [
                const Text(
                  'Budget Remaining:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  widget.budgetRemaining.toString(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Row(
              children: [
                const Text(
                  'Categories',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  widget.categoryList.toString(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
