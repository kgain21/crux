import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crux/screens/exercise_screen.dart';
import 'package:crux/shared_layouts/app_bar.dart';
import 'package:crux/shared_layouts/fab_bottom_app_bar.dart';
import 'package:crux/utils/base_auth.dart';
import 'package:crux/widgets/exercise_form_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class WorkoutScreen extends StatefulWidget {
  final String title;
  final BaseAuth auth;
  final Firestore firestore;

  @override
  State<StatefulWidget> createState() => new _WorkoutScreenState();

  WorkoutScreen({this.title, this.auth, this.firestore});
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar:
          SharedAppBar.sharedAppBar(widget.title, widget.auth, this.context),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          StreamBuilder<QuerySnapshot>(
            stream: widget.firestore.collection('/hangboard').snapshots(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                case ConnectionState.none:
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
                  //TODO: make these draggable on edit
                  return new Flexible(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (context, index) {
                        return Draggable(
                          axis: Axis.horizontal,
                          child: workoutTile(snapshot, index),
                          feedback: workoutTile(snapshot, index),
                          childWhenDragging: new Container(),
                        );
                      },
                    ),
                  );
              }
            },
          ),
          //TODO: make this an overlay? could be difficult w/ multiple sets/exercises - maybe just a new screen
          RaisedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return ExerciseFormTile(
                    formKey: new GlobalKey<FormState>(),
                    exerciseTitle: 'exerciseTitle',
                    workoutTitle: 'workouttitle',
                  );
                }),
              );
            },
            child: Text('Add Workout'),
          ),
        ],
      ),
      bottomNavigationBar: new FABBottomAppBar(
        backgroundColor: Colors.white,
        //Color.fromARGB(255, 229, 191, 126),
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
        child: Icon(Icons.edit),
        backgroundColor: Color.fromARGB(255, 44, 62, 80),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget workoutTile(AsyncSnapshot snapshot, int index) {
    return new Card(
      child: ListTile(
        title: Text(snapshot.data.documents[index].documentID),
        trailing: Icon(Icons.menu),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) {
              return new ExerciseScreen(
                title: '${snapshot.data.documents[index].documentID} Exercises',
                snapshot: snapshot.data.documents[index],
                auth: widget.auth,
              );
            },
          ));
        },
      ),
    );
  }
}
