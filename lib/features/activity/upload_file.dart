import 'package:flutter/material.dart';
import 'package:travel_kakis/utils/user_information.dart' as user_info;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:travel_kakis/features/activity/view_document.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UploadFile extends StatefulWidget {
  final DocumentSnapshot activityDocumentSnapshot;
  final DocumentSnapshot tripDocumentSnapshot;

  const UploadFile({
    super.key,
    required this.tripDocumentSnapshot,
    required this.activityDocumentSnapshot,

  });

  @override
  UploadFileState createState() => UploadFileState();
}

class UploadFileState extends State<UploadFile> {
  List<Reference> _uploadedDocuments = [];

  void callBack() {
    setState(() {
      getUploadedFiles();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUploadedFiles();
  }

  Future<List<Reference>?> getUsersUploadedFiles() async {
    try {
      final userInfo = user_info.getID().toString();
      final storage = FirebaseStorage.instance.ref();
      final uploadFiles = storage.child('${userInfo}/${widget.tripDocumentSnapshot.id}/${widget.activityDocumentSnapshot.id}');
      final uploads = await uploadFiles.listAll();

      return uploads.items;
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<void> _launchUrl(Uri url) async {
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  //to delete file documents that are uploaded to google cloud
  Future deleteDocuments(Reference ref) async {
    await ref.delete();
    _toastMessage(context, '${ref.name} has been deleted');
    setState(() {
      getUploadedFiles();
    });
  }

  //to download file documents that the user have uploaded to google cloud
  Future openPDF(Uri url) async {
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  //a toast to tell user that the file has been deleted
  void _toastMessage(BuildContext context, String value) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(value),
      ),
    );
  }

  Widget _cardInformation(context) {

    if (_uploadedDocuments.isEmpty) {
      return const Center(
        child: Text("No documents has been uploaded"),
      );
    }
    return ListView.separated(
        itemBuilder: (context, index) {
          Future<FullMetadata> metaDataInformation =
              _uploadedDocuments[index].getMetadata();
          Future<String> downloadLink =
              _uploadedDocuments[index].getDownloadURL();
          return FutureBuilder(
              future: Future.wait([metaDataInformation, downloadLink]),
              builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
                if (snapshot.hasData) {
                  return ListTile(
                    trailing: PopupMenuButton<int>(
                        onSelected: (value) {},
                        itemBuilder: (BuildContext context) {
                          // Define the menu items for the PopupMenuButton
                          return <PopupMenuEntry<int>>[
                            PopupMenuItem<int>(
                              onTap: () =>
                                  deleteDocuments(_uploadedDocuments[index]),
                              child: const Text("Delete"),
                            ),
                          ];
                        }),
                    title: Text(_uploadedDocuments[index].name),
                    onTap: () {
                      //if pdf we download, if image we view in flutter app
                      if (snapshot.data?[0].contentType
                              .toString()
                              .contains("image") ??
                          false) {
                        print(snapshot.data);
                        _navigateToViewDocument(context,
                            _uploadedDocuments[index].name, snapshot.data?[1]);
                      } else {
                        openPDF(Uri.parse(snapshot.data?[1]));
                      }
                    },
                  );
                }
                return Container();
              }
              );
        },
        separatorBuilder: (context, index) {
          return const Divider();
        },
        itemCount: _uploadedDocuments.length);
  }

  void getUploadedFiles() async {
    List<Reference>? result = await getUsersUploadedFiles();

    if (result != null) {
      setState(() {
        _uploadedDocuments = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _cardInformation(context);
  }
}

//open into a new page when click on file
void _navigateToViewDocument(context, fileTitle, docLink) {
  Navigator.push(
    context,
    MaterialPageRoute(
        builder: (context) => ViewDocument(
              fileTitle: fileTitle,
              documentLink: docLink,
            )),
  );
}
