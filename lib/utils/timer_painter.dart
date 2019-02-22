import 'package:flutter/material.dart';
import 'dart:math' as math;

class TimerPainter extends CustomPainter {
  final Animation<double> animation;
  final Color backgroundColor, color;

  TimerPainter({this.animation, this.backgroundColor, this.color})
      : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    Paint line = Paint()
      ..color = backgroundColor
      ..strokeWidth = 12.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    double progress = (1 - animation.value) * 2 * math.pi;

    Path innerPath = Path()
      ..addOval(Rect.fromCircle(
        center: size.center(Offset.zero),
        radius: size.width / 2.0 - 3.0,
      ));

    Path outerPath = Path()
      ..addArc(
        Rect.fromCircle(
          center: size.center(Offset.zero),
          radius: (size.width/* + 12.0*/) / 2.0,
        ),
        -math.pi,
        math.pi,
      );

    canvas.drawCircle(
      size.center(Offset.zero),
      size.width / 2.0,
      line,
    );

    line.color = color;
    canvas.drawArc(
      Offset.zero & size,
      math.pi * 1.5,
      -progress,
      false,
      line,
    );

    canvas.drawShadow(
      innerPath,
      Colors.black,
      2.5,
      true,
    );

//    canvas.drawShadow(
//      outerPath,
//      Colors.black,
//      2.5,
//      true,
//    );
  }

  @override
  bool shouldRepaint(TimerPainter old) {
    return animation.value != old.animation.value ||
        color != old.color ||
        backgroundColor != old.backgroundColor;
  }
}
