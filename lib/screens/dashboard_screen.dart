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
  final Map<String, String> screenMap = {
    'Profile': null,
    'Hangboard': '/hangboard_workout_screen',
    'Campus Board': null,
    /*'/campus_workout_screen',*/
    'ARC Training': null /*'/arc_training_workout_screen'*/,
    '4 x 4s': null,
    'Stopwatch': '/stopwatch_screen',
  };

  List<String> screenMapKeys;

  @override
  void initState() {
    super.initState();
    screenMapKeys = screenMap.keys.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          SharedAppBar.sharedAppBar(widget.title, widget.auth, this.context),
      body: GridView.builder(
          itemCount: screenMapKeys.length,
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          itemBuilder: (context, index) {
            return GestureDetector(
              child: Card(
                elevation: 5.0,
                child: Container(
                  alignment: Alignment.center,
                  child: Text('${screenMapKeys[index]}'),
                ),
              ),
              onTap: () {
                Navigator.pushNamed(context, screenMap[screenMapKeys[index]]);
              },
            );
          }),
      /*new Container(
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
                    child: new Text('Workouts'),
                  ),
                  new RaisedButton(
                    onPressed: () =>
                        Navigator.pushNamed(context, '/countdown_timer_screen'),
                    child: new Text('Countdown Timer'),
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
      ),*/
    );
  }

  _DashboardScreenState();
}
