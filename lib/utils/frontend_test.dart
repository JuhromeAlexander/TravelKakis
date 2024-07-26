import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FrontendTest extends StatelessWidget {
  String tempValue1 = '200';
  String tempValue2 = '90';
  String tempValue3 = '110';

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Container(
          width: MediaQuery.sizeOf(context).width,
          height: 150.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Category Name',
                style: TextStyle(
                  color: CupertinoColors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 8,
                    child: LinearProgressIndicator(
                      borderRadius:  BorderRadius.circular(20.0),
                      minHeight: 20,
                      value: 0.5,
                      backgroundColor: Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation(Colors.grey[800]),
                    ),
                  ),
                  const SizedBox(
                    width: 20.0,
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      '50%',
                    ),
                  ),
                ],
              ),
              Container(
                height: 20,
                width: MediaQuery.sizeOf(context).width,
              ),
              Text(
                'Total: \$${tempValue1}',
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w300,
                  color: CupertinoColors.black,
                ),
              ),
              Text(
                'Spent: \$${tempValue2}',
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w300,
                  color: CupertinoColors.black,
                ),
              ),
              Text(
                'Spent: \$${tempValue3}',
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w300,
                  color: CupertinoColors.black,
                ),
              ),
            ],
          ),
        )
    );
  }
}