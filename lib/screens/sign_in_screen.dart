import 'package:crux/screens/dashboard_screen.dart';
import 'package:crux/screens/welcome_screen.dart';
import 'package:crux/utils/base_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SignInScreen extends StatefulWidget {
  SignInScreen({Key key, this.title, this.auth}) : super(key: key);

  final String title;
  final BaseAuth auth;

  @override
  _SignInScreenState createState() => new _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      /*appBar: new AppBar(
        title: new Text(widget.title),
      ),*/
      body: signInWidget(context),
    );
  }

  Widget signInWidget(BuildContext context) {
    return Builder(
      builder: (context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: Text(
                'Welcome to Crux',
                style: TextStyle(
                    fontSize: Theme.of(context).textTheme.headline.fontSize),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(0.0),
              child: Container(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height / 3.0,
                  maxHeight: MediaQuery.of(context).size.height / 2.25,
//                  minWidth: MediaQuery.of(context).size.width / 2.0,
                  maxWidth: MediaQuery.of(context).size.width,
//                  maxWidth: MediaQuery.of(context).size.width / 1.0,
                ),
                decoration: new BoxDecoration(
//                  borderRadius: BorderRadius.circular(20.0),
                  image: new DecorationImage(
                    image: new AssetImage(
                      'assets/images/rock-climbing-indoor-2.jpg',
                    ),
                    fit: BoxFit.scaleDown,
                  ),
                ),
              ),
            ),
            buttonGroup(),
          ],
        );
      },
    );
  }

  Widget buttonGroup() {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            signInButton(),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              guestButton(),
            ],
          ),
        )
      ],
    );
  }

  Widget signInButton() {
    return Container(
      constraints:
          BoxConstraints(minWidth: MediaQuery.of(context).size.width * 0.65),
      child: RaisedButton(
        shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(30.0),
        ),
        color: Theme.of(context).accentColor,
        child: const Text('Sign in'),
        elevation: 4.0,
        onPressed: () {
          widget.auth
              .signInWithGoogleEmailAndPassword()
              .then((FirebaseUser user) {
            String username = user.displayName.split(' ')[0];
            /*showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    content: Text(
                      'Welcome $username',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  );
                });*/
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DashboardScreen(
                      title: widget.title,
                      username: username,
                    ),
              ),
            ); //TODO: Smooth fade in with 'Welcome $User'
          }).catchError(
            (e) => showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    content: Text(
                      'Sign in failed. Please try again or continue as a guest.',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  );
                }),
          );
        },
      ),
    );
  }

  Widget guestButton() {
    return Container(
      constraints:
          BoxConstraints(minWidth: MediaQuery.of(context).size.width * 0.65),
      child: FlatButton(
        color: Theme.of(context).buttonColor,
        shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(30.0),
        ),
        child: const Text('Continue as a guest'),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  DashboardScreen(title: widget.title, username: ''),
            ),
          ); //TODO: Smooth fade in with 'Welcome $User'
        },
      ),
    );
  }
}
