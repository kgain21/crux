import 'package:crux/widgets/timer_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HangboardListTile extends StatefulWidget {
  final int index;
  final Map<String, dynamic> exerciseParameters;

  HangboardListTile({this.index, this.exerciseParameters});

  @override
  State<HangboardListTile> createState() => _HangboardListTileState();
}

class _HangboardListTileState extends State<HangboardListTile> with AutomaticKeepAliveClientMixin {

  //todo: wrap these in data class?
  String _depth;//TODO: int
  String _resistance;//TODO: int
  String _depthMeasurementSystem;
  String _resistanceMeasurementSystem;
  String _grip;
  String _hangs;//TODO: int
  int _repTime;
  int _restTime;
  bool _didFinishSet;

  @override
  void initState() {
    super.initState();
    setState(() {
      _didFinishSet = false;
      getParams(widget.exerciseParameters);
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ExpansionTile(
      key: PageStorageKey('${widget.index}'),
      title: Text(
        formatDepthAndGrip(_depth, _depthMeasurementSystem, _grip),
        style: TextStyle(
          fontSize: 20.0,
        ),
      ),
      initiallyExpanded: false,
      children: <Widget>[
        Column(
          children: <Widget>[
            new CheckboxListTile(
              value: _didFinishSet,
              onChanged: (value) {
                setState(() {
                  _didFinishSet = value;
                });
              },
              title: Text(
                formatHangsAndResistance(_hangs, _resistance, _resistanceMeasurementSystem),
                style: TextStyle(fontSize: 18.0),
              ),
            ),
            new Padding(
              padding: const EdgeInsets.all(12.0),
              child: ConstrainedBox(
                key: PageStorageKey('Timer${widget.index}'),
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width / 2.0),
                child: TimerTextAnimator(
                  repTime: _repTime,
                  restTime: _restTime,
                  hangs: int.parse(_hangs),//TODO: int
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  String formatDepthAndGrip(String depth, String depthMeasurementSystem, String grip) {
    if(depth == null || depth.isEmpty) {
      return grip;
    } else {
      return '$depth$depthMeasurementSystem $grip';
    }
  }

  formatHangsAndResistance(String hangs, String resistance, String resistanceMeasurementSystem) {
    if(hangs == null || hangs.isEmpty || int.parse(hangs) <= 1) {
      if(resistance == null || resistance.isEmpty) {
        return '$hangs hang at bodyweight';
      } else {
        return '$hangs hang with $resistance$resistanceMeasurementSystem';
      }
    } else {
      if(resistance == null || resistance.isEmpty) {
        return '$hangs hangs at bodyweight';
      } else {
        return '$hangs hangs with $resistance$resistanceMeasurementSystem';
      }
    }
  }

  //TODO: should this be separated from the widget in a dao?
  //TODO: call the getParams method on expand? might be slow
  void getParams(Map<String, dynamic> exerciseParameters) {
    getDepth(exerciseParameters);
    getDepthMeasurementSystem(exerciseParameters);
    getResistance(exerciseParameters);
    getResistanceMeasurementSystem(exerciseParameters);
    getGrip(exerciseParameters);
    getRepTime(exerciseParameters);
    getRestTime(exerciseParameters);
    getHangs(exerciseParameters);
  }

  void getDepth(Map<String, dynamic> exerciseParameters) {
    try {
      var depth = exerciseParameters['depth'];
      if (depth is int) {
        _depth = depth.toString();
      }
    } on Exception catch (e) {
      print('Unable to find depth: $e');
    }
  }

  void getDepthMeasurementSystem(Map<String, dynamic> exerciseParameters) {
    try {
      var depthMeasurementSystem = exerciseParameters['depthMeasurementSystem'];
      if (depthMeasurementSystem is String) {
        _depthMeasurementSystem = depthMeasurementSystem;
      }
    } on Exception catch (e) {
      print('Unable to find depthMeasurementSystem: $e');
    }
  }

  void getResistance(Map<String, dynamic> exerciseParameters) {
    try {
      var resistance = exerciseParameters['resistance'];
      if (resistance is int) {
        _resistance = resistance.toString();
      }
    } on Exception catch (e) {
      print('Unable to find resistance: $e');
    }
  }

  void getResistanceMeasurementSystem(Map<String, dynamic> exerciseParameters) {
    try {
      var resistanceMeasurementSystem =
          exerciseParameters['resistanceMeasurementSystem'];
      if (resistanceMeasurementSystem is String) {
        _resistanceMeasurementSystem = resistanceMeasurementSystem;
      }
    } on Exception catch (e) {
      print('Unable to find resistanceMeasurementSystem: $e');
    }
  }

  //TODO: required
  void getGrip(Map<String, dynamic> exerciseParameters) {
    try {
      var grip = exerciseParameters['grip'];
      if (grip is String) {
        _grip = grip;
      }
    } on Exception catch (e) {
      print('Unable to find grip: $e');
    }
  }

  //TODO: required
  void getHangs(Map<String, dynamic> exerciseParameters) {
    try {
      var hangs = exerciseParameters['hangs'];
      if (hangs is int) {
        _hangs = hangs.toString();
      }
    } on Exception catch (e) {
      print('Unable to find repTime: $e');
    }
  }

  //TODO: required
  void getRepTime(Map<String, dynamic> exerciseParameters) {
    try {
      var repTime = exerciseParameters['repTime'];
      if (repTime is int) {
        _repTime = repTime;
      }
    } on Exception catch (e) {
      print('Unable to find repTime: $e');
    }
  }

  void getRestTime(Map<String, dynamic> exerciseParameters) {
    try {
      var restTime = exerciseParameters['restTime'];
      if (restTime is int) {
        _restTime = restTime;
      }
    } on Exception catch (e) {
      print('Unable to find restTime: $e');
    }
  }

  @override
  void updateKeepAlive() {
    // TODO: implement updateKeepAlive
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

}
