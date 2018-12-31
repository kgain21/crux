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
      body: Builder(
        builder: (context) {
          return new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              signInWidget(context),
            ],
          );
        },
      ),
    );
  }

  Widget signInWidget(BuildContext context) {
    return new Center(
      child: new RaisedButton(
        //color: Color.fromARGB(255, 146, 164, 172),
        //color: Color.fromARGB(255, 221, 219, 219),
        child: const Text('SIGN IN'),
        onPressed: () {
          //TODO: Find way to prevent people from clicking more than once
          widget.auth
              .signInWithGoogleEmailAndPassword()
              .then((FirebaseUser user) {
            String username =
                user.displayName.split(' ')[0]; //todo: unit tests around this?
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    WelcomeScreen(title: widget.title, username: username),
              ),
            ); //TODO: pass username to a welcome screen? Smooth fade in with 'Welcome $User'
          }).catchError(
            (e) => showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    content: Text(
                      'Sign in failed. Please try again or continue as a guest.',
                      style: TextStyle(color: Colors.black,),
                      textAlign: TextAlign.center,
                    ),
                  );
                }),

            /* showModalBottomSheet(
                context: context,
                builder: (context) => BottomSheet(
                      onClosing: () {},
                      builder: (context) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(child: Text('Sign in failed.', style: TextStyle(color: Colors.black),),),
                        );
                      },
                    )),*/
            /*Scaffold.of(context).showSnackBar(
                  SnackBar(
                    duration: const Duration(seconds: 3),
                    content: Center(
                      child: Text(
                          'Sign in failed. Please try again or continue as a guest.'),
                    ),
                  ),
                ),*/
          ); //TODO: make this a toast/snackbar message
        },
        //TODO: make app wide button theme with more rounded corners
      ),
    );
  }
}
