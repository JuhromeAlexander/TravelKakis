import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:travel_kakis/utils/user_information.dart' as user_info;

class AddCategory extends StatefulWidget{

  AddCategory({super.key});

  @override
  _AddCategoryState createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  final TextEditingController _categoryTypeController = TextEditingController();
  final TextEditingController _categoryNameController = TextEditingController();

  late var _selectedCategoryType;
  
  void addCategory() async {
    CollectionReference categories = FirebaseFirestore.instance.collection('categories');

    await categories.add({
      'categoryName': _categoryNameController.text.toString(),
      'categoryType': _selectedCategoryType,
      'userName': user_info.getUsername()
    }).then((value) {
      categories.doc(value.id.toString()).update({
        'categoryID': value,
      });
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
              onPressed: addCategory,
                child: const Text('Create Category')
            ),
          ],
        ),
      ),
    );
  }
}