import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crux/backend/blocs/hangboard/parent/hangboard_parent_bloc.dart';
import 'package:crux/backend/blocs/hangboard/parent/hangboard_parent_event.dart';
import 'package:crux/backend/blocs/hangboard/parent/hangboard_parent_state.dart';
import 'package:crux/backend/models/hangboard/hangboard_exercise.dart';
import 'package:crux/backend/models/hangboard/hangboard_parent.dart';
import 'package:crux/backend/models/hangboard/hangboard_workout.dart';
import 'package:crux/backend/repository/entities/hangboard_workout_entity.dart';
import 'package:crux/backend/repository/hangboard_workouts_repository.dart';
import 'package:crux/backend/services/base_auth.dart';
import 'package:crux/frontend/shared_layouts/app_bar.dart';
import 'package:crux/frontend/widgets/exercise_tile.dart';
import 'package:crux/frontend/widgets/generic_widgets.dart';
import 'package:crux/frontend/widgets/hangboard_workout_tile.dart';
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

//  FirestoreStreamListener _firestoreStreamListener;

  @override
  void initState() {
    _hangboardParentBloc = HangboardParentBloc(
        hangboardWorkoutsRepository:
        widget.firestoreHangboardWorkoutsRepository)
      ..dispatch(LoadHangboardParent());

    Firestore.instance
        .collection('hangboard')
        .snapshots()
        .listen((querySnapshot) {
      List<HangboardWorkout> hangboardWorkoutList = querySnapshot.documents
          .map((workoutDocument) =>
          HangboardWorkout.fromEntity(
              HangboardWorkoutEntity.fromJson(workoutDocument.data)))
          .toList();

      _hangboardParentBloc.dispatch(
          HangboardParentUpdated(HangboardParent(hangboardWorkoutList)));
    });
//
//    _firestoreStreamListener = FirestoreStreamListener()
//      ..streamSubscription.onData((data) {
//        _hangboardParentBloc
//            .dispatch(HangboardParentUpdated(HangboardParent(data)));
//      });

    super.initState();
  }

  @override
  void dispose() {
    _hangboardParentBloc.dispose();
//    _firestoreStreamListener.dispose();
    super.dispose();
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
          BlocProvider<HangboardParentBloc>(
            builder: (context) => _hangboardParentBloc,
            child: BlocListener<HangboardParentBloc, HangboardParentState>(
              listener: (context, state) {
                listenForHangboardParentState(state, context);
              },
              child: BlocBuilder(
                bloc: _hangboardParentBloc,
                builder: (context, HangboardParentState parentState) {
                  return buildFromHangboardParentState(parentState);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildFromHangboardParentState(HangboardParentState parentState) {
    if(parentState is HangboardParentLoaded) {
      return workoutListBuilder(parentState.hangboardParent);
    } else if(parentState is HangboardParentWorkoutAdded) {
      return workoutListBuilder(parentState.hangboardParent);
    } else if(parentState is HangboardParentDuplicateWorkout) {
      return workoutListBuilder(parentState.hangboardParent);
    } else if(parentState is HangboardParentWorkoutDeleted) {
      return workoutListBuilder(parentState.hangboardParent);
    } else {
      return _retrievingWorkoutsSpinner();
    }
  }

  void listenForHangboardParentState(HangboardParentState state,
                                     BuildContext context) {
    if(state is HangboardParentDuplicateWorkout) {
      _showWorkoutExistsAlert(
          state.hangboardParent, state.hangboardWorkout.workoutTitle, context);
    } else if(state is HangboardParentWorkoutAdded) {
      GenericWidgets.createGenericSnackbar(context, 'Workout added!');
    } else if(state is HangboardParentWorkoutDeleted) {
      GenericWidgets.createGenericSnackbar(context, 'Workout deleted!');
    }
  }

  Padding _retrievingWorkoutsSpinner() {
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

  Flexible workoutListBuilder(HangboardParent hangboardParent) {
    var workoutList = hangboardParent.hangboardWorkoutList;
    return Flexible(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: (workoutList.length + 1),
        itemBuilder: (context, index) {
          if(index == workoutList.length) {
            return addWorkoutButton(hangboardParent);
          }
          return HangboardWorkoutTile(
            hangboardWorkout: workoutList[index],
            index: index,
            firestoreHangboardWorkoutsRepository:
            widget.firestoreHangboardWorkoutsRepository,
          );
        },
      ),
    );
  }

  Widget addWorkoutButton(HangboardParent hangboardParent) {
    return ExerciseTile(
      tileColor: Theme
          .of(context)
          .accentColor,
      child: FlatButton(
        color: Theme
            .of(context)
            .accentColor,
        onPressed: () {
          _showAddWorkoutDialog(hangboardParent);
        },
        child: const Text('Add Workout'),
      ),
    );
  }

  Future<void> _showWorkoutExistsAlert(HangboardParent hangboardParent,
                                       String workoutTitle,
                                       BuildContext scaffoldContext) async {
    return showDialog<void>(
      context: scaffoldContext,
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
                      _showAddWorkoutDialog(hangboardParent);
                    }),
              ],
            ),
          ],
        );
      },
    );
  }

  void _showAddWorkoutDialog(HangboardParent hangboardParent) {
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
                  onPressed: () => Navigator.of(context).pop(),
                ),
                FlatButton(
                  child: Text(
                    'Ok',
                    style: TextStyle(color: Theme.of(context).accentColor),
                  ),
                  onPressed: () {
                    var hangboardWorkout = HangboardWorkout(
                        controller.value.text, <HangboardExercise>[]);
                    Navigator.of(context).pop();
                    _hangboardParentBloc.dispatch(AddWorkoutToHangboardParent(
                        hangboardParent, hangboardWorkout));
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
