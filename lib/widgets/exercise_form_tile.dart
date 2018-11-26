import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crux/model/grip_enum.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExerciseFormTile extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final String exerciseTitle;
  final String workoutTitle;

  //TODO: how do I want to handle units here????
  ExerciseFormTile({
    @required this.formKey,
    this.exerciseTitle,
    this.workoutTitle,
  }) : assert(formKey != null);

  @override
  State createState() => new _ExerciseFormTileState();
}

class _ExerciseFormTileState extends State<ExerciseFormTile> {
  Future<SharedPreferences> _sharedPreferences =
      SharedPreferences.getInstance();

  Future<String> getDepthMeasurementSystem() async {
    final String depthMeasurementSystem = await _sharedPreferences.then((value) {
      return value.getString("depthMeasurementSystem")?? 'millimeters';
    });
    return depthMeasurementSystem;
  }


  Future<Null> getResistanceMeasurementSystem() async {
    final SharedPreferences preferences = await _sharedPreferences;
    setState(() {
      _resistanceMeasurementSystem =
          preferences.getString("resistanceMeasurementSystem") ?? 'kilograms';
    });
  }

  Grip _grip;
  int _repTime;
  int _restTime;
  int _resistance;
  int _depth;
  int _reps;

 // String _depthMeasurementSystem;
  String _resistanceMeasurementSystem;
  Stream<String> depthPrefs;
  Stream<String> resistancePrefs;

  bool _depthSelected;
  bool _repsSelected;
  bool _resistanceSelected;
  bool _repTimeSelected;
  bool _restTimeSelected;
  bool _autoValidate;
  bool _isExpanded;

  @override
  void initState() {
    super.initState();
    setState(() {
      /// Not sure if i even want this functionality so i'm moving on for now,
      /// but I'm looking to pull the unit from sharedPrefs if possible, dana
      /// said it was ugly so maybe not but we'll see
      //https://stackoverflow.com/questions/33905268/returning-a-string-from-an-async
     // String _depthMeasurementSystem = await getDepthMeasurementSystem();
      getResistanceMeasurementSystem();
      _depthSelected = true;
      _repsSelected = true;
      _resistanceSelected = true;
      _repTimeSelected = true;
      _restTimeSelected = true;
      _autoValidate = false;
      _isExpanded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Card(
      //color: Colors.grey,
      child: ExpansionTile(
        key: PageStorageKey<String>(widget.exerciseTitle),
        initiallyExpanded: _isExpanded,
        title: new Text(widget.exerciseTitle),
        children: <Widget>[
          gripDropdownTile(),
          depthTile(),
          resistanceTile(),
          hangDurationTile(),
          restTimeTile(),
          numberOfHangsTile(),
          saveButton()
        ],
      ),
    );
  }

  /// Tried to make a generic validator for the different [exercise] fields since
  /// they're almost all [int] fields. If there are other non [int] fields that
  /// I add, I could always abstract it out another level to an even more generic
  /// validation picker method.
  //TODO: make unselected boxes grayed out (cant type in them)
  String hangboardFieldValidator(bool selected, String fieldValue) {
    var intValue = int.tryParse(fieldValue);
    if (selected) {
      if (intValue == null) {
        return 'Please enter a number.';
      }
      if (intValue.isNaN) return 'Please enter a real number.';
      if (intValue.isNegative) return 'Please enter a positive number.';
      return null;
    }
    return null;
  }

  /// Formatter for the different [Grips] I have available. This basically just
  /// takes the enum form and makes it a better looking String for the dropdown.
  String formatGrip(Grip grip) {
    var gripArray = grip.toString().substring(5).split('_');
    if (gripArray.length > 1)
      return '${gripArray[0].substring(0, 1).toUpperCase()}${gripArray[0].substring(1).toLowerCase()} ${gripArray[1].toLowerCase()}';
    else
      return '${gripArray[0].substring(0, 1).toUpperCase()}${gripArray[0].substring(1).toLowerCase()}';
  }

  void saveHangboardWorkoutToFirebase() {
    DocumentReference reference =
        Firestore.instance.document('hangboard/${widget.workoutTitle}');
    CollectionReference collectionReference =
        Firestore.instance.collection('hangboard/${widget.workoutTitle}');

    var data = createHangboardData();

    reference.setData(data);

    //onTap: () => record.reference.updateData({'votes': record.votes + 1})
  }

  //TODO: put general message about form errors below save button
  void saveTileFields() {
    if (widget.formKey.currentState.validate()) {
      widget.formKey.currentState.save();
      saveHangboardWorkoutToFirebase(); //TODO: make dao here?
      print('saved');
    } else {
      setState(() => _autoValidate = true);
    }
  }

  /// Dropdown box to select from a defined set of [Grip] choices.
  /// THIS SHOULD BE REQUIRED
  Widget gripDropdownTile() {
    return new Card(
      child: new ListTile(
        leading: Icon(Icons.pan_tool),
        title: DropdownButtonHideUnderline(
          child: new DropdownButton<Grip>(
            elevation: 10,
            hint: Text('Start by choosing a grip'),
            value: _grip,
            onChanged: (value) {
              setState(() {
                _grip = value;
              });
            },
            items: Grip.values.map((Grip grip) {
              return new DropdownMenuItem<Grip>(
                child: new Text(formatGrip(grip)),
                value: grip,
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  /// Optional tile to enter a [depth] value.
  Widget depthTile() {
    return new Card(
      child: SwitchListTile(
        key: PageStorageKey<String>('depth'),
        selected: _depthSelected,
        onChanged: (value) {
          setState(() {
            _depthSelected = value;
          });
        },
        value: _depthSelected,
        title: Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 8.0),
          child: new TextFormField(
            autovalidate: _autoValidate,
            validator: (value) {
              return hangboardFieldValidator(_depthSelected, value);
            },
            onSaved: (value) {
              _depth = int.tryParse(value);
            },
            decoration: InputDecoration(
              icon: Icon(Icons.keyboard_tab),
              labelText: '(${getDepthMeasurementSystem()})',
              hintText: 'Enter the depth of the hold.',
              //helperText: 'Unit: $_depthMeasurementSystem.',
            ),
            keyboardType: TextInputType.numberWithOptions(),
          ),
        ),
      ),
    );
  }

  /// Optional tile to enter a [resistance] value.
  Widget resistanceTile() {
    return new Card(
      child: SwitchListTile(
        key: PageStorageKey<String>('resistance'),
        selected: _resistanceSelected,
        onChanged: (value) {
          setState(() {
            _resistanceSelected = value;
          });
        },
        value: _resistanceSelected,
        title: Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 8.0),
          child: new TextFormField(
            autovalidate: _autoValidate,
            validator: (value) {
              return hangboardFieldValidator(_resistanceSelected, value);
            },
            onSaved: (value) {
              _resistance = int.tryParse(value);
              //TODO: Need negative resistance too
            },
            decoration: InputDecoration(
              icon: Icon(Icons.fitness_center),
              labelText: 'Resistance ($_resistanceMeasurementSystem)',
              hintText: 'Add or subtract resistance.',
              //helperText: 'Unit: $_resistanceMeasurementSystem.',
            ),
            keyboardType: TextInputType.numberWithOptions(),
          ),
        ),
      ),
    );
  }

  /// Tile to enter an amount of time to perform each [repetition]
  /// THIS SHOULD BE REQUIRED
  Widget hangDurationTile() {
    return new Card(
      child: SwitchListTile(
        key: PageStorageKey<String>('duration'),
        onChanged: (value) {
          setState(() {
            _repTimeSelected = value;
          });
        },
        value: _repTimeSelected,
        title: Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 8.0),
          child: new TextFormField(
            autovalidate: _autoValidate,
            validator: (value) {
              return hangboardFieldValidator(_repTimeSelected, value);
            },
            onSaved: (value) {
              _repTime = int.tryParse(value);
            },
            decoration: InputDecoration(
              icon: Icon(Icons.timer),
              labelText: 'Hang Duration (seconds)',
              hintText: 'How long each hang should last.',
              //helperText: 'Unit: seconds',
            ),
            keyboardType: TextInputType.numberWithOptions(),
          ),
        ),
      ),
    );
  }

  /// Tile to enter an amount of time to [rest] after each [repetition]
  /// THIS SHOULD BE REQUIRED
  Widget restTimeTile() {
    return new Card(
      child: SwitchListTile(
        key: PageStorageKey<String>('rest'),
        onChanged: (value) {
          setState(() {
            _restTimeSelected = value;
          });
        },
        value: _restTimeSelected,
        title: Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 8.0),
          child: new TextFormField(
            autovalidate: _autoValidate,
            validator: (value) {
              return hangboardFieldValidator(_restTimeSelected, value);
            },
            onSaved: (value) {
              _restTime = int.tryParse(value);
            },
            decoration: InputDecoration(
              icon: Icon(Icons.watch_later),
              hintText: 'Time in between hangs.',
              labelText: 'Rest Time (seconds)',
              //helperText: 'Unit: seconds',
            ),
            keyboardType: TextInputType.numberWithOptions(),
          ),
        ),
      ),
    );
  }

  /// Number of [repetitions] of this particular exercise
  /// THIS SHOULD BE REQUIRED
  Widget numberOfHangsTile() {
    return new Card(
      child: SwitchListTile(
        key: PageStorageKey<String>('hangs'),
        selected: _repsSelected,
        onChanged: (value) {
          setState(() {
            _repsSelected = value;
          });
        },
        value: _repsSelected,
        title: Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 8.0),
          child: new TextFormField(
            autovalidate: _autoValidate,
            validator: (value) {
              return hangboardFieldValidator(_repsSelected, value);
            },
            onSaved: (value) {
              _reps = int.tryParse(value);
            },
            decoration: InputDecoration(
              hintText: 'The number of hangs in a set.',
              labelText: 'Hangs',
              icon: Icon(Icons.format_list_bulleted),
            ),
            keyboardType: TextInputType.numberWithOptions(),
          ),
        ),
      ),
    );
  }

  Widget saveButton() {
    return new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new RaisedButton(
        onPressed: () {
          saveTileFields();
          setState(() {
            //TODO: Trying to figure out a way to shrink tile sets once they're
            //TODO: saved to reduce clutter for the user
          });
        },
        child: new Text('Save Set'),
        //TODO: make add another set button appear when this is saved, this doesn't appear until all fields entered
      ),
    );
  }

  /// ***Moved this from the tab screen - not sure if i want it within the
  /// individual expansionTiles or not -- trying it out here for now.
  ///
  /// Do i want there to only be one tile available at a time? Multiple could be
  /// very slow and cluttered. Having it here works for using a single tile,
  /// having it in the tab view probable works better for multiple tiles. NEED TO
  /// FIGURE THIS SCHEMA OUT STILL***
  ///
  ///
  /// This method currently packages the data to be sent to the Firestore.
  /// Not sure if I need this or want to make a separate object (probably should
  /// do that anyway) to send the data instead. I could also make the [exercises]
  /// field a member var of this tab, and then each [exercise] could add it's own
  /// state info like [_depth] and [_grip] to the global [exercises].
  Map createHangboardData() {
    Map<String, dynamic> data = {};

    data.putIfAbsent("exercises", () {
      var exercises = [];

      var exercise = {
        "depth": _depth,
        "grip": _grip.toString(),
        "resistance": _resistance,
        "repTime": _repTime,
        "restTime": _restTime,
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
/*
Just keeping these around in case i ever want to use them
icon: Icon(Icons.trending_up),
                        icon: Icon(Icons.import_export),*/
}
