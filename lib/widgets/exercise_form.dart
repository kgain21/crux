import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crux/model/finger_configurations_enum.dart';
import 'package:crux/model/grip_enum.dart';
import 'package:crux/shared_layouts/fab_bottom_app_bar.dart';
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

  final TextEditingController depthController = TextEditingController();
  final TextEditingController timeOnController = TextEditingController();
  final TextEditingController timeOffController = TextEditingController();
  final TextEditingController hangsPerSetController = TextEditingController();
  final TextEditingController timeBetweenSetsController = TextEditingController();
  final TextEditingController numberOfSetsController = TextEditingController();
  final TextEditingController resistanceController = TextEditingController();

  final GlobalKey<FormState> formKey =
      GlobalKey(debugLabel: 'ExerciseForm');

  String _depthMeasurementSystem;
  String _resistanceMeasurementSystem;
  Grip _grip;
  FingerConfiguration _fingerConfiguration;
  int _depth;
  int _timeOff;
  int _timeOn;
  int _hangsPerSet;
  int _timeBetweenSets;
  int _numberOfSets;
  int _resistance;

  bool _gripSelected;
  bool _hangProtocolSelected;
  bool _autoValidate;

  @override
  void initState() {
    super.initState();

    _gripSelected = false;
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
            onPressed: () {
              //TODO: show overlay?
            },
          ),
        ],
      ),
      body: Form(
        key: formKey,
        /*https://medium.com/saugo360/https-medium-com-saugo360-flutter-using-overlay-to-display-floating-widgets-2e6d0e8decb9
          TODO: See if I can get the keyboard to jump to the text form field in focus (nice to have)
          https://stackoverflow.com/questions/46841637/show-a-text-field-dialog-without-being-covered-by-keyboard/46849239#46849239
          TODO: ^ this was the original solution to the keyboard covering text fields, might want to refer to it in the future
           */
        child: exerciseFormWidget(),
      ),
      /*bottomNavigationBar: new FABBottomAppBar(
        //backgroundColor: Colors.blueGrey,
        //Color.fromARGB(255, 44, 62, 80),
        //midnight blue// Colors.white,
        //Color.fromARGB(255, 229, 191, 126),
        //color: Colors.white,
        //selectedColor: Colors.white,
        items: <FABBottomAppBarItem>[
          FABBottomAppBarItem(
            iconData: Icons.home,
            text: 'Home',
          ),
           FABBottomAppBarItem(
            iconData: Icons.menu,
            text: 'Menu',
          ),
        ],
        onTabSelected: (index) {
          if (index == 0) {
            Navigator.popUntil(
                context, ModalRoute.withName('/dashboard_screen'));
          } else {
            return null;
          }
        },
      ),*/
    );
  }

  Widget exerciseFormWidget() {
    return ListView(
      children: <Widget>[
        UnitPickerTile(
          resistanceCallback: updateResistanceMeasurement,
          depthCallback: updateDepthMeasurement,
        ),
        gripDropdownTile(),
        (_gripSelected && (_grip == Grip.POCKET || _grip == Grip.OPEN_HAND))
            ? fingerConfigurationDropdownTile(_grip)
            : null,
        (_gripSelected &&
                (_grip != Grip.JUGS &&
                    _grip != Grip.SLOPER &&
                    _grip != Grip.PINCH))
            ? depthTile()
            : null,
        hangProtocolDurationTile(),
        hangProtocolTile(),
        _hangProtocolSelected ? hangsPerSetTile() : null,
        _hangProtocolSelected ? timeBetweenSetsTile() : null,
        numberOfSetsTile(),
        resistanceTile(),
        saveButton()
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

  Widget gripDropdownTile() {
    return new Card(
      child: new ListTile(
        leading: Icon(
          Icons.pan_tool,
        ),
        title: DropdownButtonHideUnderline(
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
                child: new Text(
                  formatGrip(grip),
                ),
                value: grip,
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget fingerConfigurationDropdownTile(Grip grip) {
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
            items: mapFingerConfigurations(grip),
          ),
        ),
      ),
    );
  }

  /*
  TODO: can change focus to next field on submit each time (nice to have)
  https://medium.com/flutterpub/flutter-keyboard-actions-and-next-focus-field-3260dc4c694
  onFieldSubmitted: null,
  */

  Widget depthTile() {
    return new Card(
      child: ListTile(
        key: PageStorageKey<String>('depth'),
        title: Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 8.0),
          child: new TextFormField(
            controller: depthController,
            autovalidate: _autoValidate,
            validator: (value) {
              return hangboardFieldValidator(value);
            },
            onSaved: (value) {
              _depth = int.tryParse(value);
            },
            decoration: InputDecoration(
              icon: Icon(Icons.keyboard_tab),
              labelText: 'Depth ($_depthMeasurementSystem)',
            ),
            keyboardType: TextInputType.numberWithOptions(),
          ),
        ),
      ),
    );
  }

  Widget hangProtocolDurationTile() {
    return Card(
      child: Row(
        children: <Widget>[
          Flexible(
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 8.0, top: 0.0, right: 8.0, bottom: 8.0),
              child: TextFormField(
                controller: timeOnController,
                key: PageStorageKey('timeOn'),
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
                key: PageStorageKey('timeOff'),
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
              return hangboardFieldValidator(value);
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

  Widget saveButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: RaisedButton(
        onPressed: () {
          saveTileFields();
        },
        child: Text('Save Set'),
        //TODO: make add another set button appear when this is saved, this doesn't appear until all fields entered
      ),
    );
  }

  /// Tried to make a generic validator for the different [exercise] fields since
  /// they're almost all [int] fields. If there are other non [int] fields that
  /// I add, I could always abstract it out another level to an even more generic
  /// validation picker method.
  //TODO: make unselected boxes grayed out (cant type in them)
  String hangboardFieldValidator(String fieldValue) {
    var intValue = int.tryParse(fieldValue);
    if (intValue == null) {
      return 'Please enter a number.';
    }
    if (intValue.isNaN) return 'Please enter a real number.';
    if (intValue.isNegative) return 'Please enter a positive number.';
    return null;
  }

  /// Formatter for the different [Grips] I have available. This basically just
  /// takes the enum form and makes it a better looking String for the dropdown.
  String formatGrip(Grip grip) {
    var gripArray = grip.toString().substring(5).split('_');
    String formattedGrip = '';
    for (int i = 0; i < gripArray.length; i++) {
      formattedGrip = formattedGrip +
          '${gripArray[i].substring(0, 1).toUpperCase()}${gripArray[i].substring(1).toLowerCase()}';
      if (!(i == gripArray.length - 1)) {
        formattedGrip += ' ';
      }
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
      if (!(i == fingerConfigurationArray.length - 1)) {
        formattedConfiguration += '-';
      }
    }
    return formattedConfiguration;
  }

  void saveHangboardWorkoutToFirebase() {
    CollectionReference collectionReference = Firestore.instance
        .collection('hangboard/${widget.workoutTitle}/exercises');

    var data = createHangboardData();
    String dataId = createDataId(data);

    //TODO: DEFINITELY NEED SOME ERROR HANDLING HERE IF SAVE FAILS
    var exerciseRef = collectionReference.document(dataId);
    exerciseRef.get().then((doc) {
      if (doc.exists) {
        print('$doc exists, would you like to update it?');
      } else {
        exerciseRef.setData(data);
      }
    });

    //reference.updateData({exercises: firebase.firestore.FieldValue.arrayUnion(data)});
    // reference.updateData(data);
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

  /// This method currently packages the data to be sent to the Firestore.
  /// Not sure if I need this or want to make a separate object (probably should
  /// do that anyway) to send the data instead. I could also make the [exercises]
  /// field a member var of this tab, and then each [exercise] could add it's own
  /// state info like [_depth] and [_grip] to the global [exercises].
  /// //TODO: Make sure these defaults are ok
  Map createHangboardData() {
    Map<String, dynamic> data = {
      "resistanceMeasurementSystem": _resistanceMeasurementSystem,
      "depthMeasurementSystem": _depthMeasurementSystem,
      "depth": _depth ?? '',
      "grip": formatGrip(_grip),
      "fingerConfiguration": (_fingerConfiguration != null)
          ? formatFingerConfiguration(_fingerConfiguration)
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

  String createDataId(Map data) {
    var depth = data['depth'];
    var measurement = data['depthMeasurementSystem'];
    var grip = data['grip'];
    var fingerConfiguration = data['fingerConfiguration'];

    if(depth == null || depth == '') {
      if(fingerConfiguration == null || fingerConfiguration == '') {
        return grip;
      } else {
        return '$fingerConfiguration $grip';
      }
    } else {
      return '$depth$measurement $fingerConfiguration $grip';
    }
  }

  List<Widget> mapFingerConfigurations(Grip grip) {
    if (grip == Grip.POCKET) {
      return FingerConfiguration.values
          .sublist(0, 6)
          .map((FingerConfiguration fingerConfiguration) {
        return new DropdownMenuItem<FingerConfiguration>(
          child: new Text(
            formatFingerConfiguration(fingerConfiguration),
          ),
          value: fingerConfiguration,
        );
      }).toList();
    } else if (grip == Grip.OPEN_HAND) {
      return FingerConfiguration.values
          .sublist(4)
          .map((FingerConfiguration fingerConfiguration) {
        return new DropdownMenuItem<FingerConfiguration>(
          child: new Text(
            formatFingerConfiguration(fingerConfiguration),
          ),
          value: fingerConfiguration,
        );
      }).toList();
    } else {
      return FingerConfiguration.values
          .map((FingerConfiguration fingerConfiguration) {
        return new DropdownMenuItem<FingerConfiguration>(
          child: new Text(
            formatFingerConfiguration(fingerConfiguration),
          ),
          value: fingerConfiguration,
        );
      }).toList();
    }
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
