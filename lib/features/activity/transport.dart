import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Transport extends StatefulWidget {

  final String activityDocumentID;

  const Transport({
    super.key, required this.activityDocumentID,
  });

  @override
  _TransportState createState() => _TransportState();
}

class _TransportState extends State<Transport> {

  TextEditingController? _sourceController;
  TextEditingController? _destinationController;


  @override
  void initState() {
    super.initState();

    getData();

  }

  getData() async {
    CollectionReference activity = FirebaseFirestore.instance.collection('activity');
    DocumentReference specificActivity =  activity.doc(widget.activityDocumentID);

    final dataDoc = await specificActivity.get();
    final data = dataDoc.data() as Map<String, dynamic>;

    _sourceController = TextEditingController(text: data['source']);
    _destinationController = TextEditingController(text: data['destination']);

    setState(() {

    });

    return data;
  }

  //generate the google map link for the user
  Future<void> _launchUrl(String source, String dest) async {
    String googleMapWebsite = 'https://www.google.com/maps/dir/ ${source} / ${dest}';
    Uri googleMapLinkUri = Uri.parse(googleMapWebsite);

    if (!await launchUrl(googleMapLinkUri)) {
      throw Exception('Could not launch $googleMapLinkUri');
    }
  }

  //update the transport (SOURCE)
  updateTransportSource(String source) async {
    CollectionReference activity = FirebaseFirestore.instance.collection('activity');

    String docID = widget.activityDocumentID;

    await activity.doc(docID).update({
      'source': _sourceController?.text,
    });

  }

  //update the transport (DEST)
  updateTransportDest(String destination) async {
    CollectionReference activity = FirebaseFirestore.instance.collection('activity');

    String docID = widget.activityDocumentID;

    await activity.doc(docID).update({
      'destination': _destinationController?.text,
    });

  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 30.0,
        ),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: TextField(
                    controller: _sourceController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.location_on),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(color: Colors.grey)),
                      labelText: 'From',
                      hintStyle: const TextStyle(color: Colors.grey),
                    ),
                    onChanged: (String val) {
                      updateTransportSource(val);
                    },
                    // onTap: () {
                    //   // _selectDate(context, _activityDateController);
                    // },
                  )),
              Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: TextField(
                    controller: _destinationController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.location_on),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: const BorderSide(color: Colors.grey)),
                      labelText: 'To',
                      hintStyle: const TextStyle(color: Colors.grey),
                    ),
                    onChanged: (String val) {
                      updateTransportDest(val);
                      // _selectDate(context, _activityDateController);
                    },
                  )),

              Container(
                margin: const EdgeInsets.only(top: 20.0, bottom: 20.0),
                child: ElevatedButton(
                  onPressed: () => _launchUrl(_sourceController!.text, _destinationController!.text),
                      // updateData(context, widget.documentSnapshot),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6), // <-- Radius
                    ),
                    minimumSize: const Size(double.infinity, 40),
                  ),
                  child: const Text(
                      style: TextStyle(color: Colors.white), 'Google Map'),
                ),
              )
            ]));
  }
}
