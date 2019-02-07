import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crux/model/finger_configurations_enum.dart';
import 'package:crux/model/grip_enum.dart';
import 'package:crux/widgets/local_unit_picker_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ExerciseForm extends StatefulWidget {
  final String workoutTitle;

  ExerciseForm({
    this.workoutTitle,
  });

  @override
  State createState() => new _ExerciseFormState();
}

class _ExerciseFormState extends State<ExerciseForm> {
  Grip _grip;
  bool _gripSelected;
  FingerConfiguration _fingerConfiguration;
  int _repTime;
  int _restTime;
  GlobalKey<FormState> formKey;

  String _resistance;
  String _depth;
  int _reps;

  String _depthMeasurementSystem;
  String _resistanceMeasurementSystem;

  bool _depthSelected;
  bool _repsSelected;
  bool _resistanceSelected;
  bool _repTimeSelected;
  bool _restTimeSelected;
  bool _autoValidate;

  @override
  void initState() {
    super.initState();
    formKey = new GlobalKey<FormState>(debugLabel: 'ExerciseForm');

    _gripSelected = false;
    _depthMeasurementSystem = 'mm';
    _resistanceMeasurementSystem = 'kg';
    _depthSelected = true;
    _repsSelected = true;
    _resistanceSelected = true;
    _repTimeSelected = true;
    _restTimeSelected = true;
    _autoValidate = false;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4.0,
      child: Form(
        key: formKey,
        /*https://medium.com/saugo360/https-medium-com-saugo360-flutter-using-overlay-to-display-floating-widgets-2e6d0e8decb9
          TODO: See if I can get the keyboard to jump to the text form field in focus (nice to have)
          https://stackoverflow.com/questions/46841637/show-a-text-field-dialog-without-being-covered-by-keyboard/46849239#46849239
          TODO: ^ this was the original solution to the keyboard covering text fields, might want to refer to it in the future
           */
        child: AnimatedContainer(
          padding: MediaQuery.of(context).viewInsets,
          duration: const Duration(milliseconds: 300),
          child: exerciseFormWidget(),
        ),
      ),
    );
  }

  Widget exerciseFormWidget() {
    if (_gripSelected) {
      return ListView(
        children: <Widget>[
          UnitPickerTile(
            resistanceCallback: updateResistanceMeasurement,
            depthCallback: updateDepthMeasurement,
          ),
          gripDropdownTile(),
          fingerConfigurationDropdownTile(),
          resistanceTile(),
          depthTile(),
          hangDurationTile(),
          restTimeTile(),
          numberOfHangsTile(),
          saveButton()
        ],
      );
    } else {
      return ListView(
        children: <Widget>[
          UnitPickerTile(
            resistanceCallback: updateResistanceMeasurement,
            depthCallback: updateDepthMeasurement,
          ),
          gripDropdownTile(),
          resistanceTile(),
          depthTile(),
          hangDurationTile(),
          restTimeTile(),
          numberOfHangsTile(),
          saveButton()
        ],
      );
    }
  }

  Function updateResistanceMeasurement(String value) {
    setState(() {
      _resistanceMeasurementSystem = value;
    });
  }

  Function updateDepthMeasurement(String value) {
    setState(() {
      _depthMeasurementSystem = value;
    });
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
    String formattedGrip = '';
    for (int i = 0; i < gripArray.length; i++) {
      formattedGrip = formattedGrip +
          '${gripArray[i].substring(0, 1).toUpperCase()}${gripArray[i].substring(1).toLowerCase()} ';
    }
    return formattedGrip;
  }

  /// Formatter for the different [FingerConfiguration]s I have available. This basically just
  /// takes the enum form and makes it a better looking String for the dropdown.
  String formatFingerConfiguration(FingerConfiguration fingerConfiguration) {
    var fingerConfigurationArray =
        fingerConfiguration.toString().substring(20).split('_');
    String formattedConfiguration = '';
    for (int i = 0; i < fingerConfigurationArray.length; i++) {
      formattedConfiguration = formattedConfiguration +
          '${fingerConfigurationArray[i].substring(0, 1).toUpperCase()}${fingerConfigurationArray[i].substring(1).toLowerCase()}';
      if(!(i == fingerConfigurationArray.length - 1)) {
        formattedConfiguration += '/';
      }
    }
    return formattedConfiguration;
  }

  void saveHangboardWorkoutToFirebase() {
    DocumentReference reference =
        Firestore.instance.document('hangboard/${widget.workoutTitle}');
    CollectionReference collectionReference = Firestore.instance
        .collection('hangboard/${widget.workoutTitle}/exercises');

    var data = createHangboardData();
    // String dataId = createDataId();

    var collectionSnapshot = collectionReference.snapshots();
    var documentSnapshot = reference.snapshots();

    // collectionReference.add(data);
    //TODO: DEFINITELY NEED SOME ERROR HANDLING HERE IF SAVE FAILS
    /*var exerciseRef = collectionReference.document(dataId);
    exerciseRef.get().then((doc) {
      if (doc.exists) {
        print('$doc exists');
      } else {
        exerciseRef.setData(data);
      }
    });*/

    //reference.updateData({exercises: firebase.firestore.FieldValue.arrayUnion(data)});
//    reference.updateData(data);
  }

  //TODO: put general message about form errors below save button
  void saveTileFields() {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      saveHangboardWorkoutToFirebase(); //TODO: make dao here?
      print('saved');
    } else {
      setState(() => _autoValidate = true);
    }
  }

  /// Dropdown box to select from a defined set of [Grip] choices.
  /// THIS SHOULD BE REQUIRED
  Widget titleTile() {
    return new Card(
      child: new ListTile(
          //leading: Icon(Icons.pan_tool),
          title: TextFormField(
        initialValue: 'Exercise Title',
      )),
    );
  }

  Widget gripDropdownTile() {
    return new Card(
      //color: Colors.blueGrey,
      child: new ListTile(
        leading: Icon(
          Icons.pan_tool,
        ),
        title:
            /* Container(
          constraints: BoxConstraints.loose(Size(100.0, 50.0)),
          decoration: BoxDecoration(
            color: Colors.blueGrey,
            boxShadow: [BoxShadow(offset: Offset(2.0, 2.0))],
          ),
          child:*/
            DropdownButtonHideUnderline(
          child: new DropdownButton<Grip>(
            elevation: 10,
            hint: Text(
              'Choose a grip',
            ),
            value: _grip,
            onChanged: (value) {
              setState(() {
                _grip = value;
                _gripSelected = true;
              });
            },
            items: Grip.values.map((Grip grip) {
              return new DropdownMenuItem<Grip>(
                /*child: Container(
                    constraints: BoxConstraints.loose(Size(100.0, 50.0)),
                    decoration: BoxDecoration(
                      color: Colors.blueGrey,
                      boxShadow: [BoxShadow(offset: Offset(2.0, 2.0))],
                    ),*/
                child: new Text(
                  formatGrip(grip),
                  style: TextStyle(color: Colors.black),
                ),
                /* ),*/
                value: grip,
              );
            }).toList(),
          ),
        ),
      ),
//      ),
    );
  }

  Widget fingerConfigurationDropdownTile() {
    return new Card(
      // color: Colors.blueGrey,
      child: new ListTile(
        leading: Icon(
          //TODO: find better icons on fontAwesome?
          Icons.pan_tool,
        ),
        title: DropdownButtonHideUnderline(
          child: new DropdownButton<FingerConfiguration>(
            elevation: 10,
            hint: Text(
              'Choose a finger configuration',
            ),
            value: _fingerConfiguration,
            onChanged: (value) {
              setState(() {
                _fingerConfiguration = value;
              });
            },
            items: FingerConfiguration.values
                .map((FingerConfiguration fingerConfiguration) {
              return new DropdownMenuItem<FingerConfiguration>(
                child: new Text(
                  // formatGrip(grip),
                  formatFingerConfiguration(fingerConfiguration),
                  style: TextStyle(color: Colors.black),
                ),
                value: fingerConfiguration,
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
      // color: Colors.blueGrey,
      child: SwitchListTile(
        key: PageStorageKey<String>('depth'),
        //TODO: gray out if not selected
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
              _depth = value;
            },

            /*
            TODO: can change focus to next field on submit each time (nice to have)
            https://medium.com/flutterpub/flutter-keyboard-actions-and-next-focus-field-3260dc4c694
            onFieldSubmitted: null,
            */
            decoration: InputDecoration(
              icon: Icon(Icons.keyboard_tab),
              labelText: 'Depth ($_depthMeasurementSystem)',
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
      // color: Colors.blueGrey,
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
              _resistance = value;
              //TODO: Need negative resistance too
            },
            decoration: InputDecoration(
              icon: Icon(Icons.fitness_center),
              labelText: 'Resistance ($_resistanceMeasurementSystem)',
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
      // color: Colors.blueGrey,
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
              labelText: 'Hang Duration (sec)',
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
      // color: Colors.blueGrey,
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
              labelText: 'Rest Time (sec)',
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
      // color: Colors.blueGrey,
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
    Map<String, dynamic> data = {
      "depth": _depth,
      "grip": formatGrip(_grip),
      "resistance": _resistance,
      "repTime": _repTime,
      "restTime": _restTime,
      "reps": _reps,
    };
    return data;
  }

  String createDataId() {
    return '$_depth$_depthMeasurementSystem$_grip$_resistance$_resistanceMeasurementSystem';
  }

//TODO: Figure out how to use date w/ firestore -- crashes app with this shit:
//todo: java.lang.IllegalArgumentException: Unsupported value: Timestamp(seconds=1549021849, nanoseconds=676000000)
/*data.putIfAbsent("created_date", () {
      return DateTime.now();
    });*/

/* Map<String, Object> data = new LinkedHashMap();
    DateTime createdTimestamp = DateTime.now();

    Map<String, Object> exercise = new LinkedHashMap();
    exercise.putIfAbsent('depth', _depth);*/
}
/*
Just keeping these around in case i ever want to use them
icon: Icon(Icons.trending_up),
                        icon: Icon(Icons.import_export),*/
