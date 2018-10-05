import 'package:crux/screens/dashboard_screen.dart';
import 'package:crux/screens/rep_list_screen.dart';
import 'package:crux/screens/sign_in_screen.dart';
import 'package:crux/screens/stopwatch_screen.dart';
import 'package:crux/utils/auth.dart';
import 'package:crux/utils/base_auth.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  final String title = 'Crux';
  final BaseAuth auth = new Auth();

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Crux',
      home: new SignInScreen(title: 'Crux', auth: auth),
      routes: {
        //'/': (context) => SignInScreen(title: title),
        '/dashboard_screen': (context) => DashboardScreen(title: title),
        '/stopwatch_screen': (context) => StopwatchScreen(title: title),
        '/rep_list_screen': (context) =>
            RepListScreen(title: title, auth: auth),
        /*'/about_you_2': (context) => AboutYou2(),
        '/current_policy': (context) => Logo(),*/
      },
    );
  }
}
