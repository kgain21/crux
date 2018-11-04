import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crux/model/grip_enum.dart';
import 'package:crux/widgets/exercise_form_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class CreateHangboardWorkoutTab extends StatefulWidget {
  @override
  State createState() => new _CreateHangboardWorkoutTabState();
}

class _CreateHangboardWorkoutTabState extends State<CreateHangboardWorkoutTab>
    with AutomaticKeepAliveClientMixin {
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

  List<Widget> formTiles = [];

  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    setState(() {
      _depthMeasurementSystem = 'millimeters';
      _resistanceMeasurementSystem = 'kilograms';
      _autoValidate = false;
      _depthSelected = true;
      _repsSelected = true;
      _resistanceSelected = true;
      _repTimeSelected = true;
      _restTimeSelected = true;
      _exerciseIndex = 1;
      _exerciseTitle = 'Exercise $_exerciseIndex';
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

  Widget buildExerciseForm() {
    return new Expanded(
      child: new Form(
        key: formKey,
        child: ListView(
          controller: new ScrollController(),
          children: formTiles,
        ),
      ),
    );
  }

  List<Widget> populateFormTiles() {

    formTiles.add(workoutTitleTile());
    formTiles.add(expandingUnitsTile());
    if(_workoutTitle != null)

      //TODO: left off here*** trying to only add this if title is populated so that i can pass title into formTile widget
      //TODO: need title to give tile path to save to - maybe pass db connection? not sure just a thought
      formTiles.add(ExerciseFormTile(formKey: formKey,));
    formTiles.add(addExerciseTileButton());
  }
  Widget addExerciseTileButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: new RaisedButton(
        onPressed: null,
        child: new Text('Add another set'),
      ),
    );
  }

  //TODO: put general message about form errors below save button
  void saveHangboardForm() {
    if (this.formKey.currentState.validate()) {
      this.formKey.currentState.save();
      saveHangboardWorkoutToFirebase(); //TODO: make dao here?
      print('saved');
    } else {
      setState(() => _autoValidate = true);
    }
  }

  void saveHangboardWorkoutToFirebase() {
    DocumentReference reference =
        Firestore.instance.document('hangboard/$_workoutTitle');
    CollectionReference collectionReference =
        Firestore.instance.collection('hangboard/$_workoutTitle');

    var data = createHangboardData();

    reference.setData(data);

    //onTap: () => record.reference.updateData({'votes': record.votes + 1})
  }

  Map createHangboardData() {
    Map<String, dynamic> data = {};

    data.putIfAbsent("exercises", () {
      var exercises = [];

      var exercise = {
        "depth": _depth,
        "grip": _grip.toString(),
        "resistance": _resistance,
      };

      exercises.add(exercise);
      return exercises;
    });

    data.putIfAbsent("created_date", () {
      return DateTime.now();
    });

    /* Map<String, Object> data = new LinkedHashMap();
    DateTime createdTimestamp = DateTime.now();

    Map<String, Object> exercise = new LinkedHashMap();
    exercise.putIfAbsent('depth', _depth);*/
    return data;
  }

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
              });
            },
          ),
        ),
      ),
    );
  }

  Widget expandingUnitsTile() {
    return Card(
      child: Column(
        children: <Widget>[
          new ExpansionTile(
            initiallyExpanded: true,
            title: new Text('Select your units'),
            children: <Widget>[
              new Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Flexible(
                    fit: FlexFit.loose,
                    child: Column(
                      children: <Widget>[
                        new Text(
                          'Depth',
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                        new RadioListTile(
                          title: Text(
                            'Metric (mm)',
                            style: TextStyle(
                              fontSize: 14.0,
                            ),
                          ),
                          groupValue: _depthMeasurementSystem,
                          value: 'millimeters',
                          onChanged: (value) {
                            setState(() {
                              _depthMeasurementSystem = value;
                            });
                          },
                        ),
                        new RadioListTile(
                          title: Text(
                            'English (in)',
                            style: TextStyle(
                              fontSize: 14.0,
                            ),
                          ),
                          groupValue: _depthMeasurementSystem,
                          value: 'inches',
                          onChanged: (value) {
                            setState(() {
                              _depthMeasurementSystem = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    fit: FlexFit.loose,
                    child: Column(
                      children: <Widget>[
                        new Text(
                          'Resistance',
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                        new RadioListTile(
                          title: Text(
                            'Metric (kg)',
                            style: TextStyle(
                              fontSize: 14.0,
                            ),
                          ),
                          groupValue: _resistanceMeasurementSystem,
                          value: 'kilograms',
                          onChanged: (value) {
                            setState(() {
                              _resistanceMeasurementSystem = value;
                            });
                          },
                        ),
                        new RadioListTile(
                          title: Text(
                            'English (lb)',
                            style: TextStyle(
                              fontSize: 14.0,
                            ),
                          ),
                          groupValue: _resistanceMeasurementSystem,
                          value: 'pounds',
                          onChanged: (value) {
                            setState(() {
                              _resistanceMeasurementSystem = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }



  // TODO: implement wantKeepAlive
  // TODO:-- update: not sure if i need to or if this is an old message, look into this for keeping timer alive outside of this screen
  @override
  bool get wantKeepAlive => true;
}
