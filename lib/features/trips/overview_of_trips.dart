import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OverviewOfTrips extends StatefulWidget {
  const OverviewOfTrips({super.key});

  @override
  _OverviewOfTripsState createState() => _OverviewOfTripsState();
}

class _OverviewOfTripsState extends State<OverviewOfTrips> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("overview of trips!"),
    );
  }

}
