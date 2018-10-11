import 'package:crux/shared_layouts/app_bar.dart';
import 'package:crux/utils/base_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DashboardScreen extends StatefulWidget {
  final String title;
  final BaseAuth auth;

  DashboardScreen({Key key, this.title, this.auth}) : super(key: key);

  @override
  _DashboardScreenState createState() => new _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar:
          SharedAppBar.sharedAppBar(widget.title, widget.auth, this.context),
      body: new Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Text('Made it to dashboard!'),
                  new RaisedButton(
                    onPressed: () =>
                        Navigator.pushNamed(context, '/stopwatch_screen'),
                    child: new Text('Stopwatch'),
                  ),
                  new RaisedButton(
                    onPressed: () =>
                        Navigator.pushNamed(context, '/rep_list_screen'),
                    child: new Text('Rep List'),
                  ),
                  new RaisedButton(
                    onPressed: null,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Text('Column 2'),
                  new RaisedButton(
                    onPressed: null,
                  ),
                  new RaisedButton(
                    onPressed: null,
                  ),
                  new RaisedButton(
                    onPressed: null,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _DashboardScreenState();
}
