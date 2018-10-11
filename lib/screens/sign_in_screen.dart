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
      appBar: new AppBar(
        //TODO: different appbar here?
        //backgroundColor: Color.fromARGB(255, 103, 126, 116),
        title: new Text(widget.title),
      ),
      body: Container(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Center(
              child: new RaisedButton(
                  //color: Color.fromARGB(255, 146, 164, 172),
                  //color: Color.fromARGB(255, 221, 219, 219),
                  child: const Text('SIGN IN'),
                  onPressed: () {
                    //TODO: Find way to prevent people from clicking more than once
                    widget.auth.signInWithGoogleEmailAndPassword().then(
                        (FirebaseUser user) {
                      String username = user.displayName
                          .split(' ')[0]; //todo: unit tests around this?
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WelcomeScreen(
                              title: widget.title, username: username),
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
      ),
    );
  }
}
