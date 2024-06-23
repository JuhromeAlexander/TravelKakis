import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travel_kakis/features/activity/activity.dart';
import 'package:travel_kakis/features/activity/individual_activity.dart';
import 'package:travel_kakis/features/activity/create_activity.dart';


class IndividualTrip extends StatefulWidget {
  final List activities;
  final String tripTitle;
  final DocumentSnapshot documentSnapshot;


  const IndividualTrip({
    super.key,
    required this.activities,
    required this.tripTitle,
    required this.documentSnapshot
  });

  @override
  _IndividualTripState createState() => _IndividualTripState();
}

class _IndividualTripState extends State<IndividualTrip> {
  // Reading the data from trip collection
  List activities = [];

  Future<List> getData(List activityData) async {
    int activitylength = activityData.length;

    for (int i = 0; i < activitylength; i++) {
      await activityData[i].get().then((DocumentSnapshot doc) {
        if (doc.exists) {
          final data = doc.data() as Map<String, dynamic>;
          activities.add(activity(
            activityTitle: data['title'].toString(),
            activityTime: data['time'].toString(),
            documentSnapshot: doc,
          ));
        }
      });
    }

    return activities;
  }

  //show all the activities
  printCard() {
    return FutureBuilder<List>(
        future: getData(widget.activities),
        builder: (context, AsyncSnapshot snapshot) {
          //if there's data, show it
          if (snapshot.hasData){
            List data = snapshot.data;
            return Flexible(
                child: ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          title: Text(data[index].getActivityTitle()),
                          subtitle: Text(data[index].getActivityTime()),
                          onTap: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => IndividualActivity(documentSnapshot: data[index].getDocumentSnapshot())),
                            );
                          },
                        ),
                      );
                    }
                )
              );
            //no data
          } if(!snapshot.hasData) {
            return const Text('No activity, add some!');
          }
          if (snapshot.hasError) {
            return Text('Error loading activity ${snapshot.error.toString()}');
          }
          //when waiting to retrieve the data
          return CircularProgressIndicator();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.tripTitle),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          _navigateToCreateActivity(context, widget.documentSnapshot);
        },
        shape: CircleBorder(),
        child: const Icon(Icons.add)
      ),

      body: Column(
        children: <Widget>[
          //top half
          Expanded(
              flex: 3,
              child: Container(
                color: Colors.black87,
              )),
          //bottom half
          Expanded(
              flex: 7,
              child: Container(
                  height: double.infinity,
                  // child: SingleChildScrollView(
                  //     physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(children: <Widget>[
                        printCard(),
                      ]
                      )
                  // )
              )
          ),
        ],
      ),
    );
  }

}

//navigate to create activity
void _navigateToCreateActivity(context, DocumentSnapshot docSnapshot) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => CreateActivity(documentSnapshot: docSnapshot,)),
  );
}
