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
  };

  List<String> screenMapKeys;
  OverlayEntry _overlayEntry;
  bool _overlayVisible;

  //FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    screenMapKeys = screenMap.keys.toList();
    _overlayVisible = false;
    //_focusNode = new FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: dashboardDrawer(),
      appBar: SharedAppBar.sharedAppBar('Dashboard', widget.auth, context),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: Material(
                child: new Calendar(
                  /*dayBuilder: (context, dateTime) {
                    if(dateTime.day == DateTime.now().day) {
                      calendarTile(true);//TODO: need to put this in it's own widget to have selected property
                    }
                    return Material(
                      child: InkWell(
                        onTap: () {

                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(4.0)),
                            border: Border.all(color: Colors.black38)
                          ),
                          child: new Text(dateTime.day.toString()),
                        ),
                      ),
                    );
                  },*/
                  isExpandable: true,
                  onSelectedRangeChange: (range) =>
                      print("Range is ${range.item1}, ${range.item2}"),
                  onDateSelected: (date) {
                    /* FocusScope.of(context).requestFocus(_focusNode);
                    _focusNode.addListener(() {
                      if(!_focusNode.hasFocus)
                        this._overlayEntry.remove();
                    });*/
                    handleNewDate(date);
                  },
                ),
              ),
            ),
          ),
          Text(
            'Today\'s workout:',
            style: TextStyle(fontSize: 20.0),
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
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
                                icon: Icon(
                                  Icons.timer,
                                ),
                                hintText: 'Start Time',
                              ),
                            ),
                          ),
                        ),
                        Card(
                          child: new ListTile(
                            title: new Text(
                              'Limit Boulder',
                            ),
                            trailing: new Icon(Icons.chevron_right),
                          ),
                        ),
                        Card(
                          child: new ListTile(
                            title: new Text(
                              'Hangboard',
                            ),
                            trailing: new Icon(Icons.chevron_right),
                            onTap: () =>
                                Navigator.pushNamed(context, '/workout_screen'),
                          ),
                        ),
                        Card(
                          child: new ListTile(
                            title: new Text(
                              'Abs',
                            ),
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
          ),
          /*Flexible(
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
          )*/
        ],
      ),
    );
  }

  Widget dashboardDrawer() {
    return Drawer(
      child: ListView(
        children: <Widget>[
          //TODO: what do i want common across all screens?
          Container(
            color: Theme.of(context).accentColor,
            child: DrawerHeader(
              child: Text('Drawer Header'),
            ),
          ),
          ListTile(
            title: Text(
              'Profile',
            ),
          ),
          ListTile(
            title: Text(
              'Hangboard',
            ),
            onTap: () {
              //Pop drawer before navigating so that it doesn't remain when returning
              Navigator.pop(context);
              Navigator.pushNamed(context, '/hangboard_workout_screen');
            },
          ),
          ListTile(
            title: Text(
              'Spotify',
            ),
            onTap: () {
              //Pop drawer before navigating so that it doesn't remain when returning
              Navigator.pop(context);
              Navigator.pushNamed(context, '/spotify_test_screen');
            },
          ),
          ListTile(
            title: Text(
              'Campus',
            ),
          ),
          ListTile(
            title: Text(
              'Progress',
            ),
          ),
        ],
      ),
    );
  }

  void handleNewDate(DateTime date) {
    //TODO: format date in overlay better

    //TODO: Link workouts here (look at #3 in link below)
    //https://pub.dartlang.org/packages/flutter_calendar#-readme-tab-
    print("handleNewDate $date");
    this._overlayEntry = createOverlayEntry(date);
    Overlay.of(context).insert(_overlayEntry);
  }

  OverlayEntry createOverlayEntry(DateTime date) {
    RenderBox renderBox = context.findRenderObject();
    var size = renderBox.size;

    return OverlayEntry(builder: (context) {
      return Positioned(
        width: size.width / 1.5,
        height: size.height / 3.0,
        left: size.width / 6.0,
        top: size.height / 4.0,
        child: Card(
          child: Column(
            children: <Widget>[
              GestureDetector(
                onTap: () => _overlayEntry.remove(),
                child: Icon(
                  Icons.cancel,
                ),
              ),
              Text(
                '${date.toString()}',
                //TODO: going to need to go to db to find workout assoc w/ this day
                //TODO: if nothing there, option to create new or select from premade workouts
//                style: TextStyle(fontSize: 12.0, color: Colors.black),
              ),
            ],
          ),
        ),
      );
    });
  }

  _DashboardScreenState();
}
