import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crux/screens/create_hangboard_workout_tab.dart';
import 'package:crux/screens/edit_hangboard_workout_tab.dart';
import 'package:crux/screens/hangboard_workout_list_tab.dart';
import 'package:crux/shared_layouts/bottom_nav_bar.dart';
import 'package:crux/utils/base_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HangboardWorkoutScreen extends StatefulWidget {
  final String title;
  final BaseAuth auth;
  final Firestore firestore;

  //TODO: going to have to make sure this syncs offline***
  //TODO: can i access firestore statically? Do i need to pass it as var to different screens?

  HangboardWorkoutScreen({Key key, this.title, this.auth, this.firestore})
      : super(key: key);

  @override
  _HangboardWorkoutScreenState createState() =>
      new _HangboardWorkoutScreenState();
}

class _HangboardWorkoutScreenState extends State<HangboardWorkoutScreen>
    with TickerProviderStateMixin {
  Stopwatch stopwatch = new Stopwatch();
  CollectionReference maxHangs;
  DocumentSnapshot snapshot;

  //AsyncMemoizer _memoizer = AsyncMemoizer();

  TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this, initialIndex: 1);
  }

  @override
  Widget build(BuildContext context) {
    var appBarTabs = TabBar(
      tabs: <Tab>[
        Tab(
          icon: Icon(Icons.edit),
          text: 'Edit',
        ),
        Tab(
          icon: Icon(Icons.list),
          text: 'Workout',
        ),
        Tab(
          icon: Icon(Icons.add),
          text: 'Add',
        ),
      ],
      controller: tabController,
    );

    return new Scaffold(
      appBar: AppBar(
        bottom: appBarTabs,
      ),
      /*SharedAppBar.sharedAppBar(
            widget.title,
            widget.auth,
            this.context,
          ),*/
      body: TabBarView(
        controller: tabController,
        children: <Widget>[
          EditHangboardWorkoutTab(),
          HangboardWorkoutListTab(),
          CreateHangboardWorkoutTab(),
        ],
      ),
      bottomNavigationBar: SharedBottomNavBar(),
    );
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }
}
