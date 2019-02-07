import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// Select between English and Metric units for depth and weight with radio buttons.
/// This may need to be a more central user config - for now it is just used
/// on the [hangboard] workout creator screen.
class UnitPickerTile extends StatefulWidget {

  final Function depthCallback;
  final Function resistanceCallback;

  UnitPickerTile({this.depthCallback, this.resistanceCallback});

  @override
  State createState() => _UnitPickerTileState();
}

class _UnitPickerTileState extends State<UnitPickerTile> {
  String _depthMeasurementSystem;
  String _resistanceMeasurementSystem;

  @override
  void initState() {
    super.initState();
    _depthMeasurementSystem = 'millimeters';
    _resistanceMeasurementSystem = 'kilograms';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          new ExpansionTile(
            initiallyExpanded: true,
            title: new Text('Select your units'),
            children: <Widget>[
              unitRow(),
            ],
          ),
        ],
      ),
    );
  }

  Widget unitRow() {
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
                  widget.depthCallback(value);
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
                  widget.depthCallback(value);
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
                  widget.resistanceCallback(value);
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
                  widget.resistanceCallback(value);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
