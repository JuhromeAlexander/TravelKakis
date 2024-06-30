import 'package:cloud_firestore/cloud_firestore.dart';

class activity {

  String activityTitle;
  String activityTime;
  DocumentSnapshot documentSnapshot;
  String documentID;
  String tripID;
  DocumentReference activityDocumentReference;
  String? activityCost;
  String? activityDate;
  String? activityDuration;
  String? activityLocation;
  String? activityPhone;
  String? activityWebsite;
  //
  activity( {
    required this.activityTitle,
    required this.activityTime,
    required this.documentSnapshot,
    required this.documentID,
    required this.tripID,
    required this.activityDocumentReference,
    this.activityCost,
    this.activityDate,
    this.activityDuration,
    this.activityLocation,
    this.activityPhone,
    this.activityWebsite,
  });
  //

  DocumentReference getActivityDocumentReference() {
    return activityDocumentReference;
  }

  String getTripID() {
    return tripID;
  }

  String getDocumentID() {
    return documentID;
  }

  DocumentSnapshot getDocumentSnapshot() {
    return documentSnapshot;
  }

  String getActivityTitle() {
    return activityTitle;
  }

  String getActivityTime() {
    return activityTime;
  }

  String? getActivityCost() {
    return activityCost;
  }

  String? getActivityDate() {
    return activityDate;
  }

  String? getActivityDuration() {
    return activityDuration;
  }

  String? getActivityLocation() {
    return activityLocation;
  }

  String? getActivityPhone() {
    return activityPhone;
  }

  String? getActivityWebsite() {
    return activityWebsite;
  }

}