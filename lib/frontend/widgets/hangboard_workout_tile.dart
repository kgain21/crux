import 'package:crux/backend/bloc/hangboard/workoutlist/hangboard_workout_list_bloc.dart';
import 'package:crux/backend/bloc/hangboard/workoutlist/hangboard_workout_list_event.dart';
import 'package:crux/backend/bloc/hangboard/workouttile/hangboard_workout_tile_bloc.dart';
import 'package:crux/backend/bloc/hangboard/workouttile/hangboard_workout_tile_event.dart';
import 'package:crux/backend/bloc/hangboard/workouttile/hangboard_workout_tile_state.dart';
import 'package:crux/backend/repository/hangboard_workouts_repository.dart';
import 'package:crux/backend/services/preferences.dart';
import 'package:crux/frontend/screens/hangboard/exercise_page_view.dart';
import 'package:crux/frontend/widgets/exercise_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HangboardWorkoutTile extends StatefulWidget {
  final int index;
  final String hangboardWorkoutTitle;
  final HangboardWorkoutsRepository firestoreHangboardWorkoutsRepository;

  HangboardWorkoutTile(
      {this.index,
      this.hangboardWorkoutTitle,
      this.firestoreHangboardWorkoutsRepository})
      : super();

  @override
  State<StatefulWidget> createState() => _HangboardWorkoutTileState();
}

class _HangboardWorkoutTileState extends State<HangboardWorkoutTile> {
  final Icon _arrowIcon = Icon(Icons.chevron_right);
  HangboardWorkoutListBloc _hangboardWorkoutListBloc;
  HangboardWorkoutTileBloc _hangboardWorkoutTileBloc;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    _hangboardWorkoutListBloc =
        BlocProvider.of<HangboardWorkoutListBloc>(context);

    _hangboardWorkoutTileBloc = HangboardWorkoutTileBloc();

    var workoutTitle = widget.hangboardWorkoutTitle;

    return BlocBuilder(
        bloc: _hangboardWorkoutTileBloc,
        builder: (context, HangboardWorkoutTileState state) {
          return ExerciseTile(
            child: ListTile(
                title: Text(workoutTitle),
                trailing:
                !state.isEditing ? _arrowIcon : interactiveCloseIcon(),
                onLongPress: () {
                  _hangboardWorkoutTileBloc
                      .add(HangboardWorkoutTileLongPressed(true));
                },
                onTap: () {
                  if(state.isEditing) {
                    _hangboardWorkoutTileBloc
                        .add(HangboardWorkoutTileTapped(false));
                  } else {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ExercisePageView(
                                hangboardWorkoutTitle: widget
                                    .hangboardWorkoutTitle,
                                hangboardWorkoutsRepository:
                                widget.firestoreHangboardWorkoutsRepository,
                              ),
                        ));
                  }
                }),
          );
        });
  }

  Widget interactiveCloseIcon() {
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
                        _hangboardWorkoutListBloc.add(
                            HangboardWorkoutListWorkoutDeleted(
                                widget.hangboardWorkoutTitle));

                        /// Clear out sharedPrefs with workout deletion
                        /*SharedPreferences.getInstance().then((preferences) {
                          preferences.getKeys().remove(workoutTitle);
                        });*/

                        Preferences().removeTimerPreferences(
                            widget.hangboardWorkoutTitle);
                      },
                    )
                  ],
                  content: RichText(
                    text: TextSpan(
                      style: TextStyle(color: Colors.black, fontSize: 16.0),
                      children: [
                        TextSpan(text: 'Are you sure you want to delete '),
                        TextSpan(
                          text: '${widget.hangboardWorkoutTitle}?\n\n',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(text: 'All exercises will be lost.'),
                      ],
                    ),
                  ));
            });
        _hangboardWorkoutTileBloc.add(HangboardWorkoutTileTapped(false));
      },
    );
  }
}
