import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:travel_kakis/features/budget/overview_of_budget.dart';
import 'package:travel_kakis/home_page.dart';

import 'individual_budget.dart';

class EditDefineBudget extends StatefulWidget {

  List? categories;
  String? documentID;

  EditDefineBudget({
    super.key,
    this.categories,
    this.documentID,
  });

  @override
  _EditDefineBudgetState createState() => _EditDefineBudgetState();

}

class DynamicCategoryCard extends StatelessWidget {
  DynamicCategoryCard({super.key, required this.categoryTitle});
  String categoryTitle;
  final TextEditingController _categoryBudget = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      margin: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(categoryTitle),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
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

class _EditDefineBudgetState extends State<EditDefineBudget> {

  List<DynamicCategoryCard> dynamicList = [];

  void updateBudget() {
    List data = [];
    int budgetTotal = 0;

    for (int i = 0; i < dynamicList.length; i++) {
      data.add(dynamicList[i]._categoryBudget.text);
      budgetTotal = int.parse(dynamicList[i]._categoryBudget.text) + budgetTotal;
    }

    CollectionReference budget = FirebaseFirestore.instance.collection('budget');
    budget.doc(widget.documentID).update({
      'budgetList': data,
      'totalBudget': budgetTotal,
    });

    Navigator.push(context, MaterialPageRoute(
        builder: (context) => const HomePage())
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: const Text('Define/Edit Budgets'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: widget.categories?.length,
              itemBuilder: (_, index) {
                DynamicCategoryCard temp = DynamicCategoryCard(categoryTitle: widget.categories?[index]);
                dynamicList.add(temp);
                return temp;
              },
            ),
          ),
          ElevatedButton(
            onPressed: updateBudget,
            child: const Text('Update Budget')
          ),
        ],
      ),
    );
  }
}