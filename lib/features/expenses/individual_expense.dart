import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Expense.dart';

class IndividualExpense extends StatefulWidget{

  Expense indivExpense;
  IndividualExpense({
    super.key,
    required this.indivExpense
  });

  @override
  _IndividualExpenseState createState() => _IndividualExpenseState();
}

class _IndividualExpenseState extends State<IndividualExpense> {

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Individual Expense Details'),
      ),
      body: Container(
        margin: EdgeInsets.all(10.0),
        height: MediaQuery.sizeOf(context).height,
        width: MediaQuery.sizeOf(context).width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(
                top: 25.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    'Expense Name:',
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 18.0,
                      color: CupertinoColors.black,
                    ),
                  ),
                  Container(
                    width: MediaQuery.sizeOf(context).width,
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 3.0,
                        style: BorderStyle.solid,
                        color: CupertinoColors.black
                      )
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text(
                        widget.indivExpense.expenseName,
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: CupertinoColors.black,
                        ),
                      ),
                    )
                  )
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(
                top: 25.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    'Expense Description:',
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 18.0,
                      color: CupertinoColors.black,
                    ),
                  ),
                  Container(
                      width: MediaQuery.sizeOf(context).width,
                      height: 150.0,
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: 3.0,
                              style: BorderStyle.solid,
                              color: CupertinoColors.black
                          )
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          widget.indivExpense.expenseDesc,
                          style: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: CupertinoColors.black,
                          ),
                          maxLines: 15,
                        ),
                      )
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(
                top: 25.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    'Expense Cost:',
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 18.0,
                      color: CupertinoColors.black,
                    ),
                  ),
                  Container(
                      width: MediaQuery.sizeOf(context).width,
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: 3.0,
                              style: BorderStyle.solid,
                              color: CupertinoColors.black
                          )
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          widget.indivExpense.expenseCost,
                          style: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: CupertinoColors.black,
                          ),
                        ),
                      )
                  )
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(
                top: 25.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    'Budget Name:',
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 18.0,
                      color: CupertinoColors.black,
                    ),
                  ),
                  Container(
                      width: MediaQuery.sizeOf(context).width,
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: 3.0,
                              style: BorderStyle.solid,
                              color: CupertinoColors.black
                          )
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          widget.indivExpense.budgetName,
                          style: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: CupertinoColors.black,
                          ),
                        ),
                      )
                  )
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(
                top: 25.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    'Category Name:',
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 18.0,
                      color: CupertinoColors.black,
                    ),
                  ),
                  Container(
                      width: MediaQuery.sizeOf(context).width,
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: 3.0,
                              style: BorderStyle.solid,
                              color: CupertinoColors.black
                          )
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          widget.indivExpense.categoryName,
                          style: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: CupertinoColors.black,
                          ),
                        ),
                      )
                  )
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(
                top: 25.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    'Expense Type:',
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 18.0,
                      color: CupertinoColors.black,
                    ),
                  ),
                  Container(
                      width: MediaQuery.sizeOf(context).width,
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: 3.0,
                              style: BorderStyle.solid,
                              color: CupertinoColors.black
                          )
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          widget.indivExpense.expenseType,
                          style: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: CupertinoColors.black,
                          ),
                        ),
                      )
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}