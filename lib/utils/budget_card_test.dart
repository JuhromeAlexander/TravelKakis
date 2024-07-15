import 'package:flutter/material.dart';

class BudgetCardTest extends StatelessWidget {
  const BudgetCardTest({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Stack(
        children: [
          Container(
            height: 200.0,
            decoration: const BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
                bottomLeft: Radius.circular(20.0),
                bottomRight: Radius.circular(20.0),
              ),
            ),
            child: Container(
              margin: const EdgeInsets.only(
                top: 120.0,
                left: 20.0,
                right: 10.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 8,
                        child: LinearProgressIndicator(
                          value: getBudgetCardIndicatorValue(),
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
                          getBudgetCardIndicatorValueText(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  Text(
                    getBudgetCardSpent(),
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    getBudgetCardRemaining(),
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            //Contains Status Bar and Budget Title
            height: 100.0,
            decoration: const BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20.0),
                bottomRight: Radius.circular(20.0),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Text(
                          getBudgetCardTitle(),
                          style: const TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          getBudgetCardStartDate(),
                          style: const TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          getBudgetCardEndDate(),
                          style: const TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                      decoration: BoxDecoration(
                        color: getBudgetStatusColor(),
                        borderRadius: const BorderRadius.only(
                          //topRight: Radius.circular(20.0),
                          bottomLeft: Radius.circular(20.0),
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                      child: const Text(
                        'Status',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color getBudgetStatusColor() {
    return Colors.green;
  }

  String getBudgetCardTitle() {
    return 'Test Title';
  }

  double getBudgetCardIndicatorValue() {
    return 0.7;
  }

  String getBudgetCardIndicatorValueText() {
    return "70%";
  }

  String getBudgetCardSpent() {
    return 'Test Spent';
  }

  String getBudgetCardRemaining() {
    return 'Test Remaining';
  }

  String getBudgetCardStartDate() {
    return "Test Start Date";
  }

  String getBudgetCardEndDate() {
    return "Test End Date";
  }
}

// printCard() {
//   return FutureBuilder<List>(
//       future: getData(),
//       builder: (context, AsyncSnapshot snapshot) {
//         if (snapshot.hasData) {
//           List data = snapshot.data;
//           return Flexible(
//               child: ListView.builder(
//                   itemCount: data.length,
//                   itemBuilder: (context, index) {
//                     return InkWell(
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) => IndividualBudget()),
//                         );
//                       },
//                       child: Card(
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(20.0),
//                         ),
//                         child: Stack(
//                           children: [
//                             Container(
//                               height: 200.0,
//                               decoration: const BoxDecoration(
//                                 color: Colors.red,
//                                 borderRadius: BorderRadius.only(
//                                   topLeft: Radius.circular(20.0),
//                                   topRight: Radius.circular(20.0),
//                                   bottomLeft: Radius.circular(20.0),
//                                   bottomRight: Radius.circular(20.0),
//                                 ),
//                               ),
//                               child: Container(
//                                 margin: const EdgeInsets.only(
//                                   top: 120.0,
//                                   left: 20.0,
//                                   right: 10.0,
//                                 ),
//                                 child: Column(
//                                   crossAxisAlignment:
//                                   CrossAxisAlignment.start,
//                                   children: [
//                                     Row(
//                                       mainAxisAlignment:
//                                       MainAxisAlignment.start,
//                                       children: [
//                                         Expanded(
//                                           flex: 8,
//                                           child: LinearProgressIndicator(
//                                             value: data[index]
//                                                 .getBudgetCardIndicatorValue(),
//                                             backgroundColor: Colors.grey[300],
//                                             valueColor:
//                                             AlwaysStoppedAnimation(
//                                                 Colors.grey[800]),
//                                           ),
//                                         ),
//                                         SizedBox(
//                                           width: 20.0,
//                                         ),
//                                         Expanded(
//                                           flex: 1,
//                                           child: Text(
//                                             data[index]
//                                                 .getBudgetCardIndicatorValue(),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                     SizedBox(
//                                       height: 15.0,
//                                     ),
//                                     Text(
//                                       data[index].getBudgetSpent(),
//                                       style: TextStyle(
//                                         color: Colors.grey,
//                                       ),
//                                     ),
//                                     Text(
//                                       data[index].getBudgetRemaining(),
//                                       style: TextStyle(
//                                         color: Colors.grey,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                             Container(
//                               //Contains Status Bar and Budget Title
//                               height: 100.0,
//                               decoration: const BoxDecoration(
//                                 color: Colors.blue,
//                                 borderRadius: BorderRadius.only(
//                                   bottomLeft: Radius.circular(20.0),
//                                   bottomRight: Radius.circular(20.0),
//                                 ),
//                               ),
//                               child: Row(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Expanded(
//                                     flex: 3,
//                                     child: Column(
//                                       crossAxisAlignment:
//                                       CrossAxisAlignment.start,
//                                       children: [
//                                         Expanded(
//                                           flex: 1,
//                                           child: Text(
//                                             data[index].getBudgetTitle(),
//                                             style: const TextStyle(
//                                               color: Colors.grey,
//                                             ),
//                                           ),
//                                         ),
//                                         Expanded(
//                                           flex: 1,
//                                           child: Text(
//                                             data[index].getBudgetStartDate(),
//                                             style: const TextStyle(
//                                               color: Colors.grey,
//                                             ),
//                                           ),
//                                         ),
//                                         Expanded(
//                                           flex: 2,
//                                           child: Text(
//                                             data[index].getBudgetEndDate(),
//                                             style: const TextStyle(
//                                               color: Colors.grey,
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   Expanded(
//                                     flex: 1,
//                                     child: Container(
//                                       decoration: BoxDecoration(
//                                         color: data[index]
//                                             .getBudgetStatusColor(),
//                                         borderRadius: BorderRadius.only(
//                                           //topRight: Radius.circular(20.0),
//                                           bottomLeft: Radius.circular(20.0),
//                                         ),
//                                       ),
//                                       padding: EdgeInsets.symmetric(
//                                           horizontal: 8.0, vertical: 4.0),
//                                       child: Text(
//                                         'Status',
//                                         style: TextStyle(color: Colors.white),
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//                   }));
//         }
//         if (!snapshot.hasData) {
//           // return const Text(
//           //     'No Budgets! Add a Budget Now!'
//           // );
//           return Text(snapshot.data.length);
//         }
//         if (snapshot.hasError) {
//           return Text('Error Loading Budgets ${snapshot.error.toString()}');
//         }
//
//         return CircularProgressIndicator();
//       });
// }