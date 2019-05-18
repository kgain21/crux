import 'dart:math' as math;

import 'package:flutter/material.dart';

class TimerPainter extends CustomPainter {
  final Animation<double> animation;
  final Color backgroundColor, color;
  final CustomClipper<Path> clipper;

  TimerPainter({this.animation, this.backgroundColor, this.color, this.clipper})
      : super(repaint: animation);

  /// [Size] in this case is the width of the inner circle holding the timerText
  @override
  void paint(Canvas canvas, Size size) {
    /// Properties of the progress indicating arc
    Paint line = Paint()
      ..color = backgroundColor
      ..strokeWidth = 20.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    /// Calculates the progress based on the controller value and converts it to
    /// radians
    double progress = (1 - animation.value) * 2 * math.pi;

    /// Draws the background circle around the timer
    canvas.drawCircle(
      size.center(Offset.zero),
      size.width / 2.0,
      line,
    );

    /// Draws a faint outline around the inside of the timer
    line.color = Colors.black12;
    line.strokeWidth = 2.0;
    canvas.drawCircle(
      size.center(Offset.zero),
      size.width / 2.0 - 10.0,
      line,
    );

    /// Draws a faint outline around the outside of the timer
    line.strokeWidth = 2.0;
    canvas.drawCircle(
      size.center(Offset.zero),
      size.width / 2.0 + 10.0,
      line,
    );

    /// Changes the color to the progress color and draws the progress
    /// indicating arc over the background circle
    line.color = color;
    line.strokeWidth = 20.0;
    canvas.drawArc(
      Offset.zero & size,
      math.pi * 1.5,
      -progress,
      false,
      line,
    );

    /// Sets the shadow of the inner circle where the timer text is held
    Path innerShadow = Path()
      ..addOval(Rect.fromCircle(
        center: size.center(Offset.zero),
        radius: size.width / 2.0 - 3.0,
      ));

    canvas.drawShadow(
      innerShadow,
      Colors.black87,
      2.0,
      true,
    );
  }

  @override
  bool shouldRepaint(TimerPainter old) {
    return animation.value != old.animation.value ||
        color != old.color ||
        backgroundColor != old.backgroundColor;
  }
}
