import 'package:example/teacher/chat/trooms.dart';
import 'package:example/screens/auth/background.dart';
import 'package:example/screens/student_home.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class TRegisterScreen extends StatefulWidget {
  static const routeName = '/Tregister';

  @override
  State<TRegisterScreen> createState() => _TRegisterScreenState();
}

class _TRegisterScreenState extends State<TRegisterScreen> {
  String UserId = '';

  final nameController = TextEditingController();

  final numberController = TextEditingController();

  final educationController = TextEditingController();

  final emailController = TextEditingController();

  final expController = TextEditingController();

  String _subVal = "Physics";
  List _subName = ["Physics", "Chemistry", "Maths"];

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  void dispose() {
    // Clean up the controller when the widget is disposed.
    nameController.dispose();
    educationController.dispose();
    numberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    getCurrentUser(
      String name,
      String number,
      String education,
      String email,
      String previousexp,
      String subject,
    ) async {
      final User user = _auth.currentUser!;
      final uid = user.uid;
      // Similarly we can get email as well
      //final uemail = user.email;
      UserId = uid;
      // ignore: avoid_print

      FirebaseDatabase.instance
          .reference()
          .child('Teachers')
          .child(UserId)
          .set({
        'Name': name,
        'Phone': number,
        'Education': education,
        'Email': email,
        'Previous Experience': previousexp,
        'Subject': subject,
      });
    }

    return Scaffold(
      body: Background(
        child: SingleChildScrollView(
          child: Container(
            height: size.height * 1.5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: size.height * 0.15),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    "REGISTER",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 36),
                    textAlign: TextAlign.left,
                  ),
                ),
                SizedBox(height: size.height * 0.03),
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(horizontal: 40),
                  child: TextField(
                    controller: nameController,
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(labelText: "Name"),
                  ),
                ),
                SizedBox(height: size.height * 0.03),
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(horizontal: 40),
                  child: TextField(
                    controller: numberController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(labelText: "Mobile Number"),
                  ),
                ),
                SizedBox(height: size.height * 0.03),
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(horizontal: 40),
                  child: TextField(
                    controller: educationController,
                    decoration: InputDecoration(labelText: "Education"),
                  ),
                ),
                SizedBox(height: size.height * 0.03),
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(horizontal: 40),
                  child: TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(labelText: "Email"),
                  ),
                ),
                SizedBox(height: size.height * 0.03),
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(horizontal: 40),
                  child: TextField(
                    controller: expController,
                    keyboardType: TextInputType.number,
                    decoration:
                        InputDecoration(labelText: "Previous Experience"),
                  ),
                ),
                SizedBox(height: size.height * 0.03),
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(horizontal: 40),
                  child: Container(
                    padding: EdgeInsets.only(left: 16.0, right: 16.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 1.0),
                    ),
                    child: DropdownButton(
                      hint: Text('Subject'),
                      dropdownColor: Colors.white,
                      elevation: 5,
                      icon: Icon(Icons.arrow_drop_down),
                      iconSize: 36.0,
                      isExpanded: true,
                      value: _subVal,
                      style:
                          TextStyle(color: Color(0xff2F3037), fontSize: 22.0),
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
                ),
                SizedBox(height: size.height * 0.05),
                Container(
                  alignment: Alignment.centerRight,
                  margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  child: RaisedButton(
                    onPressed: () {
                      getCurrentUser(
                        nameController.text,
                        numberController.text,
                        educationController.text,
                        emailController.text,
                        expController.text,
                        _subVal,
                      );
                      _signOut();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TRoomsPage()));
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(80.0)),
                    textColor: Colors.white,
                    padding: const EdgeInsets.all(0),
                    child: Container(
                      alignment: Alignment.center,
                      height: 50.0,
                      width: size.width * 0.5,
                      decoration: new BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(80.0),
                      ),
                      padding: const EdgeInsets.all(0),
                      child: Text(
                        "SIGN UP",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
