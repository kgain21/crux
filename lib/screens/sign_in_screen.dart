import 'dart:async';

import 'package:crux/screens/welcome_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignInScreen extends StatefulWidget {
  SignInScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SignInScreenState createState() => new _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = new GoogleSignIn();
  Future<String> _message = new Future<String>.value('');

  Future<FirebaseUser> _testSignInWithGoogle() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final FirebaseUser user = await _firebaseAuth.signInWithGoogle(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    assert(user.email != null);
    assert(user.displayName != null);
    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _firebaseAuth.currentUser();
    assert(user.uid == currentUser.uid);
    return user;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Center(
            child: new RaisedButton(
                child: const Text('SIGN IN'),
                onPressed: () {
                  _testSignInWithGoogle().then((FirebaseUser user) {
                    String username = user.displayName
                        .split(' ')[0]; //todo: unit tests around this?
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WelcomeScreen(username: username),
                      ),
                    ); //TODO: pass username to a welcome screen? Smooth fade in with 'Welcome $User'
                    //todo: SIGN OUT OPTION
                  }).catchError((e) => print(
                      'Sign in failed. Please try again.')); //TODO: make this a toast/snackbar message
                }),
          ),
          /*new FutureBuilder<String>(
              future: _message,
              builder: (_, AsyncSnapshot<String> snapshot) {
                return new Text(snapshot.data ?? '',
                    style:
                    const TextStyle(color: Color.fromARGB(255, 0, 155, 0)));
              }),*/
        ],
      ),
    );
  }
}
