import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TimerText extends StatefulWidget {
  //final Stopwatch stopwatch;
  final Timer timer;

  @override
  State<TimerText> createState() => new _TimerTextState();

  TimerText({this.timer});
}

class _TimerTextState extends State<TimerText> {
  Timer repaintTimer;

  _TimerTextState() {
    repaintTimer = new Timer.periodic(new Duration(milliseconds: 30), callback);
  }

  void callback(timer) {
    if (widget.timer.isActive) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle timerTextStyle = const TextStyle(
      fontSize: 60.0,
      fontFamily: "Open Sans",
    );
    String formattedTime = TimerTextFormatter.format(widget.timer.tick);
    return new Text(
      formattedTime,
      style: timerTextStyle,
    );
  }
}

class TimerTextFormatter {
  static String format(int currentTimeMillis) {
    int hundreds = (currentTimeMillis / 10).truncate();
    int seconds = (hundreds / 100).truncate();
    int minutes = (seconds / 60).truncate();

    String minuteStr = (minutes % 60).toString().padLeft(2, '0');
    String secondsStr = (seconds % 60).toString().padLeft(2, '0');
    String hundredsStr = (hundreds % 100).toString().padLeft(2, '0');

    return "$minuteStr:$secondsStr:$hundredsStr";
  }
}

class TimerTextAnimator extends StatefulWidget {
  final int repTime;
  final int restTime;

  TimerTextAnimator({this.repTime, this.restTime});

  @override
  State createState() => _TimerTextAnimatorState();
}

class _TimerTextAnimatorState extends State<TimerTextAnimator>
    with TickerProviderStateMixin {
  AnimationController controller;

  String get timerString {
    Duration duration = controller.duration * controller.value;
    return '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  AnimationController get timerController {
    return controller;
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: widget.repTime),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (controller.isAnimating)
          controller.stop(canceled: false);
        else {
          controller.reverse(
              from: controller.value == 0.0 ? 1.0 : controller.value);
        }
      },
      onLongPress: () {
        if (controller.value > 0.0 && controller.value < 1.0) {
          controller.reset();
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Flexible(
            fit: FlexFit.loose,
            child: AspectRatio(
              aspectRatio: 1.0,
              child: Stack(
                //Stack here because we are painting two circle over each other. Progress circle is stacked on top of white empty circle.
                children: <Widget>[
                  Positioned.fill(
                    child: AnimatedBuilder(
                      animation: controller,
                      builder: (context, child) {
                        return new CustomPaint(
                          painter: TimerPainter(
                            animation: controller,
                            backgroundColor: Colors.black,
                            color: Colors.green,
                          ),
                        );
                      },
                    ),
                  ),
                  Align(
                    alignment: FractionalOffset.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        AnimatedBuilder(
                          animation: controller,
                          builder: (context, child) {
                            return new Text(
                              timerString,
                            );
                          },
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

class TimerPainter extends CustomPainter {
  final Animation<double> animation;
  final Color backgroundColor, color;

  TimerPainter({this.animation, this.backgroundColor, this.color})
      : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = backgroundColor
      ..strokeWidth = 6.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(size.center(Offset.zero), size.width / 2.0, paint);
    paint.color = color;
    double progress = (1.0 - animation.value) * 2 * math.pi;
    canvas.drawArc(Offset.zero & size, math.pi * 1.5, -progress, false, paint);
  }

  @override
  bool shouldRepaint(TimerPainter old) {
    return animation.value != old.animation.value ||
        color != old.color ||
        backgroundColor != old.backgroundColor;
  }
}
