import 'package:crux/backend/blocs/hangboard/parent/hangboard_parent_bloc.dart';
import 'package:crux/backend/blocs/hangboard/parent/hangboard_parent_event.dart';
import 'package:crux/backend/blocs/hangboard/parent/hangboard_parent_state.dart';
import 'package:crux/backend/models/hangboard/hangboard_parent.dart';
import 'package:crux/backend/models/hangboard/hangboard_workout.dart';
import 'package:crux/backend/repository/hangboard_workouts_repository.dart';
import 'package:crux/backend/services/base_auth.dart';
import 'package:crux/presentation/shared_layouts/app_bar.dart';
import 'package:crux/presentation/widgets/exercise_tile.dart';
import 'package:crux/presentation/widgets/generic_widgets.dart';
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
          BlocProvider(
            builder: (context) => _hangboardParentBloc,
            child: BlocListener<HangboardParentBloc, HangboardParentState>(
              listener: (context, state) {
                if(state is HangboardParentDuplicateWorkout) {
                  _workoutExistsAlert(
                      state.hangboardWorkout.workoutTitle, context);
                } else if(state is HangboardParentWorkoutAdded) {
                  GenericWidgets.createGenericSnackbar(
                      context, 'Workout added!');
                } else if(state is HangboardParentWorkoutDeleted) {
                  GenericWidgets.createGenericSnackbar(
                      context, 'Workout deleted!');
                }
//                TODO: This method may be useful in the future -> executes callback once build is completed
//                  WidgetsBinding.instance.addPostFrameCallback((_) => GenericWidgets.createGenericSnackbar(context, 'Workout Deleted!'));
              },
              child: BlocBuilder(
                bloc: _hangboardParentBloc,
                builder: (context, HangboardParentState parentState) {
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
                },
              ),
            ),
          ),
        ],
      ),
    );
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
          );
        },
      ),
    );
  }

  Widget addWorkoutButton(HangboardParent hangboardParent) {
    return ExerciseTile(
      tileColor: Theme
          .of(context)
          .primaryColor,
      child: FlatButton(
        color: Theme
            .of(context)
            .primaryColor,
        onPressed: () {
          _addWorkoutDialog(hangboardParent);
        },
        child: const Text('Add Workout'),
      ),
    );
  }

  Future<void> _workoutExistsAlert(String workoutTitle,
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
                    style: TextStyle(color: Theme.of(context).accentColor),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void _addWorkoutDialog(HangboardParent hangboardParent) {
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
                    var hangboardWorkout =
                    HangboardWorkout(controller.value.text);
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
