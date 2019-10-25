import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crux/backend/blocs/hangboard/exerciseform/exercise_form_bloc.dart';
import 'package:crux/backend/blocs/hangboard/exerciseform/exercise_form_event.dart';
import 'package:crux/backend/blocs/hangboard/exerciseform/exercise_form_state.dart';
import 'package:crux/backend/models/hangboard/finger_configurations_enum.dart';
import 'package:crux/backend/models/hangboard/hold_enum.dart';
import 'package:crux/backend/repository/firestore_hangboard_workouts_repository.dart';
import 'package:crux/frontend//widgets/local_unit_picker_tile.dart';
import 'package:crux/utils/string_format_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExerciseForm extends StatefulWidget {
  final String workoutTitle;
  final FirestoreHangboardWorkoutsRepository
  firestoreHangboardWorkoutsRepository;

  ExerciseForm({this.firestoreHangboardWorkoutsRepository, this.workoutTitle});

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

  ExerciseFormBloc _exerciseFormBloc;

  @override
  void initState() {
    super.initState();
    _exerciseFormBloc = /* BlocProvider.of<ExerciseFormBloc>(context);*/
    ExerciseFormBloc(
        workoutTitle: widget.workoutTitle,
        firestoreHangboardWorkoutsRepository:
        widget.firestoreHangboardWorkoutsRepository);
  }

  bool get isPopulated =>
      depthController.text.isNotEmpty &&
          timeOnController.text.isNotEmpty &&
          timeOffController.text.isNotEmpty &&
          hangsPerSetController.text.isNotEmpty &&
          timeBetweenSetsController.text.isNotEmpty &&
          numberOfSetsController.text.isNotEmpty &&
          resistanceController.text.isNotEmpty;

//  _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty

  bool isSaveButtonEnabled(ExerciseFormState exerciseFormState) {
    return exerciseFormState.isFormValid &&
        isPopulated /*&& !exerciseFormState.isSubmitting*/;
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
      body: BlocBuilder(
        bloc: _exerciseFormBloc,
        builder: (context, exerciseFormState) {
          return Builder(
            builder: (scaffoldContext) =>
                Form(
                  key: formKey,
                  /*https://medium.com/saugo360/https-medium-com-saugo360-flutter-using-overlay-to-display-floating-widgets-2e6d0e8decb9
              TODO: See if I can get the keyboard to jump to the text form field in focus (nice to have)
              https://stackoverflow.com/questions/46841637/show-a-text-field-dialog-without-being-covered-by-keyboard/46849239#46849239
              TODO: ^ this was the original solution to the keyboard covering text fields, might want to refer to it in the future
               */
                  child: ListView(
                    children: <Widget>[
                      UnitPickerTile(
                        parentState: exerciseFormState,
                        parentBloc: _exerciseFormBloc,
                      ),
                      numberOfHandsTile(exerciseFormState),
                      holdDropdownTile(exerciseFormState),
                      fingerConfigurationDropdownTile(exerciseFormState),
                      depthTile(exerciseFormState),
                      hangDurationTile(exerciseFormState),
                      // hangProtocolTile(),
                      hangsPerSetTile(exerciseFormState),
                      timeBetweenSetsTile(exerciseFormState),
                      numberOfSetsTile(exerciseFormState),
                      resistanceTile(exerciseFormState),
                      saveButton(exerciseFormState, scaffoldContext)
                    ].where(notNull).toList(),
                  ),
                ),
          );
        },
      ),
    );
  }

  /// Nice way to conditionally add widgets to a list that I found.
  /// Makes use of [where] and this function to make an [Iterable] which is then
  /// turned back into a list without the null entries.
  bool notNull(Object o) => o != null;

  Widget numberOfHandsTile(ExerciseFormState exerciseFormState) {
    return new Card(
      child: ListTile(
        key: PageStorageKey('numberOfHandsTile'),
        title: Row(
          children: <Widget>[
            Flexible(
              child: RadioListTile(
                title: Text('One hand'),
                value: 1,
                groupValue: exerciseFormState.numberOfHandsSelected,
                onChanged: (value) {
                  _exerciseFormBloc.dispatch(
                      NumberOfHandsChanged(numberOfHandsSelected: value));
                },
              ),
            ),
            Flexible(
              child: RadioListTile(
                  title: Text('Two hands'),
                  value: 2,
                  groupValue: exerciseFormState.numberOfHandsSelected,
                  onChanged: (value) {
                    _exerciseFormBloc.dispatch(
                        NumberOfHandsChanged(numberOfHandsSelected: value));
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Widget holdDropdownTile(ExerciseFormState exerciseFormState) {
    return new Card(
      child: new ListTile(
        leading: Icon(
          Icons.pan_tool,
        ),
        title: DropdownButtonHideUnderline(
          child: new DropdownButton<Holds>(
            elevation: 10,
            hint: Text(
              'Choose a hold',
            ),
            value: exerciseFormState.hold,
            onChanged: (value) {
              _exerciseFormBloc.dispatch(HoldChanged(hold: value));
            },
            items: Holds.values.map((Holds hold) {
              return new DropdownMenuItem<Holds>(
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

  Widget fingerConfigurationDropdownTile(ExerciseFormState exerciseFormState) {
    if(exerciseFormState.hold == Holds.POCKET ||
        exerciseFormState.hold == Holds.OPEN_HAND) {
      return new Card(
        child: new ListTile(
          leading: Icon(
            //TODO: find better icons on fontAwesome?
            Icons.pan_tool,
          ),
          title: DropdownButtonHideUnderline(
            child: new DropdownButton<FingerConfigurations>(
              elevation: 10,
              hint: Text(
                'Choose a finger configuration',
              ),
              value: exerciseFormState.fingerConfiguration,
              onChanged: (value) {
                _exerciseFormBloc.dispatch(
                    FingerConfigurationChanged(fingerConfiguration: value));
              },
              items: exerciseFormState.availableFingerConfigurations
                  .map((fingerConfiguration) {
                return DropdownMenuItem(
                  child: new Text(
                    StringFormatUtils.formatFingerConfiguration(
                        fingerConfiguration),
                  ),
                  value: fingerConfiguration,
                );
              }).toList(),
            ),
          ),
        ),
      );
    } else {
      return null;
    }
  }

  Widget depthTile(ExerciseFormState exerciseFormState) {
    if(!exerciseFormState.isDepthVisible) {
      return null;
    }
    return new Card(
      child: ListTile(
        title: Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 8.0),
          child: new TextFormField(
            controller: depthController,
            autovalidate: exerciseFormState.autoValidate,
            validator: (value) {
              return (null == exerciseFormState.depth ||
                  null == double.tryParse(value))
                  ? 'Invalid Depth'
                  : null;
            },
            onChanged: (value) {
              _exerciseFormBloc.dispatch(DepthChanged(depth: value));
            },
            decoration: InputDecoration(
              icon: Icon(Icons.keyboard_tab),
              labelText: 'Depth (${exerciseFormState.depthMeasurementSystem})',
            ),
            keyboardType:
            TextInputType.numberWithOptions(signed: true, decimal: true),
          ),
        ),
      ),
    );
  }

  Widget hangDurationTile(ExerciseFormState exerciseFormState) {
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
                  autovalidate: exerciseFormState.autoValidate,
                  validator: (value) {
                    return (null == int.tryParse(value) ||
                        null == exerciseFormState.timeOn)
                        ? 'Invalid Time On'
                        : null;
                  },
                  onChanged: (value) {
                    _exerciseFormBloc.dispatch(TimeOnChanged(timeOn: value));
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
                  autovalidate: exerciseFormState.autoValidate,
                  validator: (value) {
                    return (null == exerciseFormState.timeOff ||
                        null == int.tryParse(value))
                        ? 'Invalid Time Off'
                        : null;
                  },
                  onChanged: (value) {
                    _exerciseFormBloc.dispatch(TimeOffChanged(timeOff: value));
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

//  Widget hangProtocolTile(ExerciseFormState exerciseFormState) {
//    return Card(
//      child: new CheckboxListTile(
//        key: PageStorageKey('hangProtocolTile'),
//        value: _hangProtocolSelected,
//        onChanged: (value) {
//          setState(() {
//            _hangProtocolSelected = value;
//          });
//        },
//        title: Text('Include Hang Protocol?'),
//      ),
//    );
//  }

  Widget hangsPerSetTile(ExerciseFormState exerciseFormState) {
    return Card(
      child: ListTile(
        title: Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 8.0),
          child: new TextFormField(
            controller: hangsPerSetController,
            autovalidate: exerciseFormState.autoValidate,
            validator: (value) {
              return (null == exerciseFormState.hangsPerSet ||
                  null == int.tryParse(value))
                  ? 'Invalid Hangs Per Set'
                  : null;
            },
            onChanged: (value) {
              _exerciseFormBloc
                  .dispatch(HangsPerSetChanged(hangsPerSet: value));
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

  Widget timeBetweenSetsTile(ExerciseFormState exerciseFormState) {
    return Card(
      child: ListTile(
        title: Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 8.0),
          child: new TextFormField(
            controller: timeBetweenSetsController,
            autovalidate: exerciseFormState.autoValidate,
            validator: (value) {
              return (null == exerciseFormState.timeBetweenSets ||
                  null == int.tryParse(value))
                  ? 'Invalid Time Between Sets'
                  : null;
            },
            onChanged: (value) {
              _exerciseFormBloc
                  .dispatch(TimeBetweenSetsChanged(timeBetweenSets: value));
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

  Widget numberOfSetsTile(ExerciseFormState exerciseFormState) {
    return Card(
      child: ListTile(
        key: PageStorageKey<String>('numberOfSetsTile'),
        title: Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 8.0),
          child: new TextFormField(
            controller: numberOfSetsController,
            autovalidate: exerciseFormState.autoValidate,
            validator: (value) {
              return (null == exerciseFormState.numberOfSets ||
                  null == int.tryParse(value))
                  ? 'Invalid Number of Sets'
                  : null;
            },
            onChanged: (value) {
              _exerciseFormBloc
                  .dispatch(NumberOfSetsChanged(numberOfSets: value));
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

  Widget resistanceTile(ExerciseFormState exerciseFormState) {
    return Card(
      child: ListTile(
        key: PageStorageKey<String>('resistanceTile'),
        title: Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 8.0),
          child: new TextFormField(
            controller: resistanceController,
            autovalidate: exerciseFormState.autoValidate,
            validator: (value) {
              return (null == exerciseFormState.resistance ||
                  null == int.tryParse(value))
                  ? 'Invalid Resistance'
                  : null;
            },
            onChanged: (value) {
              _exerciseFormBloc.dispatch(ResistanceChanged(resistance: value));
            },
            decoration: InputDecoration(
              icon: Icon(Icons.fitness_center),
              labelText:
              'Resistance (${exerciseFormState.resistanceMeasurementSystem})',
            ),
            keyboardType: TextInputType.numberWithOptions(),
          ),
        ),
      ),
    );
  }

  Widget saveButton(ExerciseFormState exerciseFormState,
                    BuildContext scaffoldContext) {
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

  void saveTileFields(BuildContext scaffoldContext) {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      _exerciseFormBloc.dispatch(ValidExerciseFormSaved());
      //todo:left off here 10/23 working on save
    } else {
      _exerciseFormBloc.dispatch(InvalidExerciseFormSaved());
    }
  }

  /* /// This method currently packages the data to be sent to the Firestore.
  /// Not sure if I need this or want to make a separate object (probably should
  /// do that anyway) to send the data instead. I could also make the [exercises]
  /// field a member var of this tab, and then each [hangboardExercise] could add it's own
  /// state info like [_depth] and [_hold] to the global [exercises].
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
  }*/

  List<Widget> mapFingerConfigurations(Holds hold) {
    if(hold == Holds.POCKET) {
      return FingerConfigurations.values
          .sublist(0, 6)
          .map((FingerConfigurations fingerConfiguration) {
        return new DropdownMenuItem<FingerConfigurations>(
          child: new Text(
            StringFormatUtils.formatFingerConfiguration(fingerConfiguration),
          ),
          value: fingerConfiguration,
        );
      }).toList();
    } else if(hold == Holds.OPEN_HAND) {
      return FingerConfigurations.values
          .sublist(4)
          .map((FingerConfigurations fingerConfiguration) {
        return new DropdownMenuItem<FingerConfigurations>(
          child: new Text(
            StringFormatUtils.formatFingerConfiguration(fingerConfiguration),
          ),
          value: fingerConfiguration,
        );
      }).toList();
    } else {
      return FingerConfigurations.values
          .map((FingerConfigurations fingerConfiguration) {
        return new DropdownMenuItem<FingerConfigurations>(
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
//    String exercise = StringFormatUtils.formatDepthAndHold(
//        _depth,
//        _depthMeasurementSystem,
//        StringFormatUtils.formatFingerConfiguration(_fingerConfiguration),
//        StringFormatUtils.formatHold(_hold));

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
//                        text: '$exercise.\n\n',
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
//                        clearFields();
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

//  void clearFields() {
//    setState(() {
//      timeOffController.clear();
//      hangsPerSetController.clear();
//      timeBetweenSetsController.clear();
//      numberOfSetsController.clear();
//      resistanceController.clear();
//      timeOnController.clear();
//      _isTwoHandsSelected = true;
//      _holdSelected = false;
//      //TODO: don't think nulls work here
//      _fingerConfiguration = null;
//      _hold = null;
//      _depthMeasurementSystem = 'mm';
//      _resistanceMeasurementSystem = 'kg';
//      _hangProtocolSelected = false;
//      _autoValidate = false;
//    });
//  }

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
