import 'package:flutter/material.dart';

class SharedAppBar {
  static AppBar sharedAppbar(
      String title, VoidCallback callback, BuildContext context) {
    return new AppBar(
      title: new Text(title),
      actions: <Widget>[
        PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'signOut') {
              callback();
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
                child: new Text('test 2'),
                value: 'test2',
              ),
            ];
          },
        ),
      ],
    );
  }
}
