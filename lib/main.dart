import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crux/screens/dashboard_screen.dart';
import 'package:crux/screens/sign_in_screen.dart';
import 'package:crux/screens/spotify_test_screen.dart';
import 'package:crux/screens/stopwatch_screen.dart';
import 'package:crux/screens/workout_screen.dart';
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
        primaryColor: Colors.blueGrey,
        //midnight blue
        backgroundColor: Colors.blueGrey,
        scaffoldBackgroundColor: Color.fromARGB(255, 44, 62, 80),
        cardColor: Color.fromARGB(255, 44, 62, 80),
        hintColor: Colors.white,
        textTheme: new TextTheme(
          display4: TextStyle(
            color: Colors.white,
          ),
          display3: TextStyle(
            color: Colors.white,
          ),
          display2: TextStyle(
            color: Colors.white,
          ),
          display1: TextStyle(
            color: Colors.white,
          ),
          headline: TextStyle(
            color: Colors.white,
          ),
          title: TextStyle(
            color: Colors.white,
          ),
          subhead: TextStyle(
            color: Colors.white,
          ),
          body1: TextStyle(
            color: Colors.white,
          ),
          body2: TextStyle(
            color: Colors.white,
          ),
          caption: TextStyle(
            color: Colors.white,
          ),
          button: TextStyle(
            color: Colors.white,
          ),
          subtitle: TextStyle(
            color: Colors.white,
          ),
        ),
        primaryIconTheme: IconThemeData(
          color: Colors.white,
        ),
        accentIconTheme: IconThemeData(
          color: Colors.white,
        ),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),

      ),
      home: new SignInScreen(title: title, auth: auth),
      routes: {
        '/dashboard_screen': (context) =>
            DashboardScreen(title: title, auth: auth),
        '/stopwatch_screen': (context) => StopwatchScreen(title: title),
        /*'/hangboard_workout_screen': (context) => HangboardWorkoutScreen(
            title: title, auth: auth, firestore: firestore),*/
        '/workout_screen': (context) => WorkoutScreen(
            title: 'Hangboard Workouts', auth: auth, firestore: firestore),
        '/countdown_timer_screen': (context) => TimerTextAnimator(),
        '/spotify_test_screen': (context) => SpotifyTestScreen(),
      },
    );
  }
}
