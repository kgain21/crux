import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crux/backend/models/hangboard/hangboard_workout.dart';
import 'package:crux/backend/repository/firestore_hangboard_workouts_repository.dart';
import 'package:crux/backend/repository/hangboard_workouts_repository.dart';
import 'package:crux/backend/services/base_auth.dart';
import 'package:crux/presentation/shared_layouts/app_bar.dart';
import 'package:crux/presentation/widgets/exercise_tile.dart';
import 'package:crux/presentation/widgets/hangboard_workout_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HangboardWorkoutScreen extends StatefulWidget {
  final String title;
  final BaseAuth auth;
  final HangboardWorkoutsRepository firestoreHangboardWorkoutsRepository;

  @override
  State<StatefulWidget> createState() => new _HangboardWorkoutScreenState();

  HangboardWorkoutScreen(
      {this.title, this.auth, this.firestoreHangboardWorkoutsRepository});
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
                  style: Theme
                      .of(context)
                      .textTheme
                      .title,
                  textAlign: TextAlign.start,
                ),
              ),
              StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance.collection('/hangboard').snapshots(),
                builder: (scaffoldContext, snapshot) {
                  switch(snapshot.connectionState) {
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
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: (snapshot.data.documents.length + 1),
                          itemBuilder: (context, index) {
                            if(index == snapshot.data.documents.length) {
                              return addWorkoutButton(scaffoldContext);
                            }
                            return HangboardWorkoutTile(
                              snapshot: snapshot,
                              index: index,
                            );
                          },
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

  /*void saveWorkoutToFirebase(String workoutTitle,
                             BuildContext scaffoldContext) {
    CollectionReference collectionReference =
    Firestore.instance.collection('hangboard');

    var workoutRef = collectionReference.document(workoutTitle);
    workoutRef.get().then((doc) {
      if(doc.exists) {
        _exerciseExistsAlert(scaffoldContext, workoutTitle);
      } else {
        workoutRef.setData(Map());
        exerciseSavedSnackbar(scaffoldContext);
      }
    });
  }*/

  Future<void> _exerciseExistsAlert(BuildContext scaffoldContext,
                                    String workoutTitle) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Workout already exists'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                RichText(
                  text: TextSpan(
                    style: TextStyle(color: Colors.black, fontSize: 16.0),
                    children: [
                      TextSpan(
                          text: 'You already have a workout created called '),
                      TextSpan(
                        text: '$workoutTitle.\n\n',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: 'Please enter a different name.'),
                    ],
                  ),
                )
              ],
            ),
          ),
          actions: <Widget>[
            Row(
              children: <Widget>[
                FlatButton(
                  child: Text(
                    'Ok',
                    style: TextStyle(color: Theme
                        .of(context)
                        .accentColor),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void exerciseSavedSnackbar(BuildContext scaffoldContext) {
    Scaffold.of(scaffoldContext).showSnackBar(
      SnackBar(
        duration: Duration(seconds: 3),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Workout Saved!',
                      style: TextStyle(
                          color: Theme
                              .of(scaffoldContext)
                              .accentColor),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget addWorkoutButton(BuildContext scaffoldContext) {
    return ExerciseTile(
      tileColor: Theme
          .of(context)
          .primaryColor,
      child: FlatButton(
        color: Theme
            .of(context)
            .primaryColor,
        onPressed: () {
          addWorkoutDialog(scaffoldContext);
        },
        child: const Text('Add Workout'),
      ),
    );
  }

  void addWorkoutDialog(BuildContext scaffoldContext,
                        HangboardWorkout hangboardWorkout) {
    showDialog(
      context: context,
      builder: (context) {
        TextEditingController controller = TextEditingController();
        return AlertDialog(
          title: Text('Enter workout name: '),
          content: TextField(
            controller: controller,
          ),
          actions: <Widget>[
            Row(
              children: <Widget>[
                FlatButton(
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Colors.black54),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                FlatButton(
                  child: Text(
                    'Ok',
                    style:
                    TextStyle(color: Theme
                        .of(context)
                        .accentColor),
                  ),
                  onPressed: () {
                    widget.firestoreHangboardWorkoutsRepository.addNewWorkout(
                        hangboardWorkout).then((workoutAdded) {
                      if(workoutAdded) {
                        exerciseSavedSnackbar(scaffoldContext);
                      } else {
                        _exerciseExistsAlert(scaffoldContext, workoutTitle);
                      }
                    })
                    saveWorkoutToFirebase(
                        controller.text, scaffoldContext);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
