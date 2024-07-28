import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:travel_kakis/features/budget/Budgets.dart';
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

class _DefineBudgetState extends State<DefineBudget> {

  List<DynamicCategoryCard> dynamicList = [];
  String documentID = '';


  DateTime returnDate(String date) {
    DateTime dateFormat = DateTime(int.parse(date.split('-')[0]),
        int.parse(date.split('-')[1]), int.parse(date.split('-')[2]));
    return dateFormat;
  }

  void updateBudget() async {
    List data = [];
    int budgetTotal = 0;

    for (int i = 0; i < dynamicList.length; i++) {
      data.add(dynamicList[i]._categoryBudget.text);
      budgetTotal = int.parse(dynamicList[i]._categoryBudget.text) + budgetTotal;
    }

    DocumentReference budgetRef = widget.budgetUID;
    await budgetRef.update({
      "budgetList": data,
      "totalBudget": budgetTotal,
      "budgetSpent": 0,
      "budgetCardIndicatorValue": 1.0
    });

    // Navigator.push(context, MaterialPageRoute(
    //     builder: (context) => const IndividualBudget())
    // );
  }

  void getBudgetData() {
    CollectionReference budget = FirebaseFirestore.instance.collection('budget');
    budget.doc(widget.budgetUID.id).get().then((document) {
      setState(() {
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => IndividualBudget(
              budgetTitle: document.get('budgetTitle'),
              budgetStartDate: returnDate(document.get('budgetStartDate')),
              budgetEndDate: returnDate(document.get('budgetEndDate')),
              totalBudget: document.get('totalBudget'),
              budgetSpent: document.get('budgetSpent'),
              budgetRemaining: document.get('totalBudget'),
              budgetCardIndicatorValue: document.get('budgetCardIndicatorValue'),
              budgetStatusColor:document.get('budgetStatusColor'),
              categoryList:document.get('categoryList'),
              userName: document.get('userName'),
            )),
        );
        // newBudget = Budgets(
        //     budgetTitle: document.get('budgetTitle'),
        //     budgetStartDate: document.get('budgetStartDate'),
        //     budgetEndDate: document.get('budgetEndDate'),
        //     totalBudget: document.get('totalBudget'),
        //     budgetSpent: document.get('budgetSpent'),
        //     budgetRemaining: document.get('totalBudget'),
        //     budgetStatusColor: document.get('budgetStatusColor'),
        //     budgetCardIndicatorValue: document.get('budgetCardIndicatorValue'),
        //     categoryList: document.get('categoryList'),
        //     userName: document.get('userName')
        // );
      });
    });


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
                  DynamicCategoryCard temp = DynamicCategoryCard(categoryTitle: widget.categories[index]);
                  dynamicList.add(temp);
                  return temp;
                }
            ),
          ),
          ElevatedButton(
            onPressed: () {
              updateBudget();
              getBudgetData();
            },
            child: const Text('Create Budget'),
            //child: Text(widget.budgetUID),
          ),
        ],
      ),
    );
  }

}