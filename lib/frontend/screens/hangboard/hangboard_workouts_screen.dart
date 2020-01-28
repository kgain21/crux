import 'package:crux/backend/bloc/hangboard/workoutlist/hangboard_workout_list_bloc.dart';
import 'package:crux/backend/bloc/hangboard/workoutlist/hangboard_workout_list_event.dart';
import 'package:crux/backend/bloc/hangboard/workoutlist/hangboard_workout_list_state.dart';
import 'package:crux/backend/models/hangboard/hangboard_exercise.dart';
import 'package:crux/backend/models/hangboard/hangboard_workout.dart';
import 'package:crux/backend/models/hangboard/hangboard_workout_list.dart';
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
  HangboardWorkoutListBloc _hangboardParentBloc;

  @override
  void initState() {
    _hangboardParentBloc = HangboardWorkoutListBloc(
        hangboardWorkoutsRepository:
            widget.firestoreHangboardWorkoutsRepository)
      ..add(HangboardWorkoutListLoaded());

    super.initState();
  }

  @override
  void dispose() {
    _hangboardParentBloc.close();
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
              style: Theme
                  .of(context)
                  .textTheme
                  .title,
              textAlign: TextAlign.start,
            ),
          ),
          BlocProvider<HangboardWorkoutListBloc>(
            create: (context) => _hangboardParentBloc,
            child: BlocListener<
                HangboardWorkoutListBloc,
                HangboardWorkoutListState>(
              listener: (context, state) {
                listenForHangboardWorkoutListState(state, context);
              },
              child: BlocBuilder(
                bloc: _hangboardParentBloc,
                builder: (context, HangboardWorkoutListState parentState) {
                  return buildFromHangboardWorkoutListState(parentState);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildFromHangboardWorkoutListState(
      HangboardWorkoutListState parentState) {
    if(parentState is HangboardWorkoutListLoadSuccess) {
      return workoutListBuilder(parentState.hangboardWorkoutList);
    } else if(parentState is HangboardWorkoutListAddWorkoutSuccess) {
      return workoutListBuilder(parentState.hangboardWorkoutList);
    } else if(parentState is HangboardWorkoutListAddWorkoutDuplicate) {
      return workoutListBuilder(parentState.hangboardWorkoutList);
    } else if(parentState is HangboardWorkoutListDeleteWorkoutSuccess) {
      return workoutListBuilder(parentState.hangboardWorkoutList);
    } else {
      return _retrievingWorkoutsSpinner();
    }
  }

  void listenForHangboardWorkoutListState(HangboardWorkoutListState state,
      BuildContext context) {
    if(state is HangboardWorkoutListAddWorkoutDuplicate) {
      _showWorkoutExistsAlert(state.hangboardWorkoutList,
          state.hangboardWorkout.workoutTitle, context);
    } else if(state is HangboardWorkoutListWorkoutAdded) {
      GenericWidgets.createGenericSnackbar(context, 'Workout added!');
    } else if(state is HangboardWorkoutListDeleteWorkoutSuccess) {
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

  Flexible workoutListBuilder(HangboardWorkoutList hangboardParent) {
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
            hangboardWorkoutTitle: workoutList[index],
            index: index,
            firestoreHangboardWorkoutsRepository:
            widget.firestoreHangboardWorkoutsRepository,
          );
        },
      ),
    );
  }

  Widget addWorkoutButton(HangboardWorkoutList hangboardParent) {
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

  Future<void> _showWorkoutExistsAlert(HangboardWorkoutList hangboardParent,
      String workoutTitle, BuildContext scaffoldContext) async {
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

  void _showAddWorkoutDialog(HangboardWorkoutList hangboardParent) {
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
                    _hangboardParentBloc.add(HangboardWorkoutListWorkoutAdded(
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
