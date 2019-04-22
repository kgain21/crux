import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crux/screens/hangboard/exercise_page_view.dart';
import 'package:crux/shared_layouts/app_bar.dart';
import 'package:crux/utils/base_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HangboardWorkoutScreen extends StatefulWidget {
  final String title;
  final BaseAuth auth;
  final Firestore firestore;

  @override
  State<StatefulWidget> createState() => new _HangboardWorkoutScreenState();

  HangboardWorkoutScreen({this.title, this.auth, this.firestore});
}

class _HangboardWorkoutScreenState extends State<HangboardWorkoutScreen> {
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
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(
                  'Your Hangboard Workouts:',
                  style: Theme.of(context).textTheme.title,
                  textAlign: TextAlign.start,
                ),
              ),
              StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance.collection('/hangboard').snapshots(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.none:
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: const Text('Retrieving workouts...'),
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
                      return Flexible(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: (snapshot.data.documents.length + 1),
                            itemBuilder: (context, index) {
                              if (index == snapshot.data.documents.length) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: RaisedButton(
                                    onPressed: () {
                                      showModalBottomSheet(
                                          context: context,
                                          builder: (context) => BottomSheet(
                                                onClosing: () {},
                                                builder: (context) {
                                                  return Center(
                                                    child: ConstrainedBox(
                                                      constraints:
                                                          BoxConstraints(
                                                              maxWidth: 100.0,
                                                              maxHeight: 100.0),
                                                      child: TextField(),
                                                    ),
                                                  );
                                                },
                                              ));
                                    },
                                    child: const Text('Add Workout'),
                                  ),
                                );
                              }
                              return HangboardWorkoutTile(
                                  snapshot: snapshot,
                                  index: index,
                                  auth: widget.auth);
                            },
                          ),
                        ),
                      );
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class HangboardWorkoutTile extends StatefulWidget {
  final BaseAuth auth;
  final AsyncSnapshot snapshot;
  final int index;

  HangboardWorkoutTile({this.snapshot, this.index, this.auth}) : super();

  @override
  State<StatefulWidget> createState() => _HangboardWorkoutTileState();
}

class _HangboardWorkoutTileState extends State<HangboardWorkoutTile> {
  final Icon _arrowIcon = Icon(Icons.chevron_right);
  bool _isEditing;

  @override
  void initState() {
    super.initState();
    _isEditing = false;
  }

  @override
  Widget build(BuildContext context) {
    return workoutTile(widget.snapshot, widget.index);
  }

  Widget workoutTile(AsyncSnapshot snapshot, int index) {
    var workoutTitle = snapshot.data.documents[index].documentID;
    return Card(
      child: ListTile(
        title: Text(workoutTitle),
        trailing: !_isEditing ? _arrowIcon : interactiveCloseIcon(),
        onLongPress: () {
          setState(() {
            _isEditing = true;
          });
        },
        onTap: () {
          if (_isEditing) {
            setState(() {
              _isEditing = false;
            });
          } else {
            Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                return ExercisePageView(
                  title: workoutTitle,
                  collectionReference: Firestore.instance
                      .collection('hangboard/$workoutTitle/exercises'),
                  auth: widget.auth,
                  workoutId: index.toString(),
                );
              },
            ));
          }
        },
      ),
    );
  }

  Widget interactiveCloseIcon() {
    return GestureDetector(
      child: Icon(Icons.close),
      onTap: () {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Text(
                  'Workout deleted!',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              );
            });
        setState(() {
          _isEditing = false;
        });
      },
    );
  }
}
