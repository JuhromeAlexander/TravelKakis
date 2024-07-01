import 'package:cloud_firestore/cloud_firestore.dart';

class Trips {
  final String tripTitle;
  final String tripEndDate;
  final String tripStartDate;
  final String tripLocation;
  final List activitiy_list;
  final DocumentSnapshot documentSnapshot;
  final DocumentReference? tripDocumentReference;

  Trips( {
    required this.tripTitle,
    required this.tripEndDate,
    required this.tripStartDate,
    required this.tripLocation,
    required this.activitiy_list,
    required this.documentSnapshot,
    this.tripDocumentReference
  });

  DocumentReference? getTripDocumentReference() {
    return this.tripDocumentReference;
  }

  DocumentSnapshot getDocumentSnapshot() {
    return this.documentSnapshot;
  }

  List getActivityList() {
    return activitiy_list;
  }

  String getTripTitle() {
    return tripTitle;
  }

  String getTripEndDate() {
    return tripEndDate;
  }

  String getTripStartDate() {
    return tripStartDate;
  }

  String getTripLocation() {
    return tripLocation;
  }


}