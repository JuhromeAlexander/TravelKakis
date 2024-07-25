import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ViewDocument extends StatefulWidget {
  final String fileTitle;
  final String documentLink;

  const ViewDocument(
      {super.key, required this.fileTitle, required this.documentLink});

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
        body: Container(
          child: PhotoView(
            imageProvider: NetworkImage(widget.documentLink),
          ),
        )
    );
  }
}
