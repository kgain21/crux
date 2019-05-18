import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ExerciseTile extends StatefulWidget {
  final Color tileColor;
  final Widget child;
  final EdgeInsets edgeInsets;

  ExerciseTile({this.tileColor, this.child, this.edgeInsets});

  @override
  State<ExerciseTile> createState() => _ExerciseTileState();
}

class _ExerciseTileState extends State<ExerciseTile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.edgeInsets != null
          ? widget.edgeInsets
          : const EdgeInsets.only(left: 8.0, top: 8.0, right: 8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(6.0)),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 2.0,
              spreadRadius: 1.0,
              offset: Offset(0.0, 2.0),
            ),
          ],
          gradient: widget.tileColor != null
              ? LinearGradient(
                  // Where the linear gradient begins and ends
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  // Add one stop for each color. Stops should increase from 0 to 1
                  stops: [0.3, 0.6, 0.9],
                  colors: [
                    // Colors are easy thanks to Flutter's Colors class.
                    widget.tileColor.withOpacity(.8),
                    widget.tileColor.withOpacity(.9),
                    widget.tileColor.withOpacity(1),
                  ],
                )
              : LinearGradient(colors: <Color>[
                  Theme.of(context).primaryColorLight,
                  Theme.of(context).primaryColorLight
                ]),
        ),
        child: widget.child,
      ),
    );
  }
}
