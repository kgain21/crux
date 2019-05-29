import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class WelcomeScreen extends StatelessWidget {
  WelcomeScreen({Key key, this.title, this.username}) : super(key: key);

  final String title;
  final String username;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        automaticallyImplyLeading: false, //Removes back button
        title: Text(title),
      ),
      body: Stack(
        children: <Widget>[
          Center(
            child: Container(
              decoration: new BoxDecoration(
                image: new DecorationImage(
                  image: new AssetImage(
                    'assets/images/rock-climbing-indoor-2.jpg',
                  ),
                  fit: BoxFit.scaleDown,
                ),
              ),
            ),
          ),
          Center(
              child: /*new Text('Welcome $username!'),*/
                  new RaisedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/dashboard_screen');
            },
            child: new Text('Continue'),
          )),
        ],
      ),
    );
  }
}
