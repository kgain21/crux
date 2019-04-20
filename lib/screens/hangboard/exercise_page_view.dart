import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crux/utils/base_auth.dart';
import 'package:crux/widgets/dots_indicator.dart';
import 'package:crux/widgets/exercise_form.dart';
import 'package:crux/widgets/hangboard_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ShakeCurve extends Curve {
  @override
  double transform(double t) => sin(t * pi * 2);
}

class ExercisePageView extends StatefulWidget {
  final String title;
  final CollectionReference collectionReference;
  final BaseAuth auth;
  final workoutId;

  @override
  State createState() => _ExercisePageViewState();

  ExercisePageView(
      {this.title, this.collectionReference, this.auth, this.workoutId});
}

class _ExercisePageViewState extends State<ExercisePageView>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  static const _kCurve = Curves.ease;
  static const _kDuration = const Duration(milliseconds: 300);
  static const _kViewportFraction = 0.7;

  ValueNotifier<double> selectedIndex = ValueNotifier<double>(0.0);

  PageController _controller;
  PageController _zoomController;

//  AnimationController _shakeController;
//  Animation _shakeCurve;
  int _pageCount;
  OverlayEntry _overlayEntry;
  bool _overlayVisible;
  double _currentPageValue;
  bool _zoomOut;
  bool _exerciseFinished;

  /* bool _handlePageNotification(ScrollNotification notification,
                               PageController leader, PageController follower) {
    if (notification.depth == 0 && notification is ScrollUpdateNotification) {
      selectedIndex.value = leader.page;
      if (follower.page != leader.page) {
        follower.position.jumpToWithoutSettling(leader.position.pixels /
            _kViewportFraction); // ignore: deprecated_member_use
      }
      setState(() {});
    }
    return false;
  }*/

  @override
  void initState() {
    super.initState();
    _overlayVisible = false;
    _currentPageValue = 0.0;
    _zoomOut = false;
//    _shakeController = new AnimationController(vsync: this, duration: Duration(seconds: 1));
//    _shakeCurve = CurvedAnimation(parent: _shakeController, curve: ShakeCurve());

    /// [_controller] is 0 indexed but snapshot is not; add 1 to snapshot
    /// index to create a [newExercisePage].
    _pageCount = 0;

    //TODO: Store last page # and reload there
    _zoomController = new PageController(
        viewportFraction: _kViewportFraction /*initialPage: _index - 2*/);
    _controller = new PageController(/*initialPage: _index - 2*/);
    _controller.addListener(() {
      setState(() {
        _currentPageValue = _controller.page;
      });
    });
  }

  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        //backgroundColor: Theme.of(context),
        title: Text(widget.title),
      ),
      body: exercisePageView(),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _zoomController.dispose();
    super.dispose();
  }

  Widget exercisePageView() {
    return GestureDetector(
      onLongPress: () {
        setState(() {
          _zoomOut = true;
          print('editing');
        });
      },
      onTap: () {
        if (_zoomOut == true) {
          setState(() {
            _zoomOut = false;
          });
        }
      },
      child: exerciseStreamBuilder(),
    );
  }

  Widget exerciseStreamBuilder() {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection('hangboard/${widget.title}/exercises')
          .snapshots(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
          case ConnectionState.none:
          default:
            int documentsLength = 0;
            if (snapshot.data != null) {
              documentsLength = snapshot.data.documents.length;
            }
            _pageCount = documentsLength + 1;

            return Center(
              child: new Container(
                color: Theme.of(context).primaryColor /*Dark*/,
                child: Stack(
                  children: <Widget>[
                    PageView(
                      controller: _zoomOut ? _zoomController : _controller,
                      children: createPageList(documentsLength, snapshot),
                    ),
                    dotsIndicator(),
                  ],
                ),
              ),
            );
        }
      },
    );
  }

  List<Widget> createPageList(int documentsLength, AsyncSnapshot snapshot) {
    final List<Widget> pages = <Widget>[];
    double pictureHeight = MediaQuery.of(context).size.height * 0.6;
    double pictureWidth = MediaQuery.of(context).size.width * 0.6;

    for (int i = 0; i < _pageCount; i++) {
      Widget child;

      if (i == documentsLength) {
        child = newExercisePage();
      } else {
        child = animatedHangboardPage(i, snapshot.data.documents[i]);
      }

      var alignment = Alignment.center
          .add(Alignment((selectedIndex.value - i) * _kViewportFraction, 0.0));
      var resizeFactor =
          (1 - (((selectedIndex.value - i).abs() * 0.3).clamp(0.0, 1.0)));

      /*if (_zoomOut) {
        pages.add(Container(
          //alignment: alignment,
          width: pictureWidth * resizeFactor,
          height: pictureHeight * resizeFactor,
          child: child,
        ));
      } else {*/
      pages.add(Container(
        child: child,
      ));
//      }
    }

    return pages;
  }

  Widget newExercisePage() {
    //todo: trying to figure out why added exercises are incorrect sometimes on navigating back
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) {
                return ExerciseForm(
                  workoutTitle: widget.title,
                );
              }),
            );
          },
          child: Icon(
            Icons.add,
            size: 75.0,
          ),
        ),
        Text(
          'New Exercise',
          style: TextStyle(fontSize: 20.0),
        ),
      ],
    );
  }

  Widget animatedHangboardPage(int index, DocumentSnapshot document) {
    /// Last page should always be a [newExercisePage]; this index will always
    /// be greater than the current exercises list so this must be checked first
    /*if (index == _currentPageValue.floor()) {
      return Transform(
        transform: Matrix4.identity()..rotateX(_currentPageValue - index),
        child: HangboardPage(
          index: index,
          exerciseParameters: Map<String, dynamic>.from(
              widget.snapshot.data['exercises'][index]),
        ),
      );
    } else if (index == _currentPageValue.floor() + 1) {
      return Transform(
        transform: Matrix4.identity()..rotateX(_currentPageValue - index),
        child: HangboardPage(
          index: index,
          exerciseParameters: Map<String, dynamic>.from(
              widget.snapshot.data['exercises'][index]),
        ),
      );
    } */

    return Stack(
      children: <Widget>[
        HangboardPage(
          workoutId: widget.workoutId,
          index: index,
          exerciseParameters: Map<String, dynamic>.from(document.data),
          nextPageCallback: nextPageCallback,
        ),
        _zoomOut
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    IconButton(
                      color: Colors.black,
                      icon: Icon(Icons.cancel),
                      onPressed: () {
                        //TODO: ask user for delete confirmation
                        Firestore.instance
                            .document(document.reference.path)
                            .delete();
                      },
                    ),
                  ],
                ),
              )
            : null,
      ].where(notNull).toList(),
    );
  }

  bool notNull(Object o) => o != null;

  Widget dotsIndicator() {
    return new Positioned(
      bottom: 0.0,
      left: 0.0,
      right: 0.0,
      child: new Container(
        padding: const EdgeInsets.all(20.0),
        child: new Center(
          child: new DotsIndicator(
            color: Theme.of(context).primaryColorLight,
            controller: _zoomOut ? _zoomController : _controller,
            itemCount: _pageCount,
            onPageSelected: (int page) {
              _controller.animateToPage(
                page,
                duration: _kDuration,
                curve: _kCurve,
              );
            },
          ),
        ),
      ),
    );
  }

  void nextPageCallback() {
    _controller.nextPage(duration: _kDuration, curve: _kCurve);
  }

  //TODO: Separate into show/hide?
  void showOverlay(BuildContext context) {
    if (!_overlayVisible) {
      setState(() {
        _overlayVisible = true;
        this._overlayEntry = this._createOverlayEntry(context);
        Overlay.of(context).insert(this._overlayEntry);
      });
    } else {
      setState(() {
        _overlayEntry.remove();
        _overlayVisible = false;
      });
    }
  }

  OverlayEntry _createOverlayEntry(BuildContext context) {
    RenderBox renderBox = context.findRenderObject();
    var size = renderBox.size;

    return OverlayEntry(
        builder: (context) => Positioned(
              left: size.width / /*6.0*/ 100.0,
              top: size.height / 3.0,
              width: size.width /* / 1.2*/,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: size.height / 2.0,
                ),
                child: ExerciseForm(
                  workoutTitle: widget.title,
                ),
              ),
            ));
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
