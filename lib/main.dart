import 'package:crux/screens/dashboard_screen.dart';
import 'package:crux/screens/sign_in_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  final String title = 'Crux';

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Crux',
      home: new SignInScreen(title: 'Crux'),
      routes: {
        '/dashboard_screen': (context) => DashboardScreen(title: title),
        /*'/about_you_2': (context) => AboutYou2(),
        '/current_policy': (context) => Logo(),*/
      },
    );
  }
}
