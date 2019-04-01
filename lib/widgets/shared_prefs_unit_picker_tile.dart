import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Select between English and Metric units for depth and weight with radio buttons.
/// This may need to be a more central user config - for now it is just used
/// on the [hangboard] workout creator screen.
class UnitPickerTile extends StatefulWidget {
  final String title;

  UnitPickerTile({this.title});

  @override
  State createState() => _UnitPickerTileState();
}

class _UnitPickerTileState extends State<UnitPickerTile> {
  Future<SharedPreferences> _sharedPreferences =
      SharedPreferences.getInstance();
  Future<String> _depthMeasurementSystem;
  Future<String> _resistanceMeasurementSystem;

  Future<Null> setDepthMeasurementSystem(String value) async {
    final SharedPreferences preferences = await _sharedPreferences;
    setState(() {
      _depthMeasurementSystem = preferences
          .setString("depthMeasurementSystem", value)
          .then((bool success) {
        return value;
      });
    });
  }

  Future<Null> setResistanceMeasurementSystem(String value) async {
    final SharedPreferences preferences = await _sharedPreferences;
    setState(() {
      _resistanceMeasurementSystem = preferences
          .setString("resistanceMeasurementSystem", value)
          .then((bool success) {
        return value;
      });
    });
  }

  @override
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
  }

  @override
  Widget build(BuildContext context) {
    return expandingUnitsTile();
  }

  /// The [ExpansionTile] that contains the different radio buttons for setting
  /// units. Units are stored in [SharedPreferences] for global access.
  /// *I may want to move this tile to a more central config page in the future.
  Widget expandingUnitsTile() {
    return Card(
      child: Column(
        children: <Widget>[
          new ExpansionTile(
            key: PageStorageKey<String>(widget.title),
            initiallyExpanded: true,
            title: new Text(widget.title),
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
                        futureRadioTile('Metric (mm)', 'millimeters',
                            setDepthMeasurementSystem, _depthMeasurementSystem),
                        futureRadioTile('English (in)', 'inches',
                            setDepthMeasurementSystem, _depthMeasurementSystem),
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
                        futureRadioTile(
                            'Metric (kg)',
                            'kilograms',
                            setResistanceMeasurementSystem,
                            _resistanceMeasurementSystem),
                        futureRadioTile(
                            'English (lb)',
                            'pounds',
                            setResistanceMeasurementSystem,
                            _resistanceMeasurementSystem),
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

  /// Builds the units radio tile from [SharedPreferences]
  Widget futureRadioTile(String title, String buttonValue,
      Function onChangedFunction, Future<String> future) {
    return new FutureBuilder<String>(
      future: future,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          //Putting a spinner here caused an ugly and unnecessary repaint every time
          case ConnectionState.none:
          case ConnectionState.waiting:
          default:
            return new RadioListTile(
              title: Text(
                title,
                style: TextStyle(
                  fontSize: 14.0,
                ),
              ),
              groupValue: snapshot.data,
              value: buttonValue,
              onChanged: (value) {
                onChangedFunction(value);
              },
            );
        }
      },
    );
  }
}
