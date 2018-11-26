import 'package:crux/shared_layouts/app_bar.dart';
import 'package:crux/utils/base_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_calendar/flutter_calendar.dart';

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
    'Workouts': '/workout_screen',
    'Test2': null,
    'Test3': null,
    'Test4': null,
    'Test5': null,
    'Test6': null,
    'Test7': null,
    //todo: add calendar view
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
      body: Column(
        children: <Widget>[
          Card(
            child: new Calendar(
              /*dayBuilder: (context, dateTime) {
                new Text('!');
              },*/
              isExpandable: true,
              onSelectedRangeChange: (range) =>
                  print("Range is ${range.item1}, ${range.item2}"),
              onDateSelected: (date) => handleNewDate(date),
            ),
          ),
          Flexible(
            child: CustomScrollView(
              shrinkWrap: true,
              controller: new ScrollController(),
              slivers: <Widget>[
                SliverList(
                  delegate: new SliverChildListDelegate(
                    [
                      Card(
                        child: new ListTile(
                          title: new TextFormField(
                            keyboardType: TextInputType.numberWithOptions(),
                            decoration: InputDecoration(
                              icon: Icon(Icons.timer),
                              hintText: 'Start Time',
                              //helperText: 'Unit: $_depthMeasurementSystem.',
                            ),
                          ),
                        ),
                      ),
                      Card(
                        child: new ListTile(
                          title: new Text('Limit Boulder'),

                          trailing: new Icon(Icons.chevron_right),
                        ),
                      ),
                      Card(
                        child: new ListTile(
                          title: new Text('Hangboard'),
                          trailing: new Icon(Icons.chevron_right),
                        ),
                      ),
                      Card(
                        child: new ListTile(
                          title: new Text('Abs'),
                          trailing: new Icon(Icons.chevron_right),
                        ),
                      ),
                      Card(
                        child: new ListTile(
                          title: new Text('Weight Lifting'),
                          trailing: new Icon(Icons.chevron_right),
                        ),
                      ),
                      Card(
                        child: new ListTile(
                          title: new Text('Stretching'),
                          trailing: new Icon(Icons.chevron_right),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            child: CustomScrollView(
              shrinkWrap: true,
              controller: new ScrollController(),
              slivers: <Widget>[
                SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return GestureDetector(
                        child: Card(
                          elevation: 5.0,
                          child: Container(
                            alignment: Alignment.center,
                            child: Text('${screenMapKeys[index]}'),
                          ),
                        ),
                        onTap: () {
                          Navigator.pushNamed(
                              context, screenMap[screenMapKeys[index]]);
                        },
                      );
                    },
                    childCount: screenMapKeys.length,
                  ),
                ),
                //TODO: play with this at some point
                // https://www.youtube.com/watch?v=ORiTTaVY6mM&index=12&list=PLOU2XLYxmsIL0pH0zWe_ZOHgGhZ7UasUE
              ],
            ),
          )
        ],
      ),
    );
  }

  void handleNewDate(date) {
    //TODO: Link workouts here (look at #3 in link below)
    //https://pub.dartlang.org/packages/flutter_calendar#-readme-tab-
    print("handleNewDate ${date}");
  }

  _DashboardScreenState();
}
