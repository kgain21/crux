import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crux/model/finger_configurations_enum.dart';
import 'package:crux/model/hold_enum.dart';
import 'package:crux/widgets/local_unit_picker_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../utils/string_format_utils.dart';

class ExerciseForm extends StatefulWidget {
  final String workoutTitle;

  ExerciseForm({
    this.workoutTitle,
  });

  @override
  State createState() => new _ExerciseFormState();
}

class _ExerciseFormState extends State<ExerciseForm> {
  final TextEditingController depthController = TextEditingController();
  final TextEditingController timeOnController = TextEditingController();
  final TextEditingController timeOffController = TextEditingController();
  final TextEditingController hangsPerSetController = TextEditingController();
  final TextEditingController timeBetweenSetsController =
      TextEditingController();
  final TextEditingController numberOfSetsController = TextEditingController();
  final TextEditingController resistanceController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey(debugLabel: 'ExerciseForm');

  String _depthMeasurementSystem;
  String _resistanceMeasurementSystem;
  int _numberOfHands;
  Hold _hold;
  FingerConfiguration _fingerConfiguration;
  double _depth;
  int _timeOff;
  int _timeOn;
  int _hangsPerSet;
  int _timeBetweenSets;
  int _numberOfSets;
  int _resistance;

  bool _holdSelected;
  bool _hangProtocolSelected;
  bool _autoValidate;

  @override
  void initState() {
    super.initState();

    _numberOfHands = 2;
    _holdSelected = false;
    _depthMeasurementSystem = 'mm';
    _resistanceMeasurementSystem = 'kg';
    _hangProtocolSelected = false;
    _autoValidate = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text('Create a new exercise'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.info),
            tooltip: 'Help',
            onPressed: () {},
          ),
        ],
      ),
      body: Builder(
        builder: (scaffoldContext) => Form(
              key: formKey,
              /*https://medium.com/saugo360/https-medium-com-saugo360-flutter-using-overlay-to-display-floating-widgets-2e6d0e8decb9
            TODO: See if I can get the keyboard to jump to the text form field in focus (nice to have)
            https://stackoverflow.com/questions/46841637/show-a-text-field-dialog-without-being-covered-by-keyboard/46849239#46849239
            TODO: ^ this was the original solution to the keyboard covering text fields, might want to refer to it in the future
             */
              child: exerciseFormWidget(scaffoldContext),
            ),
      ),
    );
  }

  Widget exerciseFormWidget(BuildContext scaffoldContext) {
    return ListView(
      children: <Widget>[
        UnitPickerTile(
            resistanceCallback: updateResistanceMeasurement,
            depthCallback: updateDepthMeasurement,
            initialDepthMeasurement: _depthMeasurementSystem,
            initialResistanceMeasurement: _resistanceMeasurementSystem),
        numberOfHandsTile(),
        holdDropdownTile(),
        (_holdSelected && (_hold == Hold.POCKET || _hold == Hold.OPEN_HAND))
            ? fingerConfigurationDropdownTile(_hold)
            : null,
        (_holdSelected &&
                (_hold != Hold.JUGS &&
                    _hold != Hold.SLOPER &&
                    _hold != Hold.PINCH))
            ? depthTile()
            : null,
        hangDurationTile(),
        // hangProtocolTile(),
        hangsPerSetTile(),
        timeBetweenSetsTile(),
        numberOfSetsTile(),
        resistanceTile(),
        saveButton(scaffoldContext)
      ].where(notNull).toList(),
    );
  }

  /// Very elegant way to conditionally add widgets to a list that I found.
  /// Makes use of [where] and this function to make an [Iterable] which is then
  /// turned back into a list without the null entries.
  bool notNull(Object o) => o != null;

  void updateResistanceMeasurement(String value) {
    setState(() {
      _resistanceMeasurementSystem = value;
    });
  }

  void updateDepthMeasurement(String value) {
    setState(() {
      _depthMeasurementSystem = value;
    });
  }

  Widget numberOfHandsTile() {
    return new Card(
      child: ListTile(
        key: PageStorageKey('numberOfHandsTile'),
        title: Row(
          children: <Widget>[
            Flexible(
              child: RadioListTile(
                title: Text('One hand'),
                value: 1,
                groupValue: _numberOfHands,
                onChanged: (value) {
                  setState(() {
                    _numberOfHands = value;
                  });
                },
              ),
            ),
            Flexible(
              child: RadioListTile(
                  title: Text('Two hands'),
                  value: 2,
                  groupValue: _numberOfHands,
                  onChanged: (value) {
                    setState(() {
                      _numberOfHands = value;
                    });
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Widget holdDropdownTile() {
    return new Card(
      child: new ListTile(
        leading: Icon(
          Icons.pan_tool,
        ),
        title: DropdownButtonHideUnderline(
          child: new DropdownButton<Hold>(
            elevation: 10,
            hint: Text(
              'Choose a hold',
            ),
            value: _hold,
            onChanged: (value) {
              setState(() {
                _hold = value;
                _holdSelected = true;
              });
            },
            items: Hold.values.map((Hold hold) {
              return new DropdownMenuItem<Hold>(
                child: new Text(
                  StringFormatUtils.formatHold(hold),
                ),
                value: hold,
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget fingerConfigurationDropdownTile(Hold hold) {
    return new Card(
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
            items: mapFingerConfigurations(hold),
          ),
        ),
      ),
    );
  }

  Widget depthTile() {
    return new Card(
      child: ListTile(
        title: Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 8.0),
          child: new TextFormField(
            controller: depthController,
            autovalidate: _autoValidate,
            onSaved: (value) {
              _depth = double.parse(value);
            },
            decoration: InputDecoration(
              icon: Icon(Icons.keyboard_tab),
              labelText: 'Depth ($_depthMeasurementSystem)',
            ),
            keyboardType:
                TextInputType.numberWithOptions(signed: true, decimal: true),
          ),
        ),
      ),
    );
  }

  Widget hangDurationTile() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 4.0),
        child: Row(
          children: <Widget>[
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 8.0, top: 0.0, right: 8.0, bottom: 8.0),
                child: TextFormField(
                  controller: timeOnController,
                  autovalidate: _autoValidate,
                  validator: (value) {
                    return hangboardFieldValidator(value);
                  },
                  onSaved: (value) {
                    _timeOn = int.tryParse(value);
                  },
                  decoration: InputDecoration(
                    labelText: 'Time On (sec)',
                  ),
                  keyboardType: TextInputType.numberWithOptions(),
                ),
              ),
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 8.0, top: 0.0, right: 8.0, bottom: 8.0),
                child: TextFormField(
                  controller: timeOffController,
                  autovalidate: _autoValidate,
                  validator: (value) {
                    return hangboardFieldValidator(value);
                  },
                  onSaved: (value) {
                    setState(() {
                      _timeOff = int.tryParse(value);
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Time Off (sec)',
                  ),
                  keyboardType: TextInputType.numberWithOptions(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget hangProtocolTile() {
    return Card(
      child: new CheckboxListTile(
        key: PageStorageKey('hangProtocolTile'),
        value: _hangProtocolSelected,
        onChanged: (value) {
          setState(() {
            _hangProtocolSelected = value;
          });
        },
        title: Text('Include Hang Protocol?'),
      ),
    );
  }

  Widget hangsPerSetTile() {
    return Card(
      child: ListTile(
        key: PageStorageKey<String>('hangsPerSetTile'),
        title: Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 8.0),
          child: new TextFormField(
            controller: hangsPerSetController,
            autovalidate: _autoValidate,
            validator: (value) {
              return hangboardFieldValidator(value);
            },
            onSaved: (value) {
              _hangsPerSet = int.tryParse(value);
            },
            decoration: InputDecoration(
              labelText: 'Hangs per set',
              icon: Icon(Icons.format_list_bulleted),
            ),
            keyboardType: TextInputType.numberWithOptions(),
          ),
        ),
      ),
    );
  }

  Widget timeBetweenSetsTile() {
    return Card(
      child: ListTile(
        key: PageStorageKey<String>('timeBetweenSetsTile'),
        title: Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 8.0),
          child: new TextFormField(
            controller: timeBetweenSetsController,
            autovalidate: _autoValidate,
            validator: (value) {
              return hangboardFieldValidator(value);
            },
            onSaved: (value) {
              _timeBetweenSets = int.tryParse(value);
            },
            decoration: InputDecoration(
              icon: Icon(Icons.watch_later),
              labelText: 'Time between sets (sec)',
            ),
            keyboardType: TextInputType.numberWithOptions(),
          ),
        ),
      ),
    );
  }

  Widget numberOfSetsTile() {
    return Card(
      child: ListTile(
        key: PageStorageKey<String>('numberOfSetsTile'),
        title: Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 8.0),
          child: new TextFormField(
            controller: numberOfSetsController,
            autovalidate: _autoValidate,
            validator: (value) {
              return hangboardFieldValidator(value);
            },
            onSaved: (value) {
              _numberOfSets = int.tryParse(value);
            },
            decoration: InputDecoration(
              labelText: 'Number of sets',
              icon: Icon(Icons.format_list_bulleted),
            ),
            keyboardType: TextInputType.numberWithOptions(),
          ),
        ),
      ),
    );
  }

  Widget resistanceTile() {
    return Card(
      child: ListTile(
        key: PageStorageKey<String>('resistanceTile'),
        title: Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 8.0),
          child: new TextFormField(
            controller: resistanceController,
            autovalidate: _autoValidate,
            validator: (value) {
              var intValue = int.tryParse(value);
              if (intValue == null) {
                return 'Please enter a number.';
              }
              if (intValue.isNaN) return 'Please enter a real number.';
              return null;
            },
            onSaved: (value) {
              _resistance = int.tryParse(value);
              //TODO: Need negative resistance too
            },
            decoration: InputDecoration(
              icon: Icon(Icons.fitness_center),
              labelText: 'Resistance ($_resistanceMeasurementSystem)',
            ),
            keyboardType: TextInputType.numberWithOptions(),
          ),
        ),
      ),
    );
  }

  Widget saveButton(BuildContext scaffoldContext) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: RaisedButton(
        onPressed: () {
          saveTileFields(scaffoldContext);
        },
        child: Text('Save Set'),
      ),
    );
  }

  /// Tried to make a generic validator for the different [exercise] fields since
  /// they're almost all [int] fields. If there are other non [int] fields that
  /// I add, I could always abstract it out another level to an even more generic
  /// validation picker method.
  String hangboardFieldValidator(String fieldValue) {
    var intValue = int.tryParse(fieldValue);
    if (intValue == null) {
      return 'Please enter a number.';
    }
    if (intValue.isNaN) return 'Please enter a real number.';
    if (intValue.isNegative) return 'Please enter a positive number.';
    return null;
  }

  //TODO: put general message about form errors below save button
  void saveTileFields(BuildContext scaffoldContext) {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      saveHangboardWorkoutToFirebase(scaffoldContext); //TODO: make dao here?
    } else {
      setState(() => _autoValidate = true);
    }
  }

  void saveHangboardWorkoutToFirebase(BuildContext scaffoldContext) {
    CollectionReference collectionReference = Firestore.instance
        .collection('hangboard/${widget.workoutTitle}/exercises');

    var data = createHangboardData();
    String dataId = createDataId(data);

    var exerciseRef = collectionReference.document(dataId);
    exerciseRef.get().then((doc) {
      if (doc.exists) {
        _exerciseExistsAlert(scaffoldContext, exerciseRef, data);
      } else {
        exerciseRef.setData(data);
        exerciseSavedSnackbar(scaffoldContext);
      }
    });
  }

  /// This method currently packages the data to be sent to the Firestore.
  /// Not sure if I need this or want to make a separate object (probably should
  /// do that anyway) to send the data instead. I could also make the [exercises]
  /// field a member var of this tab, and then each [exercise] could add it's own
  /// state info like [_depth] and [_hold] to the global [exercises].
  /// //TODO: Make sure these defaults are ok
  /// //TODO: Make object that gets serialized to be sent to FireBase
  Map createHangboardData() {
    Map<String, dynamic> data = {
      "resistanceMeasurementSystem": _resistanceMeasurementSystem,
      "depthMeasurementSystem": _depthMeasurementSystem,
      "numberOfHands": _numberOfHands,
      "depth": _depth ?? '',
      "hold": StringFormatUtils.formatHold(_hold),
      "fingerConfiguration": (_fingerConfiguration != null)
          ? StringFormatUtils.formatFingerConfiguration(_fingerConfiguration)
          : '',
      "resistance": _resistance ?? '',
      "timeOn": _timeOn,
      "timeOff": _timeOff,
      "hangsPerSet": _hangsPerSet ?? '',
      "timeBetweenSets": _timeBetweenSets ?? '',
      "numberOfSets": _numberOfSets,
    };
    return data;
  }

  //TODO: This needs to have more to it - 1/2 hands, etc.
  String createDataId(Map data) {
    var depth = data['depth'];
    var measurement = data['depthMeasurementSystem'];
    var hold = data['hold'];
    var fingerConfiguration = data['fingerConfiguration'];

    if (depth == null || depth == '') {
      if (fingerConfiguration == null || fingerConfiguration == '') {
        return hold;
      } else {
        return '$fingerConfiguration $hold';
      }
    } else {
      return '$depth$measurement $fingerConfiguration $hold';
    }
  }

  List<Widget> mapFingerConfigurations(Hold hold) {
    if (hold == Hold.POCKET) {
      return FingerConfiguration.values
          .sublist(0, 6)
          .map((FingerConfiguration fingerConfiguration) {
        return new DropdownMenuItem<FingerConfiguration>(
          child: new Text(
            StringFormatUtils.formatFingerConfiguration(fingerConfiguration),
          ),
          value: fingerConfiguration,
        );
      }).toList();
    } else if (hold == Hold.OPEN_HAND) {
      return FingerConfiguration.values
          .sublist(4)
          .map((FingerConfiguration fingerConfiguration) {
        return new DropdownMenuItem<FingerConfiguration>(
          child: new Text(
            StringFormatUtils.formatFingerConfiguration(fingerConfiguration),
          ),
          value: fingerConfiguration,
        );
      }).toList();
    } else {
      return FingerConfiguration.values
          .map((FingerConfiguration fingerConfiguration) {
        return new DropdownMenuItem<FingerConfiguration>(
          child: new Text(
            StringFormatUtils.formatFingerConfiguration(fingerConfiguration),
          ),
          value: fingerConfiguration,
        );
      }).toList();
    }
  }

  Future<void> _exerciseExistsAlert(BuildContext scaffoldContext,
      DocumentReference exerciseRef, Map data) async {
    String exercise = StringFormatUtils.formatDepthAndHold(
        _depth,
        _depthMeasurementSystem,
        StringFormatUtils.formatFingerConfiguration(_fingerConfiguration),
        StringFormatUtils.formatHold(_hold));

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Exercise already exists'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                RichText(
                  text: TextSpan(
                    style: TextStyle(color: Colors.black, fontSize: 16.0),
                    children: [
                      TextSpan(
                          text: 'You already have an exercise created for '),
                      TextSpan(
                        text: '$exercise.\n\n',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                          text: 'Would you like to replace it with this one?'),
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
                    'Cancel',
                    style: TextStyle(color: Colors.black54),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                FlatButton(
                    child: Text('Replace'),
                    onPressed: () {
                      exerciseRef.setData(data);
                      exerciseSavedSnackbar(scaffoldContext);
                      Navigator.of(context).pop();
                    }),
              ],
            ),
          ],
        );
      },
    );
  }

  void exerciseSavedSnackbar(BuildContext scaffoldContext) {
    Scaffold.of(scaffoldContext).showSnackBar(
      SnackBar(
        duration: Duration(days: 1),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Exercise Saved!',
                      style: TextStyle(
                          color: Theme.of(scaffoldContext).accentColor),
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    FlatButton(
                      child: Row(
                        children: <Widget>[
                          Text('Back'),
                        ],
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    FlatButton(
                      child: Row(
                        children: <Widget>[
                          Text('Continue Editing'),
                        ],
                      ),
                      onPressed: () {
                        Scaffold.of(scaffoldContext).hideCurrentSnackBar();
                      },
                    ),
                    FlatButton(
                      child: Row(
                        children: <Widget>[
                          Text('Reset'),
                        ],
                      ),
                      onPressed: () {
                        formKey.currentState.reset();
                        clearFields();
                        Scaffold.of(scaffoldContext).hideCurrentSnackBar();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void clearFields() {
    setState(() {
      timeOffController.clear();
      hangsPerSetController.clear();
      timeBetweenSetsController.clear();
      numberOfSetsController.clear();
      resistanceController.clear();
      timeOnController.clear();
      _numberOfHands = 2;
      _holdSelected = false;
      //TODO: don't think nulls work here
      _fingerConfiguration = null;
      _hold = null;
      _depthMeasurementSystem = 'mm';
      _resistanceMeasurementSystem = 'kg';
      _hangProtocolSelected = false;
      _autoValidate = false;
    });
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
