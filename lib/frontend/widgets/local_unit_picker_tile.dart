import 'package:crux/backend/blocs/hangboard/exerciseform/exercise_form_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// Select between English and Metric units for depth and weight with radio buttons.
/// This may need to be a more central user config - for now it is just used
/// on the [hangboard] workout creator screen.
class UnitPickerTile extends StatefulWidget {
  final parentState;
  final parentBloc;

  UnitPickerTile({this.parentBloc, this.parentState});

  @override
  State createState() => _UnitPickerTileState();
}

class _UnitPickerTileState extends State<UnitPickerTile> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          new ExpansionTile(
            key: PageStorageKey('unitPickerTile'),
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
    return Row(
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
                  'Millimeters (mm)',
                  style: TextStyle(
                    fontSize: 14.0,
                  ),
                ),
                groupValue: widget.parentState.depthMeasurementSystem,
                value: 'mm',
                onChanged: (value) {
                  widget.parentBloc.dispatch(DepthMeasurementSystemChanged(
                      depthMeasurementSystem: value));
                },
              ),
              new RadioListTile(
                title: Text(
                  'Inches (in)',
                  style: TextStyle(
                    fontSize: 14.0,
                  ),
                ),
                groupValue: widget.parentState.depthMeasurementSystem,
                value: 'in',
                onChanged: (value) {
                  widget.parentBloc.dispatch(DepthMeasurementSystemChanged(
                      depthMeasurementSystem: value));
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
                  'Kilograms (kg)',
                  style: TextStyle(
                    fontSize: 14.0,
                  ),
                ),
                groupValue: widget.parentState.resistanceMeasurementSystem,
                value: 'kg',
                onChanged: (value) {
                  widget.parentBloc.dispatch(ResistanceMeasurementSystemChanged(
                      resistanceMeasurementSystem: value));
                },
              ),
              new RadioListTile(
                title: Text(
                  'Pounds (lb)',
                  style: TextStyle(
                    fontSize: 14.0,
                  ),
                ),
                groupValue: widget.parentState.resistanceMeasurementSystem,
                value: 'lb',
                onChanged: (value) {
                  widget.parentBloc.dispatch(ResistanceMeasurementSystemChanged(
                      resistanceMeasurementSystem: value));
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
