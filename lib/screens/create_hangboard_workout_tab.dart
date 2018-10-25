import 'package:crux/model/grip_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CreateHangboardWorkoutTab extends StatefulWidget {
  @override
  State createState() => new _CreateHangboardWorkoutTabState();
}

class _CreateHangboardWorkoutTabState extends State<CreateHangboardWorkoutTab>
    with AutomaticKeepAliveClientMixin {
  Grip _grip;
  int _repTime;
  int _restTime;
  int _resistance;
  int _depth;
  int _reps;
  int _sets;
  String _depthMeasurementSystem;
  bool _depthSelected;
  bool _repsSelected;
  bool _resistanceSelected;
  bool _repTimeSelected;
  bool _restTimeSelected;
  String _resistanceMeasurementSystem;

  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

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
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return WillPopScope(
      onWillPop: () async {
        new SnackBar(
            content:
                new Text('Save your shit')); //todo: make sure user saves input
        return true;
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: new Column(
          children: <Widget>[
            Flexible(
              child: Form(
                key: _formKey,
                child: ListView(
                  children: <Widget>[
                    new Card(
                      child: new Column(
                        children: [
                          new ExpansionTile(
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
                                          groupValue:
                                              _resistanceMeasurementSystem,
                                          value: 'kilograms',
                                          onChanged: (value) {
                                            setState(() {
                                              _resistanceMeasurementSystem =
                                                  value;
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
                                          groupValue:
                                              _resistanceMeasurementSystem,
                                          value: 'pounds',
                                          onChanged: (value) {
                                            setState(() {
                                              _resistanceMeasurementSystem =
                                                  value;
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
                    ),
                    new Card(
                      child: new ListTile(
                        leading: Icon(Icons.pan_tool),
                        title: new DropdownButton<Grip>(
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
                        trailing: Text('filler'),
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
                            onSaved: (value) {
                              _depth = int.parse(value);
                            },
                            decoration: InputDecoration(
                              icon: Icon(Icons.keyboard_tab),
                              hintText: 'Depth',
                              helperText:
                                  'Enter a depth in $_depthMeasurementSystem.',
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
                            onSaved: (value) {
                              _resistance = int.parse(value);
                              //TODO: Need negative resistance too
                            },
                            decoration: InputDecoration(
                              icon: Icon(Icons.fitness_center),
                              hintText: 'Resistance',
                              helperText:
                                  'Add or subtract resistance in $_resistanceMeasurementSystem.',
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
                            onSaved: (value) {
                              _repTime = int.parse(value);
                            },
                            decoration: InputDecoration(
                              icon: Icon(Icons.timer),
                              hintText: 'Rep Duration',
                              helperText:
                                  'Enter the amount of time for each rep.',
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
                            onSaved: (value) {
                              _restTime = int.parse(value);
                            },
                            decoration: InputDecoration(
                              icon: Icon(Icons.watch_later),
                              hintText: 'Rest Time',
                              helperText:
                                  'Enter the amount of time to rest after each rep.',
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
                            onSaved: (value) {
                              _reps = int.parse(value);
                            },
                            decoration: InputDecoration(
                              hintText: 'Reps',
                              icon: Icon(Icons.format_list_bulleted),
                              helperText:
                                  'Enter the number of reps to do in a set.',
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
                          _formKey.currentState
                              .save(); //todo: make validation with selected fields
                        },
                        child: new Text('Save Set'),
                        //TODO: make add another set button appear when this is saved, this doesn't appear until all fields entered
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: new RaisedButton(
                        onPressed: null,
                        child: new Text('Add another set'),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String formatGrip(Grip grip) {
    var gripArray = grip.toString().substring(5).split('_');
    if (gripArray.length > 1)
      return '${gripArray[0].toLowerCase()} ${gripArray[1].toLowerCase()}';
    else
      return gripArray[0].toLowerCase();
  }

  // TODO: implement wantKeepAlive
  @override
  bool get wantKeepAlive => true;
}
