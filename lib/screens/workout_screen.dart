import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crux/screens/exercise_page_view.dart';
import 'package:crux/screens/exercise_screen.dart';
import 'package:crux/shared_layouts/app_bar.dart';
import 'package:crux/shared_layouts/fab_bottom_app_bar.dart';
import 'package:crux/utils/base_auth.dart';
import 'package:crux/widgets/exercise_form.dart';
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
      body: Stack(
        children: <Widget>[
          Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance.collection('/hangboard').snapshots(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.none:
                      return Padding(
                        padding: const EdgeInsets.all(15.0),
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
                      );
                    default:
                      //TODO: make these draggable on edit
                      return new Flexible(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data.documents.length,
                          itemBuilder: (context, index) {
                            return workoutTile(snapshot, index);
                          },
                        ),
                      );
                  }
                },
              ),
              //TODO: make this an overlay? could be difficult w/ multiple sets/exercises - maybe just a new screen
              RaisedButton(
                onPressed: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (context) => BottomSheet(
                            onClosing: () {},
                            builder: (context) {
                              return Center(
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(
                                      maxWidth: 100.0, maxHeight: 100.0),
                                  child: TextField(),
                                ),
                              );
                            },
                          ));
                },
                child: Text('Add Workout'),
              ),
            ],
          ),
        ],
      ),
      /*bottomNavigationBar: new FABBottomAppBar(
//        backgroundColor: Colors.blueGrey,
//        color: Colors.black54,
//        selectedColor: Colors.black,
        items: <FABBottomAppBarItem>[
          FABBottomAppBarItem(
            iconData: Icons.home,
            text: 'Home',
          ),
          */ /*FABBottomAppBarItem(
            iconData: Icons.menu,
            text: 'Menu',
          ),*/ /*
        ],
        onTabSelected: (index) {
          if (index == 0) {
            Navigator.popUntil(
                context, ModalRoute.withName('/dashboard_screen'));
          } else {
            return null;
          }
        },
      ),*/
      /*floatingActionButton: FloatingActionButton(
//        backgroundColor: Colors.blueGrey,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) {
              return ExerciseForm(
                workoutTitle: 'workouttitle',
              );
            }),
          );
        },
        child: Icon(Icons.edit),
        //backgroundColor: Color.fromARGB(255, 44, 62, 80),
      ),*/
      //floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      //bottomSheet: new BottomSheet(onClosing: null, builder: null),
    );
  }

  Widget workoutTile(AsyncSnapshot snapshot, int index) {
    var workoutTitle = snapshot.data.documents[index].documentID;
    return new Card(
      child: ListTile(
        title: Text(workoutTitle),
        trailing: Icon(Icons.chevron_right),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) {
              return new ExercisePageView(
                title: workoutTitle,
                collectionReference:
                    Firestore.instance.collection('hangboard/$workoutTitle/exercises'),
                auth: widget.auth,
              );
            },
          ));
        },
      ),
    );
  }
}
