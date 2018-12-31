import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TimerTextAnimator extends StatefulWidget {
  final int repTime;
  final int restTime;
  final int hangs;

  TimerTextAnimator({this.repTime, this.restTime, this.hangs});

  @override
  State createState() => _TimerTextAnimatorState();
}

class _TimerTextAnimatorState extends State<TimerTextAnimator>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  AnimationController _controller;
  Timer timer;
  bool _forwardAnimation;
  int _hangs;

  String get timerString {
    Duration duration;
    if(_forwardAnimation) {
      duration = _controller.duration * (1 - _controller.value);
    } else {
      duration = _controller.duration * _controller.value;
    }
    return '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      value: 1.0,
      vsync: this,
      duration: Duration(seconds: widget.repTime),
    );
    _forwardAnimation = false;
    //TODO: this doesn't work bc hangs are sent in from parent widget, need to add a listener in parent for completedForwardAnimation
    _hangs = widget.hangs;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GestureDetector(
      onTap: () {
        if (_controller.isAnimating) {
          _controller.stop(canceled: false);
          print(_controller.toString() + ' pause');
          print(_controller.value);
        } else {
          if (! _forwardAnimation) {
            try {
              _controller.reverse().whenComplete(() {
                if (_controller.status == AnimationStatus.dismissed) {
                  setState(() {
                    //TODO: want to keep timer alive on navigating away
                    //TODO: getting error calling setstate on disposed timer
                    //TODO: Find out way to not dispose() timer with closing expansiontile?
                    _controller.resync(this);
                    _controller.value = 0.0;
                    _controller.duration = Duration(seconds: widget.restTime);
                    _forwardAnimation = true;
                  });
                }
              });
              //TODO: I don't think these do anything - how do i test/handle these?
            } on TickerCanceled {
              print('TickerCanceled');
            } on Exception {
              print('Exception');
            } on Error {
              print('Error');
            }
          } else {
            try {
              _controller.forward().whenComplete(() {
                if (_controller.status == AnimationStatus.completed) {
                  setState(() {
                    _controller.value = 1.0;
                    _controller.duration = Duration(seconds: widget.repTime);
                    _forwardAnimation = false;
                    _hangs -= 1;
                  });
                }
              });
            } on TickerCanceled {
              print('TickerCanceled');
            } on Exception {
              print('Exception');
            } on Error {
              print('Error');
            }
          }
        }
      },
      onLongPress: () {
        if (_controller.isAnimating) {
          _controller.stop(canceled: false);
          if(_controller.status == AnimationStatus.reverse) {
            setState(() {
              _controller.value = 1.0;
            });
          } else if(_controller.status == AnimationStatus.forward){
            setState(() {
              _controller.value = 0.0;
            });
          }
        } else {
          if(_controller.status == AnimationStatus.reverse) {
            setState(() {
              _controller.value = 1.0;
            });
          } else if(_controller.status == AnimationStatus.forward) {
            setState(() {
              _controller.value = 0.0;
            });
          }
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
                      animation: _controller,
                      builder: (context, child) {
                        return new CustomPaint(
                          painter: TimerPainter(
                            animation: _controller,
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
                          animation: _controller,
                          builder: (context, child) {
                            return new Text(
                              timerString,
                              style: TextStyle(
                                fontSize: 30.0,
                              ),
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
    _controller.stop();
    _controller.dispose();
    super.dispose();
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
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
      ..strokeWidth = 12.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(size.center(Offset.zero), size.width / 2.0, paint);
    paint.color = color;
    double progress = (1 - animation.value) * 2 * math.pi;
    canvas.drawArc(Offset.zero & size, math.pi * 1.5, -progress, false, paint);
  }

  @override
  bool shouldRepaint(TimerPainter old) {
    return animation.value != old.animation.value ||
        color != old.color ||
        backgroundColor != old.backgroundColor;
  }
}
