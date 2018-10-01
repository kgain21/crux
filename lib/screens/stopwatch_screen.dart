import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class StopwatchScreen extends StatefulWidget {
  @override
  State createState() => new _StopwatchScreenState();
}

class _StopwatchScreenState extends State<StopwatchScreen> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(),
      body: new Container(
        child: StopwatchWidget(),
      ),
    );
  }
}

class StopwatchWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
  }
}
