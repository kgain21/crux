import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crux/model/grip_enum.dart';
import 'package:crux/widgets/exercise_form.dart';
import 'package:crux/widgets/shared_prefs_unit_picker_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CreateHangboardWorkoutTab extends StatefulWidget {
  @override
  State createState() => new _CreateHangboardWorkoutTabState();
}

class _CreateHangboardWorkoutTabState extends State<CreateHangboardWorkoutTab>
    with AutomaticKeepAliveClientMixin {
  /*@override
  void initState() {
    super.initState();
    _depthMeasurementSystem =
        _sharedPreferences.then((SharedPreferences prefs) {
          return (prefs.getString('depthMeasurementSystem') ?? 'millimeters');
        });
    _resistanceMeasurementSystem =
        _sharedPreferences.then((SharedPreferences prefs) {
          return (prefs.getString('resistanceMeasurementSystem') ?? 'kilograms');
        });
  }*/

  String _workoutTitle;
  Grip _grip;
  int _repTime;
  int _restTime;
  int _resistance;
  int _depth;
  int _reps;
  int _sets;

  String _exerciseTitle;
  int _exerciseIndex;

  String _depthMeasurementSystem;
  String _resistanceMeasurementSystem;

  bool _depthSelected;
  bool _repsSelected;
  bool _resistanceSelected;
  bool _repTimeSelected;
  bool _restTimeSelected;
  bool _autoValidate;

  ScrollController _exerciseFormScrollController;

  List<Widget> formTiles;

  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    setState(() {
      _resistanceMeasurementSystem = 'kilograms';
      _autoValidate = false;
      _depthSelected = true;
      _repsSelected = true;
      _resistanceSelected = true;
      _repTimeSelected = true;
      _restTimeSelected = true;
      _exerciseIndex = 1;
      _exerciseTitle = 'Exercise $_exerciseIndex';
      //formTiles = initializeFormTiles();
      _exerciseFormScrollController = new ScrollController();
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return WillPopScope(
      onWillPop: () async {
        Scaffold.of(context).showSnackBar(SnackBar(
            content:
                new Text('Save your shit'))); //todo: make sure user saves input
        return true;
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: new Column(
          children: <Widget>[
            buildExerciseForm(),
          ],
        ),
      ),
    );
  }

  /// Builds the [Form] for adding a new workout. Right now I have a title,
  /// the unit picker, and n number of [exercises].
  Widget buildExerciseForm() {
    return new Expanded(
      child: new Form(
        key: formKey,
        child: ListView(
          controller: _exerciseFormScrollController,
          //TODO: make sure these are disposed of properly
          children: <Widget>[
            workoutTitleTile(),
            UnitPickerTile(title: 'Choose your units'),
            ExerciseForm(
              workoutTitle: 'Exercise Details',
            ),
            ExerciseForm(
              workoutTitle: 'Exercise 2',
            ),
            ExerciseForm(
              workoutTitle: 'Exercise 3',
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> initializeFormTiles() {
    List<Widget> list = [];
    list.add(workoutTitleTile());
    //list.add(expandingUnitsTile());
    return list;
  }

  /// Placeholder for button that will eventually be pressed to add another
  /// [exercise].
  Widget addExerciseTileButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: new RaisedButton(
        onPressed: null,
        child: new Text('Add another set'),
      ),
    );
  }


  /// Tile that holds the title of your workout. This title is used as a reference
  /// in the Firestore to pull out the workout information so it cannot be empty.
  Widget workoutTitleTile() {
    return new Card(
      //elevation: 4.0,
      child: ListTile(
        title: Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 8.0),
          child: TextFormField(
            decoration: InputDecoration(
              labelText: 'Workout Title',
              hintText: 'Enter a unique name for your workout.',
            ),
            validator: (value) {
              if (value.isEmpty)
                return 'Please enter a workout title.';
              else
                return null;
            },
            onSaved: (value) {
              _workoutTitle = value;
            },
            onFieldSubmitted: (value) {
              setState(() {
                _workoutTitle = value;
                if (value.isNotEmpty)
                  //TODO: trying to only add this if title is populated so that i can pass title into formTile widget
                  //TODO: need title to give tile path to save to - maybe pass db connection? not sure just a thought
                  formTiles.add(ExerciseForm(
                    workoutTitle: value,
                  ));
                formTiles.add(addExerciseTileButton());
              });
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _exerciseFormScrollController.dispose();
    super.dispose();
  }

  // TODO: implement wantKeepAlive
  // TODO:-- update: not sure if i need to or if this is an old message, look into this for keeping timer alive outside of this screen
  @override
  bool get wantKeepAlive => true;
}
