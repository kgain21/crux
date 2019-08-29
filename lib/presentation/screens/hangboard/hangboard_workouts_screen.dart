import 'package:crux/backend/blocs/hangboard/parent/hangboard_parent_bloc.dart';
import 'package:crux/backend/blocs/hangboard/parent/hangboard_parent_event.dart';
import 'package:crux/backend/blocs/hangboard/parent/hangboard_parent_state.dart';
import 'package:crux/backend/models/hangboard/hangboard_workout.dart';
import 'package:crux/backend/repository/hangboard_workouts_repository.dart';
import 'package:crux/backend/services/base_auth.dart';
import 'package:crux/presentation/shared_layouts/app_bar.dart';
import 'package:crux/presentation/widgets/exercise_tile.dart';
import 'package:crux/presentation/widgets/hangboard_workout_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HangboardWorkoutsScreen extends StatefulWidget {
  final String title;
  final BaseAuth auth;
  final HangboardWorkoutsRepository firestoreHangboardWorkoutsRepository;

  @override
  State<StatefulWidget> createState() => new _HangboardWorkoutsScreenState();

  HangboardWorkoutsScreen(
      {this.title, this.auth, this.firestoreHangboardWorkoutsRepository});
}

class _HangboardWorkoutsScreenState extends State<HangboardWorkoutsScreen> {
  HangboardParentBloc _hangboardParentBloc;

  @override
  void initState() {
    _hangboardParentBloc = HangboardParentBloc(
        hangboardWorkoutsRepository:
            widget.firestoreHangboardWorkoutsRepository)
      ..dispatch(LoadHangboardParent());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          SharedAppBar.sharedAppBar(widget.title, widget.auth, this.context),
      body: Column(
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
          BlocBuilder(
            bloc: _hangboardParentBloc,
            builder: (context, HangboardParentState parentState) {
              if (parentState is HangboardParentLoaded) {
                return workoutListBuilder(
                    parentState.hangboardParent.hangboardWorkoutList);
              } else if(parentState is HangboardParentWorkoutAdded) {
                exerciseSavedSnackbar(context);
                return workoutListBuilder(
                    parentState.hangboardParent.hangboardWorkoutList);
              } else if(parentState is HangboardParentDuplicateWorkout) {
                _exerciseExistsAlert(context, widget.title);
                return workoutListBuilder(
                    parentState.hangboardParent.hangboardWorkoutList);
              } else {
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
              }
            },
          ),
        ],
      ),
    );
  }

  Flexible workoutListBuilder(List<HangboardWorkout> workoutList) {
    return Flexible(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: (workoutList.length + 1),
        itemBuilder: (context, index) {
          if(index == workoutList.length) {
            //todo: this was scaffoldContext before, make sure context doesn't cause any bugs
            //todo: i don't think this makes sense - make sure to check back here on why i'm passing workout
            return addWorkoutButton(workoutList, context);
          }
          return HangboardWorkoutTile(
            hangboardWorkout: workoutList[index],
            index: index,
          );
        },
      ),
    );
  }

//todo: not sure if save is implemented yet, make sure that happens
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

  Future<void> _exerciseExistsAlert(
      BuildContext scaffoldContext, String workoutTitle) async {
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
                    style: TextStyle(color: Theme.of(context).accentColor),
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
                          color: Theme.of(scaffoldContext).accentColor),
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

  Widget addWorkoutButton(List<HangboardWorkout> hangboardWorkoutList,
                          BuildContext scaffoldContext) {
    return ExerciseTile(
      tileColor: Theme.of(context).primaryColor,
      child: FlatButton(
        color: Theme.of(context).primaryColor,
        onPressed: () {
          addWorkoutDialog(hangboardWorkoutList, scaffoldContext);
        },
        child: const Text('Add Workout'),
      ),
    );
  }

  void addWorkoutDialog(List<HangboardWorkout> hangboardWorkoutList,
                        BuildContext scaffoldContext) {
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
                    style: TextStyle(color: Theme.of(context).accentColor),
                  ),
                  onPressed: () {
                    var hangboardWorkout =
                    HangboardWorkout(controller.value.text);
//                    hangboardWorkoutList.add(hangboardWorkout);
                    _hangboardParentBloc
                        .dispatch(UpdateHangboardParent(hangboardWorkout));
                    /*widget.firestoreHangboardWorkoutsRepository
                        .addNewWorkout(hangboardWorkout)
                        .then((workoutAdded) {
                      if (workoutAdded) {
                        exerciseSavedSnackbar(scaffoldContext);
                      } else {
                        _exerciseExistsAlert(
                            scaffoldContext, hangboardWorkout.workoutTitle);
                      }
                    });*/ //todo: how do i notify if it already exists now?
                    /*saveWorkoutToFirebase(
                        controller.text, scaffoldContext);*/
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
