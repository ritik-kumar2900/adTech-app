import 'package:example/admin/register.dart';
import 'package:example/first_screen.dart';
import 'package:example/screens/auth/background.dart';
import 'package:example/teacher/tdetails.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pin_put/pin_put.dart';

class ALoginPage extends StatefulWidget {
  const ALoginPage({Key? key}) : super(key: key);

  @override
  _ALoginPageState createState() => _ALoginPageState();
}

class _ALoginPageState extends State<ALoginPage> {
  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();
  final BoxDecoration pinPutDecoration = BoxDecoration(
    color: Colors.blue[200],
    borderRadius: BorderRadius.circular(0.0),
    border: Border.all(color: Colors.white),
  );
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SizedBox(
        height: size.height,
        child: Background(
          child: ListView(
            children: [
              Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.1),
                    margin: EdgeInsets.zero,
                    height: MediaQuery.of(context).size.height * 0.7,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Verify Screen",
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
                                    "Enter Password. ",
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
                            Padding(
                              padding: EdgeInsets.only(left: 5.0, right: 5.0),
                              child: Column(
                                children: [
                                  PinPut(
                                      fieldsCount: 6,
                                      textStyle: const TextStyle(
                                          fontSize: 25.0, color: Colors.white),
                                      eachFieldWidth: 40.0,
                                      eachFieldHeight: 55.0,
                                      focusNode: _pinPutFocusNode,
                                      controller: _pinPutController,
                                      submittedFieldDecoration:
                                          pinPutDecoration,
                                      selectedFieldDecoration: pinPutDecoration,
                                      followingFieldDecoration:
                                          pinPutDecoration,
                                      pinAnimationType: PinAnimationType.fade,
                                      onSubmit: (pin) async {
                                        if (pin == "123456") {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              fullscreenDialog: true,
                                              builder: (context) =>
                                                  TRegisterPage(),
                                            ),
                                          );
                                        }
                                      }),
                                  SizedBox(
                                    height: 10,
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
                                          builder: (context) => FirstScreen(),
                                        ),
                                      );
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(6.0),
                                      child: Text(
                                        "Exit",
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
                  Container(
                    margin: EdgeInsets.zero,
                    padding: EdgeInsets.zero,
                    height: MediaQuery.of(context).size.height * 0.18,
                    child: Image.asset(
                      "assets/images/nobg.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
