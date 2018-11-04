import 'package:crux/model/grip_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ExerciseFormTile extends StatefulWidget {

  final GlobalKey<FormState> formKey;
  final String workoutTitle;

  //TODO: how do I want to handle units here????
  ExerciseFormTile({this.formKey, this.workoutTitle});

  @override
  State createState() => new _ExerciseFormTileState();
}

class _ExerciseFormTileState extends State<ExerciseFormTile> {
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

  @override
  void initState() {
    super.initState();
    setState(() {
      _depthMeasurementSystem = 'millimeters';
      _resistanceMeasurementSystem = 'kilograms';
      _depthSelected = true;
      _repsSelected = true;
      _resistanceSelected = true;
      _repTimeSelected = true;
      _restTimeSelected = true;
      _autoValidate = false;
      _exerciseIndex = 1;
      _exerciseTitle = 'Exercise $_exerciseIndex';
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Card(
      //color: Colors.grey,
      child: ExpansionTile(
        title: new Text('test'),
        children: <Widget>[
          ListView(
            controller: new ScrollController(),
            shrinkWrap: true,
            children: <Widget>[
              new Card(
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
              ),
              new Card(
                child: SwitchListTile(
                  selected: _depthSelected,
                  onChanged: (value) {
                    setState(() {
                      _depthSelected = value;
                    });
                  },
                  value: _depthSelected,
                  title: Padding(
                    padding:
                    const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 8.0),
                    child: new TextFormField(
                      autovalidate: _autoValidate,
                      validator: (value) {
                        return hangboardFieldValidator(
                            _depthSelected, value);
                      },
                      onSaved: (value) {
                        _depth = int.tryParse(value);
                      },
                      decoration: InputDecoration(
                        icon: Icon(Icons.keyboard_tab),
                        labelText: 'Depth ($_depthMeasurementSystem)',
                        hintText: 'Enter the depth of the hold.',
                        //helperText: 'Unit: $_depthMeasurementSystem.',
                      ),
                      keyboardType: TextInputType.numberWithOptions(),
                    ),
                  ),
                ),
              ),
              new Card(
                child: SwitchListTile(
                  selected: _resistanceSelected,
                  onChanged: (value) {
                    setState(() {
                      _resistanceSelected = value;
                    });
                  },
                  value: _resistanceSelected,
                  title: Padding(
                    padding:
                    const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 8.0),
                    child: new TextFormField(
                      autovalidate: _autoValidate,
                      validator: (value) {
                        return hangboardFieldValidator(
                            _resistanceSelected, value);
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
              ),
              new Card(
                child: SwitchListTile(
                  onChanged: (value) {
                    setState(() {
                      _repTimeSelected = value;
                    });
                  },
                  value: _repTimeSelected,
                  title: Padding(
                    padding:
                    const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 8.0),
                    child: new TextFormField(
                      autovalidate: _autoValidate,
                      validator: (value) {
                        return hangboardFieldValidator(
                            _repTimeSelected, value);
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
              ),
              new Card(
                child: SwitchListTile(
                  onChanged: (value) {
                    setState(() {
                      _restTimeSelected = value;
                    });
                  },
                  value: _restTimeSelected,
                  title: Padding(
                    padding:
                    const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 8.0),
                    child: new TextFormField(
                      autovalidate: _autoValidate,
                      validator: (value) {
                        return hangboardFieldValidator(
                            _restTimeSelected, value);
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
              ),
              new Card(
                child: SwitchListTile(
                  selected: _repsSelected,
                  onChanged: (value) {
                    setState(() {
                      _repsSelected = value;
                    });
                  },
                  value: _repsSelected,
                  title: Padding(
                    padding:
                    const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 8.0),
                    child: new TextFormField(
                      autovalidate: _autoValidate,
                      validator: (value) {
                        return hangboardFieldValidator(
                            _repsSelected, value);
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
              ),
              /*icon: Icon(Icons.trending_up),
                            icon: Icon(Icons.import_export),*/
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: new RaisedButton(
                  onPressed: () {
                    saveTileFields();
                  },
                  child: new Text('Save Set'),
                  //TODO: make add another set button appear when this is saved, this doesn't appear until all fields entered
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  //TODO: make unselected boxes grayed out (cant type in them)
  String hangboardFieldValidator(bool selected, String fieldValue) {
    var intValue = int.tryParse(fieldValue);
    if(selected) {
      if(intValue == null) {
        return 'Please enter a number.';
      }
      if(intValue.isNaN) return 'Please enter a real number.';
      if(intValue.isNegative) return 'Please enter a positive number.';
      return null;
    }
    return null;
  }

  String formatGrip(Grip grip) {
    var gripArray = grip.toString().substring(5).split('_');
    if(gripArray.length > 1)
      return '${gripArray[0].substring(0, 1).toUpperCase()}${gripArray[0]
          .substring(1)
          .toLowerCase()} ${gripArray[1].toLowerCase()}';
    else
      return '${gripArray[0].substring(0, 1).toUpperCase()}${gripArray[0]
          .substring(1)
          .toLowerCase()}';
  }

  /*void saveHangboardWorkoutToFirebase() {
    DocumentReference reference =
    Firestore.instance.document('hangboard/$_workoutTitle');
    CollectionReference collectionReference =
    Firestore.instance.collection('hangboard/$_workoutTitle');

    var data = createHangboardData();

    reference.setData(data);

    //onTap: () => record.reference.updateData({'votes': record.votes + 1})
  }*/

  //TODO: put general message about form errors below save button
  void saveTileFields() {
    if(widget.formKey.currentState.validate()) {
      widget.formKey.currentState.save();
      //saveHangboardWorkoutToFirebase(); //TODO: make dao here?
      print('saved');
    } else {
      setState(() => _autoValidate = true);
    }
  }

}