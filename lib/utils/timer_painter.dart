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
      ..strokeWidth = 12.0
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

    /// Changes the color to the progress color and draws the progress
    /// indicating arc over the background circle
    line.color = color;
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
      Colors.black,
      2.5,
      true,
    );

    Offset midPoint = Offset(size.width / 2.0, 0.0);
    //Offset leftMidPoint = Offset((math.sqrt(2)/2) *  , dy)
    Offset leftEndPoint = Offset(0.0, size.height / 2.0);
    Offset rightEndPoint = Offset(size.width, size.height / 2.0);

    /// Sets the shadow of the progress indicating circle by adding an arc
    Path outerShadow = Path()
      ..moveTo(0.0, size.height / 2.0)
      ..addArc(
        Rect.fromCircle(
          center: size.center(Offset.zero),
          radius: (size.width / 2.0) + 6.0,
        ),
        -math.pi,
        0.0,
      );
    /*..arcTo(
        Rect.fromCircle(
          center: size.center(Offset.zero),
          radius: (size.width / 2.0) + 6.0,
        ),
        0.0, //-math.pi,
        -math.pi,
        true,
      );*/

    /*outerShadow.quadraticBezierTo(
      midPoint.dx,
      midPoint.dy,
      leftEndPoint.dx,
      leftEndPoint.dy,
    );*/

    /*..quadraticBezierTo(
        -(size.width),
        (size.center(Offset.zero).dy),
        (math.pi / 2.0) * (size.center(Offset.zero).dx),
        -(math.pi / 2.0) * (size.width),
      )*/

    Offset center = Offset(size.width / 2.0, .7 * size.height);

    Path clipShadow = Path()
      ..addArc(
          Rect.fromCircle(
            center: center,
            radius: size.width / 2.0 + 3.0,
          ),
          0.0,
          -math.pi);

    /* canvas.drawShadow(
      outerShadow,
      Colors.black,
      2.5,
      true,
    );
    canvas.clipPath(clipShadow);*/
    Paint shadowLine = Paint()..color = backgroundColor;

    canvas.drawPath(outerShadow, shadowLine);

//    canvas.drawPath(clipper.getClip(size), Shadow(blurRadius: 5.0).toPaint());
  }

  @override
  bool shouldRepaint(TimerPainter old) {
    return animation.value != old.animation.value ||
        color != old.color ||
        backgroundColor != old.backgroundColor;
  }
}

class InnerShadow extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    // TODO: implement getClip
    return null;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
