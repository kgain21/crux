import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crux/screens/exercise_tab.dart';
import 'package:crux/shared_layouts/fab_bottom_app_bar.dart';
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
  //AsyncMemoizer _memoizer = AsyncMemoizer();


  TabController tabController;
  int _exerciseLength;

  @override
  void initState() {
    super.initState();
    //TODO: tabControllerBuilder for n number of exercises, possibly a future of length of exercise list from firebase?
    //await getExerciseLength();
    tabController = TabController(length: 3, vsync: this, initialIndex: 1);
  }

  //TODO: Left off here 1/15 - trying to add n number of tabs but not sure if that's possible yet
  Future<void> getExerciseLength() async {

    int exerciseLength = await widget.firestore.collection('hangboard').document('Max Hangs').snapshots().length;

    setState(() {
      _exerciseLength = exerciseLength;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text('Hangboard'),
        bottom: appBarTabs(),
      ),
      body: TabBarView(
        key: new PageStorageKey<String>('Hangboard'),
        controller: tabController,
        children: <Widget>[
          new StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance.collection('hangboard').snapshots(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Card(
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Retrieving workouts...'),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                default:
                  return ExerciseTab();


              /*Expanded(
                    child: ListView.builder(
                      controller: new ScrollController(),
                      //List of all workouts
                      key: PageStorageKey('WorkoutListBuilder'),
                      shrinkWrap: true,
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (context, docIndex) {
                        return exerciseListBuilder(snapshot, docIndex);
                      },
                    ),
                  );*/
              }
            },
          ),

          /*EditHangboardWorkoutTab(),
          HangboardWorkoutListTab(),
          CreateHangboardWorkoutTab(),*/
        ],
      ),
      bottomNavigationBar: FABBottomAppBar(
        backgroundColor: Color.fromARGB(255, 217, 236, 255),
        color: Colors.black54,
        selectedColor: Colors.black,
        items: <FABBottomAppBarItem>[
          FABBottomAppBarItem(
            iconData: Icons.home,
            text: 'Home',
          ),
          FABBottomAppBarItem(
            iconData: Icons.menu,
            text: 'Menu',
          ),
        ],
        onTabSelected: (index) {
          if (index == 0) {
            Navigator.popUntil(
                context, ModalRoute.withName('/dashboard_screen'));
          } else {
            return null;
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          null;
        },
        child: Icon(Icons.add),
        backgroundColor: Color.fromARGB(255, 44, 62, 80),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget appBarTabs() {
    return TabBar(
      tabs: <Tab>[
        Tab(
          //icon: Icon(Icons.edit),
          text: 'Edit',
        ),
        Tab(
          //icon: Icon(Icons.list),
          text: 'Workout',
        ),
        Tab(
          //icon: Icon(Icons.add),
          text: 'Add',
        ),
      ],
      controller: tabController,
    );
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }
}
