import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:travel_kakis/features/trips/Trips.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travel_kakis/features/trips/individual_trip.dart';
import 'package:travel_kakis/utils/user_information.dart' as user_info;

class OverviewOfTrips extends StatefulWidget {

  const OverviewOfTrips({super.key});

  @override
  _OverviewOfTripsState createState() => _OverviewOfTripsState();
}

class _OverviewOfTripsState extends State<OverviewOfTrips> {
  //TODO: I don't think this is the most efficient way to do it

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

  //show up in the card
  printCard() {

    return FutureBuilder<List>(
        future: getData(),
        builder: (context, AsyncSnapshot snapshot) {
          //if there's data, show it
          if (snapshot.hasData) {
            List data = snapshot.data;
            return Flexible(
                child: ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          title: Text(data[index].getTripTitle()),
                          subtitle: Text(
                              '${data[index].getTripLocation()} - ${data[index].getTripStartDate()} to ${data[index].getTripEndDate()}'),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => IndividualTrip(
                                  activities: data[index].getActivityList(),
                                tripTitle: data[index].getTripTitle(),
                                documentSnapshot: data[index].getDocumentSnapshot(),
                              )),
                            );
                          },
                        ),
                      );
                    }));
            //no data
          }
          if (!snapshot.hasData) {
            return const Text('No activity, add some!');
          }
          if (snapshot.hasError) {
            return Text('Error loading trips ${snapshot.error.toString()}');
          }
          //when waiting to retrieve the data
          return CircularProgressIndicator();
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