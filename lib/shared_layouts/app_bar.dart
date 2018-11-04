import 'package:crux/utils/base_auth.dart';
import 'package:flutter/material.dart';

class SharedAppBar {
  static AppBar sharedAppBar(
      String title, BaseAuth auth, BuildContext context) {
    return new AppBar(
      //backgroundColor: Color.fromARGB(255, 103, 126, 116),
      title: new Text(title),
      actions: <Widget>[
        PopupMenuButton<String>(
          onSelected: (value) {
            //TODO: switch statement for more menuButtons
            if (value == 'signOut') {
              auth.signOut(context);
              Navigator.popUntil(context, ModalRoute.withName('/'));
            } else {
              print('pressed test2 button');
            }
          },
          itemBuilder: (BuildContext context) {
            return <PopupMenuItem<String>>[
              new PopupMenuItem(
                child: new Text('Sign Out'),
                value: 'signOut',
              ),
              new PopupMenuItem(
                child: new Text('Settings'),
                value: 'test2',
              ),
            ];
          },
        ),
      ],
    );
  }
}
