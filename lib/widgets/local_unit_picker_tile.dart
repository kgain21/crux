import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// Select between English and Metric units for depth and weight with radio buttons.
/// This may need to be a more central user config - for now it is just used
/// on the [hangboard] workout creator screen.
class UnitPickerTile extends StatefulWidget {

  @override
  State createState() => _UnitPickerTileState();
}

class _UnitPickerTileState extends State<UnitPickerTile> {

  var _unitRow;
  String _depthMeasurementSystem;
  String _resistanceMeasurementSystem;


  @override
  void initState() {
    super.initState();
    setState(() {
      _depthMeasurementSystem = 'millimeters';
      _resistanceMeasurementSystem = 'kilograms';
      _unitRow = initializeUnitRow();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          new ExpansionTile(
            key: PageStorageKey<Row>(_unitRow),
            initiallyExpanded: true,
            title: new Text('Select your units'),
            children: <Widget>[
              _unitRow,
            ],
          ),
        ],
      ),
    );
  }

  Widget initializeUnitRow() {
    return new Row(
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
    );
  }
}