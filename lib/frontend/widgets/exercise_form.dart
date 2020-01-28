import 'dart:async';

import 'package:crux/backend/bloc/hangboard/exerciseform/exercise_form_bloc.dart';
import 'package:crux/backend/bloc/hangboard/exerciseform/exercise_form_event.dart';
import 'package:crux/backend/bloc/hangboard/exerciseform/exercise_form_state.dart';
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
  final GlobalKey<FormState> formKey = GlobalKey(debugLabel: 'ExerciseForm');

  final TextEditingController _depthController = TextEditingController();
  final TextEditingController _timeOnController = TextEditingController();
  final TextEditingController _timeOffController = TextEditingController();
  final TextEditingController _hangsPerSetController = TextEditingController();
  final TextEditingController _timeBetweenSetsController =
      TextEditingController();
  final TextEditingController _numberOfSetsController = TextEditingController();
  final TextEditingController _resistanceController = TextEditingController();

  int _numberOfHandsSelected;
  String _depthMeasurementSystem;
  String _resistanceMeasurementSystem;
  Hold _hold;
  FingerConfiguration _fingerConfiguration;

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
      body: BlocListener(
        bloc: _exerciseFormBloc,
        listener: (BuildContext context, ExerciseFormState exerciseFormState) {
          if (exerciseFormState.isSuccess) {
            exerciseSavedSnackbar(context);
            _exerciseFormBloc.add(ExerciseFormFlagsReset());
//            BlocProvider.of<HangboardParentBloc>(context).add(HangboardParentUpdated());
          } else if (exerciseFormState.isDuplicate) {
            _exerciseExistsAlert(exerciseFormState);
            _exerciseFormBloc.add(ExerciseFormFlagsReset());
          }
          if (exerciseFormState is ExerciseFormSaveInvalid) {
//            exerciseNotSavedSnackbar(context);
          }
        },
        child: BlocBuilder(
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
                          exerciseFormState: exerciseFormState,
                          exerciseFormBloc: _exerciseFormBloc,
                        ),
                        _numberOfHandsTile(exerciseFormState, scaffoldContext),
                        _holdDropdownTile(exerciseFormState, scaffoldContext),
                        _fingerConfigurationDropdownTile(
                            exerciseFormState, scaffoldContext),
                        _depthTile(exerciseFormState, scaffoldContext),
                        _timeOnTile(exerciseFormState, scaffoldContext),
                        // hangProtocolTile(),
                        _hangsPerSetTile(exerciseFormState, scaffoldContext),
                        _timeBetweenSetsTile(
                            exerciseFormState, scaffoldContext),
                        _numberOfSetsTile(exerciseFormState, scaffoldContext),
                        _resistanceTile(exerciseFormState, scaffoldContext),
                        _saveButton(exerciseFormState, scaffoldContext)
                      ].where(notNull).toList(),
                    ),
                  ),
            );
          },
        ),
      ),
    );
  }

  /// Nice way to conditionally add widgets to a list that I found.
  /// Makes use of [where] and this function to make an [Iterable] which is then
  /// turned back into a list without the null entries.
  bool notNull(Object o) => o != null;

  Widget _numberOfHandsTile(ExerciseFormState exerciseFormState,
      BuildContext scaffoldContext) {
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
                  Scaffold.of(scaffoldContext).hideCurrentSnackBar();
                  _exerciseFormBloc.add(
                      ExerciseFormNumberOfHandsChanged(value));
                },
              ),
            ),
            Flexible(
              child: RadioListTile(
                title: Text('Two hands'),
                value: 2,
                groupValue: exerciseFormState.numberOfHandsSelected,
                onChanged: (value) {
                  Scaffold.of(scaffoldContext).hideCurrentSnackBar();
                  _exerciseFormBloc.add(
                      ExerciseFormNumberOfHandsChanged(value));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _holdDropdownTile(ExerciseFormState exerciseFormState,
      BuildContext scaffoldContext) {
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
            value: exerciseFormState.hold,
            onChanged: (value) {
              Scaffold.of(scaffoldContext).hideCurrentSnackBar();
              _exerciseFormBloc.add(ExerciseFormHoldChanged(value));
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

  Widget _fingerConfigurationDropdownTile(ExerciseFormState exerciseFormState,
      BuildContext scaffoldContext) {
    if(exerciseFormState.isFingerConfigurationVisible) {
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
              value: exerciseFormState.fingerConfiguration,
              onChanged: (value) {
                Scaffold.of(scaffoldContext).hideCurrentSnackBar();
                _exerciseFormBloc.add(
                    ExerciseFormFingerConfigurationChanged(value));
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

  Widget _depthTile(ExerciseFormState exerciseFormState,
      BuildContext scaffoldContext) {
    if(!exerciseFormState.isDepthVisible) {
      return null;
    }
    return new Card(
      child: ListTile(
        title: Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 8.0),
          child: new TextFormField(
            controller: _depthController,
            autovalidate: exerciseFormState.autoValidate,
            validator: (_) {
              return exerciseFormState.isDepthValid ? null : 'Invalid Depth';
            },
            onChanged: (value) {
              _exerciseFormBloc.add(ExerciseFormDepthChanged(value));
            },
            decoration: InputDecoration(
              icon: Icon(Icons.keyboard_tab),
              labelText: 'Depth (${exerciseFormState.depthMeasurementSystem})',
            ),
            keyboardType:
            TextInputType.numberWithOptions(signed: true, decimal: true),
            onTap: () {
              Scaffold.of(scaffoldContext).hideCurrentSnackBar();
            },
          ),
        ),
      ),
    );
  }

  Widget _timeOnTile(ExerciseFormState exerciseFormState,
      BuildContext scaffoldContext) {
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
                  controller: _timeOnController,
                  autovalidate: exerciseFormState.autoValidate,
                  validator: (_) {
                    return exerciseFormState.isTimeOnValid
                        ? null
                        : 'Invalid Time On';
                  },
                  onChanged: (value) {
                    _exerciseFormBloc.add(ExerciseFormTimeOnChanged(value));
                  },
                  decoration: InputDecoration(
                    labelText: 'Time On (sec)',
                  ),
                  keyboardType: TextInputType.numberWithOptions(),
                  onTap: () {
                    Scaffold.of(scaffoldContext).hideCurrentSnackBar();
                  },
                ),
              ),
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 8.0, top: 0.0, right: 8.0, bottom: 8.0),
                child: TextFormField(
                  controller: _timeOffController,
                  autovalidate: exerciseFormState.autoValidate,
                  validator: (_) {
                    return exerciseFormState.isTimeOffValid
                        ? null
                        : 'Invalid Time Off';
                  },
                  onChanged: (value) {
                    _exerciseFormBloc.add(ExerciseFormTimeOffChanged(value));
                  },
                  decoration: InputDecoration(
                    labelText: 'Time Off (sec)',
                  ),
                  keyboardType: TextInputType.numberWithOptions(),
                  onTap: () {
                    Scaffold.of(scaffoldContext).hideCurrentSnackBar();
                  },
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

  Widget _hangsPerSetTile(ExerciseFormState exerciseFormState,
      BuildContext scaffoldContext) {
    return Card(
      child: ListTile(
        title: Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 8.0),
          child: new TextFormField(
            controller: _hangsPerSetController,
            autovalidate: exerciseFormState.autoValidate,
            validator: (_) {
              return exerciseFormState.isHangsPerSetValid
                  ? null
                  : 'Invalid Hangs Per Set';
            },
            onChanged: (value) {
              _exerciseFormBloc
                  .add(ExerciseFormHangsPerSetChanged(value));
            },
            decoration: InputDecoration(
              labelText: 'Hangs per set',
              icon: Icon(Icons.format_list_bulleted),
            ),
            keyboardType: TextInputType.numberWithOptions(),
            onTap: () {
              Scaffold.of(scaffoldContext).hideCurrentSnackBar();
            },
          ),
        ),
      ),
    );
  }

  Widget _timeBetweenSetsTile(ExerciseFormState exerciseFormState,
      BuildContext scaffoldContext) {
    return Card(
      child: ListTile(
        title: Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 8.0),
          child: new TextFormField(
            controller: _timeBetweenSetsController,
            autovalidate: exerciseFormState.autoValidate,
            validator: (_) {
              return exerciseFormState.isTimeBetweenSetsValid
                  ? null
                  : 'Invalid Time Between Sets';
            },
            onChanged: (value) {
              _exerciseFormBloc
                  .add(ExerciseFormTimeBetweenSetsChanged(value));
            },
            decoration: InputDecoration(
              icon: Icon(Icons.watch_later),
              labelText: 'Time between sets (sec)',
            ),
            keyboardType: TextInputType.numberWithOptions(),
            onTap: () {
              Scaffold.of(scaffoldContext).hideCurrentSnackBar();
            },
          ),
        ),
      ),
    );
  }

  Widget _numberOfSetsTile(ExerciseFormState exerciseFormState,
      BuildContext scaffoldContext) {
    return Card(
      child: ListTile(
        key: PageStorageKey<String>('numberOfSetsTile'),
        title: Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 8.0),
          child: new TextFormField(
            controller: _numberOfSetsController,
            autovalidate: exerciseFormState.autoValidate,
            validator: (_) {
              return exerciseFormState.isNumberOfSetsValid
                  ? null
                  : 'Invalid Number of Sets';
            },
            onChanged: (value) {
              _exerciseFormBloc
                  .add(ExerciseFormNumberOfSetsChanged(value));
            },
            decoration: InputDecoration(
              labelText: 'Number of sets',
              icon: Icon(Icons.format_list_bulleted),
            ),
            keyboardType: TextInputType.numberWithOptions(),
            onTap: () {
              Scaffold.of(scaffoldContext).hideCurrentSnackBar();
            },
          ),
        ),
      ),
    );
  }

  Widget _resistanceTile(ExerciseFormState exerciseFormState,
      BuildContext scaffoldContext) {
    return Card(
      child: ListTile(
        key: PageStorageKey<String>('resistanceTile'),
        title: Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 8.0),
          child: new TextFormField(
            controller: _resistanceController,
            autovalidate: exerciseFormState.autoValidate,
            validator: (_) {
              return exerciseFormState.isResistanceValid
                  ? null
                  : 'Invalid Resistance';
            },
            onChanged: (value) {
              _exerciseFormBloc.add(ExerciseFormResistanceChanged(value));
            },
            decoration: InputDecoration(
              icon: Icon(Icons.fitness_center),
              labelText:
              'Resistance (${exerciseFormState.resistanceMeasurementSystem})',
            ),
            keyboardType: TextInputType.numberWithOptions(),
            onTap: () {
              Scaffold.of(scaffoldContext).hideCurrentSnackBar();
            },
          ),
        ),
      ),
    );
  }

  Widget _saveButton(ExerciseFormState exerciseFormState,
      BuildContext scaffoldContext) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: RaisedButton(
        onPressed: () {
          _saveTileFields(scaffoldContext, exerciseFormState);
        },
        child: Text('Save Exercise'),
      ),
    );
  }

  /// Saving the form exercises the front end validations on each field. These
  /// validations are done against the form fields and will provide UI messages
  /// describing invalid fields.
  ///
  /// If validation passes, the state is sent to the BLoC to be saved to the DB.
  void _saveTileFields(BuildContext scaffoldContext,
      ExerciseFormState exerciseFormState) {
    if(formKey.currentState.validate()) {
      formKey.currentState.save();
      _exerciseFormBloc.add(ValidExerciseFormSaved(
        exerciseFormState.resistanceMeasurementSystem,
        exerciseFormState.depthMeasurementSystem,
        exerciseFormState.numberOfHandsSelected,
        exerciseFormState.hold,
        exerciseFormState.fingerConfiguration,
        _depthController.text,
        _timeOffController.text,
        _timeOnController.text,
        _timeBetweenSetsController.text,
        _hangsPerSetController.text,
        _numberOfSetsController.text,
        _resistanceController.text,
      ));
    } else {
      _exerciseFormBloc.add(ExerciseFormSaveInvalid());
    }
  }

  List<Widget> mapFingerConfigurations(Hold hold) {
    if(hold == Hold.POCKET) {
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
    } else if(hold == Hold.OPEN_HAND) {
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

  Future<void> _exerciseExistsAlert(ExerciseFormState exerciseFormState) async {
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
                        text: '${exerciseFormState.exerciseTitle}.\n\n',
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
//                    exerciseRef.setData(data);
//                    exerciseSavedSnackbar(scaffoldContext);
                    Navigator.of(context).pop();
                  },
                ),
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
    //todo: add this for resetting form
//    _exerciseFormBloc.add(ExerciseFormCleared());
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
