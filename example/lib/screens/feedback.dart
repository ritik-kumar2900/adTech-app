import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:example/screens/auth/background.dart';
import 'package:example/screens/student_home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FeedbackScreen extends StatefulWidget {
  FeedbackScreen({Key? key}) : super(key: key);

  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final descriptionController = TextEditingController();
  final nameController = TextEditingController();

  String _subVal = "5";
  List _subName = ["1", "2", "3", "4", "5"];
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String UserId = '';
  getfeedback(
    String name,
    String description,
    String rating,
  ) async {
    final User? user = _auth.currentUser;
    final uid = user!.uid;
    // Similarly we can get email as well
    //final uemail = user.email;
    UserId = uid;
    // ignore: avoid_print
    DocumentReference feed =
        await FirebaseFirestore.instance.collection('Feedback').doc(UserId);
    feed.set({
      "Teacher Name": name,
      "Description": description,
      "Rating": rating,
    });
    // FirebaseDatabase.instance.reference().child('Feedback').child(UserId).set({
    //   "Teacher Name": name,
    //   "Description": description,
    //   "Rating": rating,
    // });
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Background(
        child: Center(
          child: SizedBox(
            height: size.height,
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: size.height * 0.2),
                    Text(
                      "Please Provide a Feedback.",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                        letterSpacing: 0.07,
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.symmetric(horizontal: 16),
                            child: TextField(
                              controller: nameController,
                              keyboardType: TextInputType.name,
                              decoration:
                                  InputDecoration(labelText: "Teacher Name"),
                            ),
                          ),
                          SizedBox(height: size.height * 0.03),
                          Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.symmetric(horizontal: 16),
                            child: TextField(
                              controller: descriptionController,
                              keyboardType: TextInputType.multiline,
                              decoration:
                                  InputDecoration(labelText: "Description"),
                            ),
                          ),
                          SizedBox(height: size.height * 0.03),
                          Container(
                            padding: EdgeInsets.only(left: 16.0, right: 16.0),
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.black, width: 1.0),
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
                                  color: Color(0xff2F3037), fontSize: 22.0),
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
                          FlatButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0)),
                            minWidth: double.infinity,
                            padding: EdgeInsets.all(10.0),
                            onPressed: () {
                              getfeedback(nameController.text,
                                  descriptionController.text, _subVal);
                              Navigator.of(context).pop();
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  fullscreenDialog: true,
                                  builder: (context) => SHomeScreen(),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Text(
                                "Submit",
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
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
