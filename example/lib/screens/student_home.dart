import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:example/first_screen.dart';
import 'package:example/screens/feedback.dart';
import 'package:example/screens/mobile_screen.dart';
import 'package:example/screens/quesscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;

class SHomeScreen extends StatefulWidget {
  @override
  _SHomeScreenState createState() => _SHomeScreenState();
  static const routeName = '/shome';
}

class _SHomeScreenState extends State<SHomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String UserId = '';
  FirebaseStorage storage = FirebaseStorage.instance;

  Future<dynamic> getData() async {
    final User? user = _auth.currentUser;
    final uid = user!.uid;
    // Similarly we can get email as well
    //final uemail = user.email;
    UserId = uid;
    // Similarly we can get email as well
    //final uemail = user.email;
    return FirebaseFirestore.instance
        .collection('Questions')
        .doc(UserId)
        .snapshots();
  }

  userid() async {
    final User? user = _auth.currentUser;
    final uid = user!.uid;
    // Similarly we can get email as well
    //final uemail = user.email;
    UserId = uid;
  }

  @override
  Widget build(BuildContext context) {
    // to get size
    var size = MediaQuery.of(context).size;

    // style
    var cardTextStyle = TextStyle(
        fontFamily: "Montserrat Regular",
        fontSize: 14,
        color: Color.fromRGBO(63, 63, 63, 1));
    var subTextStyle = TextStyle(
      fontFamily: "Montserrat Regular",
      fontSize: 8,
      color: Colors.black45,
    );

    Future<List<Map<String, dynamic>>> _loadImages() async {
      userid();
      List<Map<String, dynamic>> files = [];

      final ListResult result = await storage.ref(UserId).list();
      final List<Reference> allFiles = result.items;

      await Future.forEach<Reference>(allFiles, (file) async {
        final String fileUrl = await file.getDownloadURL();
        final FullMetadata fileMeta = await file.getMetadata();
        files.add({
          "url": fileUrl,
          "path": file.fullPath,
          "Subject": fileMeta.customMetadata?['Subject'] ?? 'Student',
          "Headline": fileMeta.customMetadata?['Headline'] ?? 'No description'
        });
      });

      return files;
    }

    Future<void> _delete(String ref) async {
      await storage.ref(ref).delete();
      // Rebuild the UI
      setState(() {});
    }

    return Scaffold(
      body: Stack(
        children: <Widget>[
          SafeArea(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  Container(
                    height: size.height * 0.05,
                    margin: EdgeInsets.only(bottom: 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => FeedbackScreen()));
                          },
                          icon: Icon(
                            Icons.feedback,
                          ),
                        ),
                        Center(
                          child: Text(
                            'Online Forum',
                            style: TextStyle(
                                fontFamily: "Montserrat Medium",
                                color: Colors.black,
                                fontSize: 20),
                          ),
                        ),
                        Spacer(),
                        IconButton(
                            onPressed: () {
                              FirebaseAuth.instance.signOut();
                              Navigator.of(context).pop();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => FirstScreen()));
                            },
                            icon: Icon(
                              Icons.logout,
                            ))
                      ],
                    ),
                  ),
                  const Text(
                    "Your Past Doubts.",
                    style: TextStyle(
                        fontFamily: "Montserrat Medium",
                        color: Colors.black,
                        fontSize: 20),
                  ),
                  Expanded(
                    child: FutureBuilder(
                      future: _loadImages(),
                      builder: (context,
                          AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return ListView.builder(
                            itemCount: snapshot.data?.length ?? 0,
                            itemBuilder: (context, index) {
                              final Map<String, dynamic> image =
                                  snapshot.data![index];

                              return Card(
                                margin: EdgeInsets.symmetric(vertical: 10),
                                child: ListTile(
                                  dense: false,
                                  leading: Image.network(image['url']),
                                  title: Text(image['Subject']),
                                  subtitle: Text(image['Headline']),
                                  trailing: IconButton(
                                    onPressed: () => _delete(image['path']),
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        }

                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                    child: RaisedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => QuestionScreen()));
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(80.0)),
                      textColor: Colors.white,
                      padding: const EdgeInsets.all(0),
                      child: Container(
                        alignment: Alignment.center,
                        height: 50.0,
                        width: size.width * 0.8,
                        decoration: new BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(80.0),
                        ),
                        padding: const EdgeInsets.all(0),
                        child: Text(
                          "Ask a Question",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
