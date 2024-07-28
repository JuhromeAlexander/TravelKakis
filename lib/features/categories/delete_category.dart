import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:travel_kakis/utils/user_information.dart' as user_info;

import '../../models/Categories.dart';

class DeleteCategory extends StatefulWidget {

  DeleteCategory({super.key});

  @override
  _DeleteCategoryState createState() => _DeleteCategoryState();

}

class _DeleteCategoryState extends State<DeleteCategory> {
  List _selectedCategories = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {

    });
  }

  void _deleteCategory() async {
    List documentID = [];

    CollectionReference categoryRef = FirebaseFirestore.instance.collection('categories');

    for (int i = 0; i < _selectedCategories.length; i++) {
      QuerySnapshot querySnapshot = await categoryRef
          .where('userName', isEqualTo: user_info.getUsername())
          .where('categoryName', isEqualTo: _selectedCategories[i])
          .get();

      List<DocumentSnapshot> categoryDoc = querySnapshot.docs;
      for (int j = 0; j < categoryDoc.length; j++) {
        documentID.add(categoryDoc[j].id.toString());
      }
    }
    print(documentID);
    for (int i = 0; i < documentID.length; i++) {
      print(documentID[i]);
      categoryRef.doc(documentID[i]).delete();
    }

    Navigator.pop(context);
  }

  Future<List> getCategoryData() async {
    List<Categories> categoryList = [];

    CollectionReference categoryRef =
    FirebaseFirestore.instance.collection('categories');
    categoryRef.where('userName', isEqualTo: user_info.getUsername()).get().then(
            (querySnapshot) {
          for (var docSnapshot in querySnapshot.docs) {
            final data = docSnapshot.data() as Map<String, dynamic>;
            categoryList.add(Categories(
              categoryName: data['categoryName'].toString(),
              categoryType: data['categoryType'].toString(),
              categoryID: data['categoryID'].toString(),
            )
            );
          }
        }
    );
    return categoryList;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: const Text("Delete User Categories"),
      ),
      body: Container(
        padding: const EdgeInsets.all(10.0),
        child: FutureBuilder(
          future: getCategoryData(),
          builder: (context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return const CircularProgressIndicator();
            }
            if (snapshot.hasData) {
              List categoryData = snapshot.data;
              print('BeFORE DELETE PRINT CAT DATA');
              print(categoryData);
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: MultiSelectDialogField(
                      title: const Text('Select Categories'),
                      items: categoryData.map((category) {
                        return MultiSelectItem(
                          category.categoryName,
                          category.categoryName
                        );
                      }).toList(),
                      onConfirm: (values) {
                        _selectedCategories = values;
                      },
                      onSelectionChanged: (values) {
                        _selectedCategories = values;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            //TODO Set onPressed
                            _deleteCategory();
                          },
                          child: const Text('Delete')),
                      ],
                    ),
                  ),
                ],
              );
            }
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}