import 'package:crux/backend/blocs/hangboard/workouts/hangboard_workout_bloc.dart';
import 'package:crux/backend/models/hangboard/hangboard_workout.dart';
import 'package:crux/backend/services/preferences.dart';
import 'package:crux/presentation/screens/hangboard/exercise_page_view.dart';
import 'package:crux/presentation/widgets/exercise_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';



class HangboardWorkoutTile extends StatefulWidget {
  final int index;
  final HangboardWorkout hangboardWorkout;

  HangboardWorkoutTile({
                         this.index,
                         this.hangboardWorkout
                       }) : super();

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
    return workoutTile();
  }

  Widget workoutTile() {
    var workoutTitle = widget.hangboardWorkout.workoutTitle;

    return ExerciseTile(
      child: ListTile(
        title: Text(workoutTitle),
        trailing: !_isEditing ? _arrowIcon : interactiveCloseIcon(workoutTitle),
        onLongPress: () {
          setState(() {
            _isEditing = true;
          });
        },
        onTap: () {
          if(_isEditing) {
            setState(() {
              _isEditing = false;
            });
          } else {
            Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                return BlocProvider(
                  bloc: WorkoutBloc(),
                  //todo: make sure this works/is the right place to create
                  child: ExercisePageView(
                    title: workoutTitle,
                    hangboardWorkout: widget.hangboardWorkout,
                    workoutId: widget.index.toString(),
                  ),
                );
              },
            ));
          }
        },
      ),
    );
  }

  Widget interactiveCloseIcon(var workoutTitle) {
    return GestureDetector(
      child: Icon(Icons.close),
      onTap: () {
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              return AlertDialog(
                  actions: <Widget>[
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
                      child: Text('Delete'),
                      onPressed: () {
                        Navigator.of(context).pop();
                        // https://firebase.google.com/docs/firestore/solutions/delete-collections
                        /*collectionRef.getDocuments().then((snapshot) {
                          snapshot.documents.forEach(
                              (document) => document.reference.delete());
                          Firestore.instance
                              .document('hangboard/$workoutTitle')
                              .delete();
                        });*/

                        /// Clear out sharedPrefs with workout deletion
                        /*SharedPreferences.getInstance().then((preferences) {
                          preferences.getKeys().remove(workoutTitle);
                        });*/
                        //todo: pass in bloc and dispatch to delete here
                        Preferences().removeTimerPreferences(workoutTitle);
                      },
                    )
                  ],
                  content: RichText(
                    text: TextSpan(
                      style: TextStyle(color: Colors.black, fontSize: 16.0),
                      children: [
                        TextSpan(text: 'Are you sure you want to delete '),
                        TextSpan(
                          text: '$workoutTitle?\n\n',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(text: 'All exercises will be lost.'),
                      ],
                    ),
                  ));
            });
        setState(() {
          _isEditing = false;
        });
      },
    );
  }
}
