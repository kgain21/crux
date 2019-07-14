import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crux/backend/services/auth.dart';
import 'package:crux/backend/services/base_auth.dart';
import 'package:crux/backend/services/preferences.dart';
import 'package:crux/presentation/screens/calendar_screen.dart';
import 'package:crux/presentation/screens/dashboard_screen.dart';
import 'package:crux/presentation/screens/hangboard/exercise_page_view.dart';
import 'package:crux/presentation/screens/hangboard/hangboard_workout_screen.dart';
import 'package:crux/presentation/screens/sign_in_screen.dart';
import 'package:crux/presentation/screens/spotify_test_screen.dart';
import 'package:crux/presentation/screens/stopwatch_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  /// Global vars
  final BaseAuth auth = new Auth();
  final String title = 'Crux';
  Preferences.sharedPreferences = await SharedPreferences.getInstance();

  /// Firebase setup
  final FirebaseApp app = await FirebaseApp.configure(
    name: 'Crux',
    options: const FirebaseOptions(
      googleAppID: '1:514273409976:android:2e90ce9f0cfeaee6',
      apiKey: 'AIzaSyAj0C3xoi0IRN5CKK7V9OCawYCT0ScVKrg',
      projectID: 'crux-439d7',
    ),
  );

  final Firestore firestore = Firestore(app: app);

  runApp(MyApp(firestore: firestore, auth: auth, title: title));
}

class MyApp extends StatelessWidget {
  final Firestore firestore;
  final BaseAuth auth;
  final String title;

  MyApp({this.firestore, this.auth, this.title});

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: title,
      theme: ThemeData(
        //primaryColor: Color.fromARGB(255, 103, 126, 116),
//        primaryColor: Color(0xFFb0bec5),
        primaryColor: Color(0xFFcfd8dc),
//        primaryColorLight: Color(0xFFe2f1f8),
        primaryColorLight: Color(0xFFffffff),
//        primaryColorDark: Color(0xFF808e95),
        primaryColorDark: Color(0xFF9ea7aa),
        bottomAppBarColor: Color(0xFFe2f1f8),
        secondaryHeaderColor: Color(0xFF009624),
//        accentColor: Color(0xAF76ff03),
        accentColor: Color(0xFF64dd17),
        bottomAppBarTheme: BottomAppBarTheme(
          color: Color(0xFFcfd8dc),
        ),

        primaryColorBrightness: Brightness.light,
        //canvasColor: Color(0xFF64dd17),

//        fontFamily: 'OpenSans',
        fontFamily: 'Metropolis',

        textTheme: TextTheme(
            headline: TextStyle(
//            fontFamily: 'OpenSans',
                fontSize: 30.0),
            title: TextStyle(fontSize: 24.0)),
      ),
      home: new SignInScreen(title: title, auth: auth),
      routes: {
        '/dashboard_screen': (context) =>
            DashboardScreen(title: title, auth: auth),
        '/stopwatch_screen': (context) => StopwatchScreen(title: title),
        '/hangboard_workout_screen': (context) => HangboardWorkoutScreen(
            title: title,
            auth: auth),
//        '/countdown_timer_screen': (context) => WorkoutTimer(),
        '/spotify_test_screen': (context) => SpotifyTestScreen(),
        '/exercise_page_view': (context) => ExercisePageView(),
        '/calendar_screen': (context) => CalendarScreen(auth: auth),
      },
      debugShowCheckedModeBanner: true,
      debugShowMaterialGrid: false,
      checkerboardOffscreenLayers: false,
    );
  }
}
