import 'package:flutter/material.dart';
import 'package:travel_kakis/features/trips/Trips.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travel_kakis/features/trips/individual_trip.dart';
import 'package:travel_kakis/utils/user_information.dart' as user_info;

class OverviewOfTrips extends StatefulWidget {
  const OverviewOfTrips({super.key});

  @override
  _OverviewOfTripsState createState() =>_OverviewOfTripsState();
}

class _OverviewOfTripsState extends State<OverviewOfTrips> {
  overviewTripCallback() {
    setState(() {});
  }

  void deleteTrip(tripData) async {
    toastMessage(
        context, "Trip: ${tripData.getTripTitle()}, has been deleted!");

    //delete the activity
    CollectionReference activities =
        FirebaseFirestore.instance.collection('activity');

    List activityLocal = tripData.getActivityList();
    int actLength = activityLocal.length;

    for (int i = 0; i < actLength; i++) {
      String activityDocumentID =
          activityLocal[i].toString().split('/')[1].replaceAll(")", "");
      await activities.doc(activityDocumentID).delete();
    }

    // //delete the trip from the users
    CollectionReference user = FirebaseFirestore.instance.collection('users');
    DocumentReference currDocumentRef = tripData.getTripDocumentReference();
    user.doc(user_info.getID()).update({
      'trips': FieldValue.arrayRemove([currDocumentRef])
    });

    // delete the Trip from db
    CollectionReference currTrip =
        FirebaseFirestore.instance.collection('trips');
    String tripDocumentID =
        currDocumentRef.toString().split('/')[1].replaceAll(")", "");
    await currTrip.doc(tripDocumentID).delete();

    overviewTripCallback();
  }

  Future<List> getData() async {
    List tripDoc = [];
    List tripList = [];
    int reflength = 0;

    //to grab the correct trip that belongs to the user
    CollectionReference user = FirebaseFirestore.instance.collection('users');
    DocumentReference specificUser = user.doc(user_info.getID());

    await specificUser.get().then((DocumentSnapshot doc) {
      final data = doc.data() as Map<String, dynamic>;
      reflength = data['trips'].length;
      tripDoc = data['trips'];
    });

    for (int i = 0; i < reflength; i++) {
      await tripDoc[i].get().then((DocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;

        tripList.add(Trips(
            tripDocumentReference: tripDoc[i],
            tripStartDate: data['tripStartDate'].toString(),
            tripEndDate: data['tripEndDate'].toString(),
            tripLocation: data['tripLocation'].toString(),
            tripTitle: data['tripTitle'].toString(),
            documentSnapshot: doc,
            activitiy_list: data['activities']));
      });
    }
    return tripList;
  }

  //return the DateTime format
  DateTime returnDate(String date) {
    DateTime dateFormat = DateTime(int.parse(date.split('-')[0]),
        int.parse(date.split('-')[1]), int.parse(date.split('-')[2]));

    return dateFormat;
  }

  _individualTile(context, data) {
    return ListView.separated(
        itemBuilder: (context, index) {
          return ListTile(
            trailing: PopupMenuButton<int>(
                onSelected: (value) {},
                itemBuilder: (BuildContext context) {
                  // Define the menu items for the PopupMenuButton
                  return <PopupMenuEntry<int>>[
                    PopupMenuItem<int>(
                      value: 0,
                      child: Text("Delete"),
                      // onTap: () => test(context, data[index].getTripTitle()),
                      onTap: () => deleteTrip(data[index]),
                    ),
                  ];
                }),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => IndividualTrip(
                          activities: data[index].getActivityList(),
                          tripTitle: data[index].getTripTitle(),
                          tripDocumentSnapshot:
                              data[index].getDocumentSnapshot(),
                          endDate: returnDate(data[index].getTripEndDate()),
                          overviewTripCallback: overviewTripCallback,
                          startDate: returnDate(data[index].getTripStartDate()),
                        )),
              );
            },
            title: Text(
              data[index].getTripTitle(),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
                '${data[index].getTripLocation()} - ${data[index].getTripStartDate()} to ${data[index].getTripEndDate()}'),
          );
        },
        separatorBuilder: (context, index) {
          return const Divider();
        },
        itemCount: data.length);
  }

  //toast message to notify user that trip has been deleted
  void toastMessage(BuildContext context, String value) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(value),
      ),
    );
  }

  //show up in the card
  printCard() {
    return FutureBuilder<List>(
        future: getData(),
        builder: (context, AsyncSnapshot snapshot) {
          //if there's data, show it
          if (snapshot.hasData) {
            List data = snapshot.data;
            return Flexible(child: _individualTile(context, data));
            //no data
          }
          if (!snapshot.hasData) {
            return const Text('No activity, add some!');
          }
          if (snapshot.hasError) {
            return Text('Error loading trips ${snapshot.error.toString()}');
          }
          //when waiting to retrieve the data
          return const CircularProgressIndicator();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          printCard(),
        ],
      ),
    );
  }
}
