import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class CreateBudget extends StatefulWidget {
  CreateBudget({super.key})

  @override
  _CreateBudgetState createState() => _CreateBudgetState();
  }

class _CreateBudgetState extends State<CreateBudget> {

  //Writing Data
  void addData() async {
    CollectionReference budgets = FirebaseFirestore.instance.collection('budgets');
    CollectionReference user = FirebaseFirestore.instance.collection('users');
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}