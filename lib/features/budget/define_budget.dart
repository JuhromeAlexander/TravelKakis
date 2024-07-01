import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:travel_kakis/features/budget/individual_budget.dart';

class DefineBudget extends StatefulWidget {
  List categories;
  DocumentReference budgetUID;
  DefineBudget({super.key, required this.categories, required this.budgetUID});

  @override
  _DefineBudgetState createState() => _DefineBudgetState();
}

class DynamicCategoryCard extends StatelessWidget {
  DynamicCategoryCard({super.key, required this.categoryTitle});
  String categoryTitle;
  final TextEditingController _categoryBudget = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      margin: new EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(categoryTitle),
          Padding(
            padding: EdgeInsets.only(top: 20.0),
            child: TextField(
              controller:  _categoryBudget,
              decoration: const InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey)
                ),
                hintText: 'Amount to Budget',
                hintStyle: TextStyle(color: Colors.grey)
              ),
            ),
          ),
        ],
      ),
    );
  }

}

class _DefineBudgetState extends State<DefineBudget> {

  List<DynamicCategoryCard> dynamicList = [];

  void updateBudget() {
    List data = [];
    int budgetTotal = 0;

    for (int i = 0; i < dynamicList.length; i++) {
      data.add(dynamicList[i]._categoryBudget.text);
      budgetTotal = int.parse(dynamicList[i]._categoryBudget.text) + budgetTotal;
    }

    DocumentReference budgetRef = widget.budgetUID;
    budgetRef.update({
      "budgetList": data,
      "totalBudget": budgetTotal,
      "budgetSpent": 0,
      "budgetCardIndicatorValue": 1.0
    });

    Navigator.push(context, MaterialPageRoute(
        builder: (context) => IndividualBudget())
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: const Text('Define Budgets'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: ListView.builder(
                itemCount: widget.categories.length,
                itemBuilder: (_, index) {
                  DynamicCategoryCard temp = new DynamicCategoryCard(categoryTitle: widget.categories[index]);
                  dynamicList.add(temp);
                  return temp;
                }
            ),
          ),
          ElevatedButton(
            onPressed: updateBudget,
            child: Text('Create Budget'),
            //child: Text(widget.budgetUID),
          ),
        ],
      ),
    );
  }

}