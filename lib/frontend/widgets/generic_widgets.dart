import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class GenericWidgets {
  static void createGenericSnackbar(
      BuildContext scaffoldContext, String snackbarText) {
    Scaffold.of(scaffoldContext).showSnackBar(
      SnackBar(
        backgroundColor: Theme.of(scaffoldContext).accentColor,
        duration: Duration(seconds: 2),
        elevation: 2.0,
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  snackbarText,
                  style: TextStyle(
                      color: Theme.of(scaffoldContext).textTheme.title.color),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
