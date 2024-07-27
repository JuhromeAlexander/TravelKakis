import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import '../../models/Categories.dart';

class OverviewCategories extends StatefulWidget {
  OverviewCategories({super.key});

  @override
  _OverviewCategoriesState createState() => _OverviewCategoriesState();
}

class _OverviewCategoriesState extends State<OverviewCategories> {

  //Widgets for Income and Expenses
  Future<List> getIncomeCategoryData() async {
    List<Categories> categoryList = [];

    CollectionReference categoryRef =
    FirebaseFirestore.instance.collection('categories');
    QuerySnapshot querySnapshot = await categoryRef
        .where('categoryType', isEqualTo: 'Income')
        .get();

    List<DocumentSnapshot> categoryDocs = querySnapshot.docs;

    for (int i = 0; i < categoryDocs.length; i++) {
      final data = categoryDocs[i].data() as Map<String, dynamic>;
      categoryList.add(Categories(
        categoryName: data['categoryName'].toString(),
        categoryType: data['categoryType'].toString(),
        categoryID: data['categoryID'].toString()
      ));
    }
    return categoryList;
  }

  Widget _incomeCategory(context, data) {
    return ListView.separated(
      itemBuilder: (context, index) {
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Container(
            width: MediaQuery.sizeOf(context).width,
            height: 75.0,
            margin: const EdgeInsets.all(5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: Text(
                    data[index].getCategoryName(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                      color: CupertinoColors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      separatorBuilder: (context, index) {
        return Container(
          width: MediaQuery.sizeOf(context).width,
          height: 15.0,
        );
      },
      itemCount: data.length
    );
  }

  _printIncomeCategoryCards() {
    return SingleChildScrollView(
      child: Container(
        width: MediaQuery.sizeOf(context).width,
        height: MediaQuery.sizeOf(context).height,
        margin: EdgeInsets.all(20.0),
        child: FutureBuilder(
          future: getIncomeCategoryData(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              List data = snapshot.data;
              //return Flexible(child: _incomeCategory(context, data));
              return _incomeCategory(context, data);
            }
            if (!snapshot.hasData) {
              return const Text('No Categories Yet!');
            }
            if (snapshot.hasError) {
              return Text('Error Loading Categories ${snapshot.error.toString()}');
            }
            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }

  Future<List> getExpenseCategoryData() async {
    List<Categories> categoryList = [];

    CollectionReference categoryRef =
    FirebaseFirestore.instance.collection('categories');
    QuerySnapshot querySnapshot = await categoryRef
        .where('categoryType', isEqualTo: 'Expense')
        .get();

    List<DocumentSnapshot> categoryDocs = querySnapshot.docs;

    for (int i = 0; i < categoryDocs.length; i++) {
      final data = categoryDocs[i].data() as Map<String, dynamic>;
      categoryList.add(Categories(
          categoryName: data['categoryName'].toString(),
          categoryType: data['categoryType'].toString(),
          categoryID: data['categoryID'].toString()
      ));
    }
    return categoryList;
  }

  Widget _expenseCategory(context, data) {
    return ListView.separated(
        itemBuilder: (context, index) {
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Container(
              width: MediaQuery.sizeOf(context).width,
              height: 75.0,
              margin: const EdgeInsets.all(5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: Text(
                      data[index].getCategoryName(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                        color: CupertinoColors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        separatorBuilder: (context, index) {
          return Container(
            width: MediaQuery.sizeOf(context).width,
            height: 15.0,
          );
        },
        itemCount: data.length
    );
  }

  _printExpenseCategoryCards() {
    return SingleChildScrollView(
      child: Container(
        width: MediaQuery.sizeOf(context).width,
        height: MediaQuery.sizeOf(context).height,
        margin: EdgeInsets.all(20.0),
        child: FutureBuilder(
          future: getExpenseCategoryData(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              List data = snapshot.data;
              //return Flexible(child: _expenseCategory(context, data));
              return _expenseCategory(context, data);
            }
            if (!snapshot.hasData) {
              return const Text('No Categories Yet!');
            }
            if (snapshot.hasError) {
              return Text('Error Loading Categories ${snapshot.error.toString()}');
            }
            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          floatingActionButton: SpeedDial(
            backgroundColor: CupertinoColors.systemBlue,
            spaceBetweenChildren: 10,
            spacing: 10,
            icon: Icons.add,
            children: [
              SpeedDialChild(
                  child: const Icon(Icons.attach_money_sharp),
                  label: 'Add Category',
                  onTap: (){
                    //_navigateToCreateExpense(context);
                  }
              ),
              SpeedDialChild(
                  child: const Icon(Icons.attach_money_sharp),
                  label: 'Edit Category',
                  onTap: (){
                    //_navigateToCreateExpense(context);
                  }
              ),
              SpeedDialChild(
                  child: const Icon(Icons.attach_money_sharp),
                  label: 'Delete Category',
                  onTap: (){
                    //_navigateToCreateExpense(context);
                  }
              ),
            ],
          ),
          appBar: AppBar(
            bottom: const TabBar(
                tabs: [
                  Tab(text: 'Income', icon: Icon(Icons.attach_money_sharp),),
                  Tab(text: 'Expenses', icon: Icon(Icons.receipt),)
                ]
            ),
            title: Text('Categories'),
          ),
          body: TabBarView(
            children: [
              _printIncomeCategoryCards(),
              _printExpenseCategoryCards()
            ],
          ),
        ),
      ),
    );
  }
}