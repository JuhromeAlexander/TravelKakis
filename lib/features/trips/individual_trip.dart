import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travel_kakis/features/activity/activity.dart';
import 'package:travel_kakis/features/activity/individual_activity.dart';
import 'package:travel_kakis/features/activity/create_activity.dart';

class IndividualTrip extends StatefulWidget {
  final Function overviewTripCallback;
  final DateTime startDate;
  final DateTime endDate;
  final List activities;
  final String tripTitle;
  final DocumentSnapshot tripDocumentSnapshot;

  const IndividualTrip({
    super.key,
    required this.startDate,
    required this.endDate,
    required this.activities,
    required this.tripTitle,
    required this.overviewTripCallback,
    required this.tripDocumentSnapshot,
  });

  @override
  _IndividualTripState createState() => _IndividualTripState();
}

class _IndividualTripState extends State<IndividualTrip> {
  //delete trip
  void _deleteCurrentActivity(String activityDocumentID, data, index) async {
    //TODO: give warning when deleting & delete

    //delete all the activites that is tagged to this trip

    //1. get the collection of trips
    CollectionReference activity =
        FirebaseFirestore.instance.collection('activity');
    CollectionReference trip = FirebaseFirestore.instance.collection('trips');

    //2. delete the element from the current trip array
    String tripID = data[index].getTripID;
    trip.doc(tripID).update({
      'activities':
          FieldValue.arrayRemove(data[index].getTripDocumentReference()),
    });

    //3. delete that specific activity
    await activity.doc(activityDocumentID).delete();
  }

  late Future<List> _getData = getData();

  List currentActivityList = [];

  callback() {
    activities.clear();
    widget.overviewTripCallback();
    setState(() {
      _getData = getData();
    });
  }

  //for dropdown
  List<DropdownMenuItem<String>> dropdownItems = [];
  String currentItem = "";

  @override
  void initState() {
    super.initState();
    List<DateTime> listOfDays = getDays(widget.startDate, widget.endDate);

    dropdownItems = List.generate(
      listOfDays.length,
      (index) => DropdownMenuItem(
        value: listOfDays[index].toString().split(' ')[0],
        child: Text(
          listOfDays[index].toString().split(' ')[0],
        ),
      ),
    );
    currentItem = listOfDays[0].toString().split(' ')[0];
  }

  // Reading the data from trip collection
  List activities = [];

  // Future<List> getData(List activityData) async {
  Future<List> getData() async {
    //get the document snapshot of the current trip
    final currentTrip =
        widget.tripDocumentSnapshot.data() as Map<String, dynamic>;

    //get the List of the activityData
    List activityData = currentTrip['activities'];

    //get the length of the list
    int activitylength = activityData.length;

    for (int i = 0; i < activitylength; i++) {
      await activityData[i].get().then((DocumentSnapshot doc) {
        if (doc.exists) {
          final data = doc.data() as Map<String, dynamic>;
          if (data['date'].toString() == currentItem) {
            activities.add(activity(
              activityDocumentReference: activityData[i],
              tripID: data['tripID'].toString(),
              documentID: doc.reference.id.toString(),
              activityTitle: data['title'].toString(),
              activityTime: data['time'].toString(),
              activityDate: data['date'].toString(),
              documentSnapshot: doc,
            ));
          }
        }
      });
    }
    return activities;
  }

  //Testing purpose
  //TODO: to remove after testing deletion
  void _showToast(BuildContext context, String value) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(value),
      ),
    );
  }

  _individualTile(context, currentActivityList) {
    return ListView.separated(
        itemBuilder: (context, index) {
          return ListTile(
            trailing: PopupMenuButton<int>(
                onSelected: (value) {},
                itemBuilder: (BuildContext context) {
                  // Define the menu items for the PopupMenuButton
                  return <PopupMenuEntry<int>>[
                    PopupMenuItem<int>(
                      onTap: () => _deleteCurrentActivity(
                          currentActivityList[index]
                              .getActivityDocumentReference()
                              .toString(),
                          currentActivityList,
                          index),

                      // () => _showToast(context, currentActivityList[index].getActivityDocumentReference().toString()),
                      // value: ,
                      child: const Text("Delete"),
                    ),
                  ];
                }),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => IndividualActivity(
                        documentSnapshot:
                            currentActivityList[index].getDocumentSnapshot())),
              );
            },
            title: Text(
              currentActivityList[index].getActivityTitle(),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
                '${currentActivityList[index].getActivityDate()}, ${currentActivityList[index].getActivityTime()}'),
          );
        },
        separatorBuilder: (context, index) {
          return const Divider();
        },
        itemCount: currentActivityList.length);
  }

  //show all the activities
  printCard(data) {
    return FutureBuilder<List>(
        future: data,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            // return _build;
          }
          //if there's data, show it
          if (snapshot.hasError) {
            return Text('Error loading activity ${snapshot.error.toString()}');
          } else if (!snapshot.hasData) {
            return const Text('No activity, add some!');
          }
          if (snapshot.hasData) {
            return Flexible(child: _individualTile(context, snapshot.data));
          }
          //when waiting to retrieve the data
          return const CircularProgressIndicator();
        });
  }

  //get back the days for dropdown
  List<DateTime> getDays(DateTime start, DateTime end) {
    final days = end.difference(start).inDays;
    return [for (int i = 0; i <= days; i++) start.add(Duration(days: i))];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.tripTitle),
        actions: [
          DropdownButton<String>(
            value: currentItem,
            items: dropdownItems,
            onChanged: (value) {
              setState(() {
                //set the current selected item to what the user pressed
                currentItem = value.toString();
                //re-set the data with the updated data
                _getData = getData();
                //clear the activity list to be repopulated with what the user pressed
                activities.clear();
              });
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blue,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CreateActivity(
                      documentSnapshot: widget.tripDocumentSnapshot,
                      startDate: widget.startDate,
                      callback: callback)),
            ).then((_) => callback());
          },
          shape: const CircleBorder(),
          child: const Icon(Icons.add)),
      body: Column(
        children: <Widget>[
          //top half
          //bottom half
          Expanded(
              flex: 7,
              child: SizedBox(
                  height: double.infinity,
                  child: Column(children: <Widget>[
                    printCard(_getData),
                  ]))),
        ],
      ),
    );
  }
}

//navigate to create activity
// void _navigateToCreateActivity(
//   context, DocumentSnapshot docSnapshot, Function callback) {
//
//
//
// Navigator.push(
//   context,
//   MaterialPageRoute(
//       builder: (context) =>
//           CreateActivity(documentSnapshot: docSnapshot, callback: callback)),
// ).then((_) => setState(() {}));
// }
