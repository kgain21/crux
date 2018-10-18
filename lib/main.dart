import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crux/screens/dashboard_screen.dart';
import 'package:crux/screens/rep_list_screen.dart';
import 'package:crux/screens/sign_in_screen.dart';
import 'package:crux/screens/stopwatch_screen.dart';
import 'package:crux/utils/auth.dart';
import 'package:crux/utils/base_auth.dart';
import 'package:crux/widgets/timer_text.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  final FirebaseApp app = await FirebaseApp.configure(
    name: 'Crux',
    options: const FirebaseOptions(
      googleAppID: '1:514273409976:android:2e90ce9f0cfeaee6',
      apiKey: 'AIzaSyAj0C3xoi0IRN5CKK7V9OCawYCT0ScVKrg',
      projectID: 'crux-439d7',
    ),
  );
  final Firestore firestore = Firestore(app: app);

  runApp(MyApp(firestore: firestore));
}

class MyApp extends StatelessWidget {
  final String title = 'Crux';
  final BaseAuth auth = new Auth();
  final Firestore firestore;

  MyApp({this.firestore});

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: title,
      theme: ThemeData(
        //primaryColor: Color.fromARGB(255, 103, 126, 116),
        primaryColor: Color.fromARGB(255, 44, 62, 80),
        //olor.fromARGB(255, 68, 77, 71),
        //secondaryHeaderColor: Color.fromARGB(255, 103, 126, 116),
        //buttonColor: Color.fromARGB(255, 146, 164, 172),
      ),
      home: new SignInScreen(title: title, auth: auth),
      routes: {
        '/dashboard_screen': (context) =>
            DashboardScreen(title: title, auth: auth),
        '/stopwatch_screen': (context) => StopwatchScreen(title: title),
        '/rep_list_screen': (context) =>
            RepListScreen(title: title, auth: auth, firestore: firestore),
        '/countdown_timer_screen': (context) => TimerTextAnimator(),
      },
    );
  }
}
