import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:example/screens/auth/details.dart';
import 'package:example/screens/chat/register.dart';
import 'package:example/screens/chat/rooms.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import '../screens/auth/background.dart';
import 'package:flutter/material.dart';

class QuestionScreen extends StatefulWidget {
  QuestionScreen({Key? key}) : super(key: key);

  @override
  _QuestionScreenState createState() => _QuestionScreenState();
  static const routeName = '/ques';
}

class _QuestionScreenState extends State<QuestionScreen> {
  final headController = TextEditingController();
  String _subVal = "Physics";
  List _subName = ["Physics", "Chemistry", "Maths"];
  bool _isAttachmentUploading = false;
  String UserId = '';

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  userid() async {
    final User? user = _auth.currentUser;
    final uid = user!.uid;
    // Similarly we can get email as well
    //final uemail = user.email;
    UserId = uid;
  }

  getimage(
    String headline,
    String subject,
    var imageurl,
  ) async {
    final User? user = _auth.currentUser;
    final uid = user!.uid;
    // Similarly we can get email as well
    //final uemail = user.email;
    UserId = uid;
    // ignore: avoid_print
    DocumentReference feed =
        await FirebaseFirestore.instance.collection('Questions').doc(UserId);
    feed.set({
      "Headline": headline,
      "Subject": subject,
      "ImageUrl": imageurl,
    });
    // FirebaseDatabase.instance.reference().child('Feedback').child(UserId).set({
    //   "Teacher Name": name,
    //   "Description": description,
    //   "Rating": rating,
    // });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Background(
        child: SizedBox(
          height: size.height,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.zero,
                  margin: EdgeInsets.zero,
                  height: size.height,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 30, right: 30),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Please fill the details below.",
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 20,
                                letterSpacing: 0.07,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 50, right: 50),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "Choose a subject.",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black45,
                                      letterSpacing: 0.07,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              children: [
                                Container(
                                  padding:
                                      EdgeInsets.only(left: 16.0, right: 16.0),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.black, width: 1.0),
                                  ),
                                  child: DropdownButton(
                                    hint: Text('Select Name'),
                                    dropdownColor: Colors.white,
                                    elevation: 5,
                                    icon: Icon(Icons.arrow_drop_down),
                                    iconSize: 36.0,
                                    isExpanded: true,
                                    value: _subVal,
                                    style: TextStyle(
                                        color: Color(0xff2F3037),
                                        fontSize: 22.0),
                                    onChanged: (value) {
                                      setState(() {
                                        _subVal = value.toString();
                                      });
                                    },
                                    items: _subName.map((value) {
                                      return DropdownMenuItem(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  ),
                                ),
                                SizedBox(height: size.height * 0.03),
                                Container(
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.symmetric(horizontal: 16),
                                  child: TextField(
                                    controller: headController,
                                    decoration:
                                        InputDecoration(labelText: "Headline"),
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.centerRight,
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 40, vertical: 10),
                                  child: RaisedButton(
                                    onPressed: () {
                                      userid();
                                      _handleImageSelection(
                                          headController.text, _subVal, UserId);
                                    },
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(80.0)),
                                    textColor: Colors.white,
                                    padding: const EdgeInsets.all(0),
                                    child: Container(
                                      alignment: Alignment.center,
                                      height: 50.0,
                                      width: size.width * 0.8,
                                      decoration: new BoxDecoration(
                                        color: Colors.blue,
                                        borderRadius:
                                            BorderRadius.circular(80.0),
                                      ),
                                      padding: const EdgeInsets.all(0),
                                      child: Text(
                                        "Upload Image",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                // ignore: deprecated_member_use
                                FlatButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(0)),
                                  minWidth: double.infinity,
                                  padding: EdgeInsets.all(10.0),
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        fullscreenDialog: true,
                                        builder: (context) =>
                                            SRegisterPage(_subVal),
                                      ),
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(6.0),
                                    child: Text(
                                      "Chat",
                                      style: TextStyle(
                                        fontFamily: "Montserrat",
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                  ),
                                  color: Color(0xFF2E3B62),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _handleImageSelection(String head, String sub, id) async {
    final result = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (result != null) {
      _setAttachmentUploading(true);
      final file = File(result.path);
      final size = file.lengthSync();
      final bytes = await result.readAsBytes();
      final image = await decodeImageFromList(bytes);
      final name = result.name;

      try {
        final reference = FirebaseStorage.instance.ref(id).child(name);
        await reference.putFile(
            file,
            SettableMetadata(customMetadata: {
              'Subject': sub,
              'Headline': head,
            }));
        final uri = await reference.getDownloadURL();
        getimage(head, sub, uri);
        _setAttachmentUploading(false);
      } finally {
        _setAttachmentUploading(false);
      }
    }
  }

  void _setAttachmentUploading(bool uploading) {
    setState(() {
      _isAttachmentUploading = uploading;
    });
  }
}
