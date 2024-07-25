import 'package:flutter/material.dart';
import 'package:travel_kakis/utils/user_information.dart' as user_info;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:typed_data';

class ViewDocument extends StatefulWidget {
  final String fileTitle;
  final String documentLink;

   const ViewDocument({
    super.key,
    required this.fileTitle,
    required this.documentLink
  });

  @override
  _ViewDocumentState createState() => _ViewDocumentState();
}

class _ViewDocumentState extends State<ViewDocument> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.fileTitle),
      ),
      body: new Image.network(
        widget.documentLink,
        height: double.infinity,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    );
  }
}

