import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class WelcomeScreen extends StatelessWidget {
  WelcomeScreen({Key key, this.title, this.username}) : super(key: key);

  final String title;
  final String username;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(),
      body: new Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Text('Welcome $username!'),
                new RaisedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/dashboard_screen');
                  },
                  child: new Text('Continue'),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
