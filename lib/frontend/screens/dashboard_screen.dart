import 'package:crux/backend/services/base_auth.dart';
import 'package:crux/frontend/screens/calendar_screen.dart';
import 'package:crux/frontend/shared_layouts/app_bar.dart';
import 'package:crux/frontend/shared_layouts/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DashboardScreen extends StatefulWidget {
  final String title;
  final BaseAuth auth;
  final String username;

  DashboardScreen({Key key, this.title, this.auth, this.username})
      : super(key: key);

  @override
  _DashboardScreenState createState() => new _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  //todo: this map should be passed in given the day ->
  final Map<String, List<Object>> screenMap = {
//    'Profile': null,
    'Warmup': [
      '/warmup_screen', 'assets/images/stretching-01.jpg', Color(0xFF42b983)],
    'Hangboard': [
      '/hangboard_workout_screen',
      'assets/images/hangboard-01.jpg', Color(0xFF22a2c9)
    ],
    'Campus': [
      '/campus_screen', 'assets/images/campus-board-01.jpg', Color(0xFFFF6666)],
    'Weight Lifting': [
      '/weight_lifting_screen',
      'assets/images/weightlifting-01.jpg',
      Color(0xFFc08b30),
      Color(0xFFe96900),

    ],
//    'ARC Training': null /*'/arc_training_workout_screen'*/,
//    '4 x 4s': null,
//    'Stopwatch': ['/stopwatch_screen', ''],
//    'Workouts': ['/workout_screen',''],
//    'Test2': null,
//    'Test3': null,
  };

  List<String> screenMapKeys;
  String _username;

  //FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    screenMapKeys = screenMap.keys.toList();
    _username = widget.username ?? 'Guest';
    //_focusNode = new FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: dashboardDrawer(),
      appBar: SharedAppBar.sharedAppBar('Dashboard', widget.auth, context),
      body: workoutListView(),
      bottomNavigationBar: SharedBottomNavBar(),
    );

    //TODO: play with this at some point
    // https://www.youtube.com/watch?v=ORiTTaVY6mM&index=12&list=PLOU2XLYxmsIL0pH0zWe_ZOHgGhZ7UasUE
  }

  Widget workoutListView() {
    return ListView(
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                '${widget.username.split(' ')[0]}\'s Profile',
                style: TextStyle(fontSize: 25.0),
              ),
            ),
            CalendarScreen(),
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Text(
                'Today\'s workout:',
                style: TextStyle(fontSize: 20.0),
              ),
            ),
            todaysWorkoutRow(),
          ],
        ),
      ],
    );
  }

  Widget todaysWorkoutRow() {
    return Padding(
      padding:
          const EdgeInsets.only(left: 10.0, top: 8.0, right: 0.0, bottom: 8.0),
      child: Container(
        constraints: BoxConstraints(
          minWidth: MediaQuery.of(context).size.width,
          maxWidth: MediaQuery.of(context).size.width,
          minHeight: MediaQuery.of(context).size.height / 6.0,
          maxHeight: MediaQuery.of(context).size.height / 5.0,
        ),
        child: ListView.builder(
          itemCount: screenMap.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                    context, screenMap.values.elementAt(index)[0]);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  alignment: Alignment.bottomLeft,
                  decoration: new BoxDecoration(
                    color: screenMap.values.elementAt(index)[2],
                    borderRadius: BorderRadius.all(Radius.circular(6.0)),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        blurRadius: 1.0,
                      )
                    ],
                    /*image: new DecorationImage(
                      fit: BoxFit.fill,
                      image: new AssetImage(
                        screenMap.values.elementAt(index)[1],
                      ),
                    ),*/
                  ),
                  constraints: BoxConstraints(
                    minWidth: MediaQuery.of(context).size.width / 2.0,
                    maxWidth: MediaQuery.of(context).size.width / 2.0,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      screenMapKeys[index],
//                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            );
          },
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
        ),
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
              child: Text('$_username'),
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

  _DashboardScreenState();
}
