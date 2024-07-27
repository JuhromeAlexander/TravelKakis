import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:travel_kakis/utils/user_information.dart' as user_info;

class EditCategory extends StatefulWidget {
  String categoryTitle;
  String categoryType;
  EditCategory({
    super.key,
    required this.categoryTitle,
    required this.categoryType,
  });

  @override
  _EditCategoryState createState() => _EditCategoryState();
}

class _EditCategoryState extends State<EditCategory> {
  final TextEditingController _categoryTypeController = TextEditingController();
  late TextEditingController _categoryNameController = TextEditingController(text: widget.categoryTitle);

  late var _selectedCategoryType;

  void _editCategory() async {
    String documentID = '';
    CollectionReference category = FirebaseFirestore.instance.collection('categories');
    QuerySnapshot querySnapshot = await category
      .where('userName', isEqualTo: user_info.getUsername())
      .where('categoryName', isEqualTo: widget.categoryTitle)
      .get();

    List<DocumentSnapshot> categoryDoc = querySnapshot.docs;
    print("DEBUG EDITING");
    print(categoryDoc.length);
    for (int i = 0; i < categoryDoc.length; i++) {
      documentID = categoryDoc[i].id.toString();
    }

    category.doc(documentID).update({
      'categoryName': _categoryNameController.text,
      'categoryType': _selectedCategoryType,
    });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Category'),
      ),
      body: Container(
        width: MediaQuery.sizeOf(context).width,
        height: MediaQuery.sizeOf(context).height,
        margin: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _categoryNameController,
              decoration: const InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: CupertinoColors.systemGrey),
                ),
                hintText: 'Category Name',
                hintStyle: TextStyle(
                  color: CupertinoColors.systemGrey,
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.sizeOf(context).width,
              height: 30.0,
            ),
            DropdownMenu(
                width: MediaQuery.sizeOf(context).width - 40,
                controller: _categoryTypeController,
                label: const Text('Select Category Type'),
                onSelected: (value) {
                  setState(() {
                    _selectedCategoryType = value;
                  });
                },
                initialSelection: widget.categoryType,
                dropdownMenuEntries: const [
                  DropdownMenuEntry(
                      value: 'Income',
                      label: 'Income'
                  ),
                  DropdownMenuEntry(
                      value: 'Expense',
                      label: 'Expense'
                  )
                ]
            ),
            SizedBox(
              width: MediaQuery.sizeOf(context).width,
              height: 30.0,
            ),
            TextButton(
                onPressed: _editCategory,
                child: const Text('Edit Category')
            ),
          ],
        ),
      ),
    );
  }
}