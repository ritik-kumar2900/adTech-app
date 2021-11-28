import 'package:example/first_screen.dart';
import 'package:example/screens/auth/details.dart';
import 'package:example/screens/chat/videocalling.dart';

import 'package:example/screens/mobile_screen.dart';
import 'package:example/screens/quesscreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../screens/student_home.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Adtech',
      theme: ThemeData(
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: Colors.white,
        primaryColor: Colors.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      routes: {
        LoginScreen.routeName: (ctx) => LoginScreen(),
        RegisterScreen.routeName: (ctx) => RegisterScreen(),
        SHomeScreen.routeName: (ctx) => SHomeScreen(),
        QuestionScreen.routeName: (ctx) => QuestionScreen(),
      },
      home: FirstScreen(),
    );
  }
}
