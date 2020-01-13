import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crux/backend/blocs/hangboard/workouts/hangboard_workout_bloc.dart';
import 'package:crux/backend/blocs/hangboard/workouts/hangboard_workout_event.dart';
import 'package:crux/backend/blocs/hangboard/workouts/hangboard_workout_state.dart';
import 'package:crux/backend/models/hangboard/hangboard_exercise.dart';
import 'package:crux/backend/models/hangboard/hangboard_workout.dart';
import 'package:crux/backend/repository/entities/hangboard_workout_entity.dart';
import 'package:crux/backend/repository/hangboard_workouts_repository.dart';
import 'package:crux/frontend/widgets/dots_indicator.dart';
import 'package:crux/frontend/widgets/exercise_form.dart';
import 'package:crux/frontend/widgets/hangboard_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShakeCurve extends Curve {
  @override
  double transform(double t) => sin(t * pi * 2);
}

class ExercisePageView extends StatefulWidget {
  final String hangboardWorkoutTitle;
  final HangboardWorkoutsRepository hangboardWorkoutsRepository;

  @override
  State createState() => _ExercisePageViewState();

  ExercisePageView(
      {this.hangboardWorkoutTitle, this.hangboardWorkoutsRepository});
}

class _ExercisePageViewState extends State<ExercisePageView> {
  static const _kCurve = Curves.ease;
  static const _kDuration = const Duration(milliseconds: 300);
  static const _kViewportFraction = 0.7;

  ValueNotifier<double> selectedIndex = ValueNotifier<double>(0.0);

  PageController _controller;

//  PageController _zoomController;

//  AnimationController _shakeController;
//  Animation _shakeCurve;
  int _pageCount;

//  OverlayEntry _overlayEntry;
//  bool _overlayVisible;
  double _currentPageValue;
  bool _isEditing;

//  bool _exerciseFinished;
  bool _preferencesClearedFlag;

  HangboardWorkoutBloc _hangboardWorkoutBloc;

//  HangboardExerciseBloc _hangboardExerciseBloc;

  /* bool _handlePageNotification(ScrollNotification notification,
                               PageController leader, PageController follower) {
    if (notification.depth == 0 && notification is ScrollUpdateNotification) {
      selectedIndex.value = leader.page;
      if (follower.page != leader.page) {
        follower.position.jumpToWithoutSettling(leader.position.pixels /
            _kViewportFraction); // ignore: deprecated_member_use
      }
      setState(() {});
    }
    return false;
  }*/

  @override
  void initState() {
    super.initState();

    Firestore.instance
        .document('hangboard/${widget.hangboardWorkoutTitle}')
        .snapshots()
        .listen((querySnapshot) {
      var hangboardWorkout = HangboardWorkout.fromEntity(
          HangboardWorkoutEntity.fromJson(querySnapshot.data));

      _hangboardWorkoutBloc.dispatch(ReloadHangboardWorkout(hangboardWorkout));
    });

//    _overlayVisible = false;
    _currentPageValue = 0.0;
    _isEditing = false;
//    _preferencesClearedFlag = false;

    _hangboardWorkoutBloc =
        HangboardWorkoutBloc(widget.hangboardWorkoutsRepository)
          ..dispatch(LoadHangboardWorkout(widget.hangboardWorkoutTitle));

//    _shakeController = new AnimationController(vsync: this, duration: Duration(seconds: 1));
//    _shakeCurve = CurvedAnimation(parent: _shakeController, curve: ShakeCurve());

    /// [_controller] is 0 indexed but snapshot is not; add 1 to snapshot
    /// index to create a [newExercisePage].
    _pageCount = 0;

    //TODO: Store last page # and reload there
//    _zoomController = new PageController(
//        viewportFraction: _kViewportFraction /*initialPage: _index - 2*/);
    _controller = new PageController(/*initialPage: _index - 2*/);
    _controller.addListener(() {
      setState(() {
        _currentPageValue = _controller.page;
      }); //todo: make sure I get rid of this setState at some point
    });
  }

  @override
  void dispose() {
    _hangboardWorkoutBloc.dispose();
//    _hangboardExerciseBloc.dispose();
    _controller.dispose();
//    _zoomController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 8.0,
        title: Text(widget.hangboardWorkoutTitle),
        actions: <Widget>[buildPopupMenuButton()],
        //TODO: Add action menu that allows you to reset all exercises (clear sharedPrefs)
      ),
      body: BlocBuilder(
          bloc: _hangboardWorkoutBloc,
          builder: (context, hangboardWorkoutState) {
            if(hangboardWorkoutState is EditingHangboardWorkout) {
              _isEditing = true;
              return exercisePageView(
                  hangboardWorkoutState.hangboardWorkout, context);
            } else if(hangboardWorkoutState is HangboardWorkoutLoaded) {
              _isEditing = false;
              return exercisePageView(
                  hangboardWorkoutState.hangboardWorkout, context);
            } else {
              //just making it happy here- double check
              return Center();
            }
          }),
    );
  }

  Center exercisePageView(HangboardWorkout hangboardWorkout,
      BuildContext context) {
    int exerciseCount = 0;
    var exerciseList = hangboardWorkout.hangboardExerciseList ?? [];
    exerciseCount = exerciseList.length;

    _pageCount = exerciseCount + 1;

    return Center(
      child: new Container(
        color: Theme
            .of(context)
            .canvasColor,
        child: GestureDetector(
          onLongPress: () {
            _hangboardWorkoutBloc
                .dispatch(ExerciseTileLongPressed(hangboardWorkout));
          },
          onTap: () {
            _hangboardWorkoutBloc
                .dispatch(ExerciseTileTapped(hangboardWorkout));
          },
          child: Stack(
            children: <Widget>[
              PageView(
                controller: _controller,
                children: createPageList(hangboardWorkout),
              ),
              dotsIndicator(),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> createPageList(HangboardWorkout hangboardWorkout) {
    final List<Widget> pages = <Widget>[];
//    double pictureHeight = MediaQuery.of(context).size.height * 0.6;
//    double pictureWidth = MediaQuery.of(context).size.width * 0.6;

    for (int i = 0; i < _pageCount; i++) {
      Widget child;

      if(i == hangboardWorkout.hangboardExerciseList.length) {
        child = newExercisePage();
      } else {
        child =
            animatedHangboardPage(i, hangboardWorkout.hangboardExerciseList[i]);
      }

      /*  var alignment = Alignment.center
          .add(Alignment((selectedIndex.value - i) * _kViewportFraction, 0.0));
      var resizeFactor =
          (1 - (((selectedIndex.value - i).abs() * 0.3).clamp(0.0, 1.0)));

      if (_zoomOut) {
        pages.add(Container(
          child: AspectRatio(
            aspectRatio: _kViewportFraction,
            child: child,
          ),
        ));
      } else {*/
      pages.add(Container(
        child: child,
      ));
//      }
    }

    return pages;
  }

  Widget newExercisePage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) {
                return ExerciseForm(
                  workoutTitle: widget.hangboardWorkoutTitle,
                  firestoreHangboardWorkoutsRepository:
                  widget.hangboardWorkoutsRepository,
                );
              }),
            );
          },
          child: Icon(
            Icons.add,
            size: MediaQuery
                .of(context)
                .size
                .width / 5.0,
          ),
        ),
        Text(
          'Add New Exercise',
          style: TextStyle(fontSize: MediaQuery
              .of(context)
              .size
              .width / 14.0),
        ),
      ],
    );
  }

  Widget animatedHangboardPage(int index, HangboardExercise hangboardExercise) {
    /// Last page should always be a [newExercisePage()]. This index will always
    /// be greater than the current exercises list so this must be checked first
    if(index == _currentPageValue.floor()) {
      return Transform(
        transform: Matrix4.identity()
          ..rotateX(_currentPageValue - index),
        child: Stack(
          children: <Widget>[
            HangboardPage(
              workoutTitle: widget.hangboardWorkoutTitle,
              index: index,
              hangboardExercise: hangboardExercise,
            ),
            _isEditing
                ? exerciseDeleteButton(hangboardExercise)
                : null,
          ].where(notNull).toList(),
        ),
      );
    } else if (index == _currentPageValue.floor() + 1) {
      return Transform(
        transform: Matrix4.identity()
          ..rotateY(_currentPageValue - index),
        child: Stack(
          children: <Widget>[
            HangboardPage(
              workoutTitle: widget.hangboardWorkoutTitle,
              index: index,
              hangboardExercise: hangboardExercise,
            ),
            _isEditing
                ? exerciseDeleteButton(hangboardExercise)
                : null,
          ].where(notNull).toList(),
        ),
      );
    }

    return Stack(
      children: <Widget>[
        HangboardPage(
          workoutTitle: widget.hangboardWorkoutTitle,
          index: index,
          hangboardExercise: hangboardExercise,
        ),
        _isEditing
            ? exerciseDeleteButton(hangboardExercise)
            : null,
      ].where(notNull).toList(),
    );
  }

  Padding exerciseDeleteButton(HangboardExercise hangboardExercise) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          IconButton(
            color: Colors.black,
            icon: Icon(Icons.cancel),
            onPressed: () {
              _hangboardWorkoutBloc.dispatch(
                  DeleteHangboardExercise(hangboardExercise));
              //TODO: ask user for delete confirmation
            },
          ),
        ],
      ),
    );
  }

  bool notNull(Object o) => o != null;

  Widget dotsIndicator() {
    return new Positioned(
      bottom: 0.0,
      left: 0.0,
      right: 0.0,
      child: new Container(
        padding: const EdgeInsets.all(15.0),
        child: new Center(
          child: new DotsIndicator(
            color: Theme.of(context).primaryColorLight,
            controller: /*_zoomOut ? _zoomController :*/ _controller,
            itemCount: _pageCount,
            onPageSelected: (int page) {
              _controller.animateToPage(
                page,
                duration: _kDuration,
                curve: _kCurve,
              );
            },
          ),
        ),
      ),
    );
  }

  PopupMenuButton<String> buildPopupMenuButton() {
    return PopupMenuButton<String>(
      onSelected: (value) {
        //TODO: switch statement for more menuButtons
        if(value == 'reset workout') {
          SharedPreferences.getInstance().then((preferences) {
            preferences.getKeys().forEach((key) {
              if(key.contains(widget.hangboardWorkoutTitle))
                preferences.remove(key);
            });
            setState(() {
              _preferencesClearedFlag = !_preferencesClearedFlag;
            });
          });
        } else if(value == 'clear sharedPreferences') {
          SharedPreferences.getInstance().then((preferences) {
            preferences.clear();
          });
        } else {
          SharedPreferences.getInstance().then((preferences) {
            print('----------------------------------------------------');
            preferences
                .getKeys()
                .forEach((key) => print('$key: ${preferences.get(key)}\n'));
            print('----------------------------------------------------');
          });
        }
      },
      itemBuilder: (BuildContext context) {
        return <PopupMenuItem<String>>[
          new PopupMenuItem(
            child: new Text('Reset Workout'),
            value: 'reset workout',
          ),
          new PopupMenuItem(
            child: new Text('Clear SharedPreferences'),
            value: 'clear sharedPreferences',
          ),
          new PopupMenuItem(
            child: new Text('Print SharedPreferences'),
            value: 'print sharedPreferences',
          ),
        ];
      },
    );
  }

  void nextPageCallback() {
    _controller.nextPage(duration: _kDuration, curve: _kCurve);
  }
}
