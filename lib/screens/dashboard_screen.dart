import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DashboardScreen extends StatefulWidget {
  final String title;

  DashboardScreen({Key key, this.title}) : super(key: key);

  @override
  _DashboardScreenState createState() => new _DashboardScreenState(title);
}

class _DashboardScreenState extends State<DashboardScreen> {
  final String title;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(title),
      ),
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
                        Navigator.pushNamed(context, 'stopwatch_screen'),
                    child: new Text('Stopwatch'),
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

  _DashboardScreenState(this.title);
}
