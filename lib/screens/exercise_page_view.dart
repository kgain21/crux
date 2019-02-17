import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crux/utils/base_auth.dart';
import 'package:crux/widgets/dots_indicator.dart';
import 'package:crux/widgets/exercise_form.dart';
import 'package:crux/widgets/hangboard_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ExercisePageView extends StatefulWidget {
  final String title;
  final CollectionReference collectionReference;
  final BaseAuth auth;

  @override
  State createState() => _ExercisePageViewState();

  ExercisePageView({this.title, this.collectionReference, this.auth});
}

class _ExercisePageViewState extends State<ExercisePageView>
    with AutomaticKeepAliveClientMixin {
  static const _kCurve = Curves.ease;
  static const _kDuration = const Duration(milliseconds: 300);

  PageController _controller;
  int _index;
  OverlayEntry _overlayEntry;
  bool _overlayVisible;
  double _currentPageValue;

  @override
  void initState() {
    super.initState();
    _overlayVisible = false;
    _currentPageValue = 0.0;

    /// [_controller] is 0 indexed but snapshot is not; add 1 to snapshot
    /// index to create a [newExercisePage].
    _index = 0;

    //TODO: Store last page # and reload there
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
        title: Text(widget.title),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection('hangboard/${widget.title}/exercises')
            .snapshots(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.none:
            /*return Padding(
                padding: const EdgeInsets.all(15.0),
                child: Card(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Retrieving exercises...'),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    ],
                  ),
                ),
              );*/
            default:
              //TODO: make these draggable on edit
              int documentsLength = snapshot.data.documents.length;
              _index = documentsLength + 1;

              return Center(
                child: new Container(
                  color: Theme.of(context).primaryColorDark,
                  child: Stack(
                    children: <Widget>[
                      PageView.builder(
                        //key: PageStorageKey('page-$_index'),
                        itemCount: _index,
                        controller: _controller,
                        itemBuilder: (context, index) {
                          //TODO: need to generalize this for other types of exercises
                          //TODO: UPDATE -- do i? this is just for hangboarding for now - come back to this

                          if (index == documentsLength) {
                            return newExercisePage();
                          } else {
                            return animatedHangboardPage(
                                index, snapshot.data.documents[index]);
                          }
                        },
                      ),
                      dotsIndicator(),
                    ],
                  ),
                ),
              );
          }
        },
      ),
    );
  }

  /*@override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(

        body:
      */ /*bottomNavigationBar: new FABBottomAppBar(
//        backgroundColor: Colors.blueGrey,
        //Color.fromARGB(255, 44, 62, 80),
        //midnight blue// Colors.white,
        //Color.fromARGB(255, 229, 191, 126),
//        color: Colors.white,
//        selectedColor: Colors.white,
        items: <FABBottomAppBarItem>[
          FABBottomAppBarItem(
            iconData: Icons.home,
            text: 'Home',
          ),
          */ /* */ /*FABBottomAppBarItem(
            iconData: Icons.menu,
            text: 'Menu',
          ),*/ /* */ /*
        ],
        onTabSelected: (index) {
          if (index == 0) {
            Navigator.popUntil(
                context, ModalRoute.withName('/dashboard_screen'));
          } else {
            return null;
          }
        },
      ),*/ /*
      */ /*floatingActionButton: FloatingActionButton(
        */ /* */ /*onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) {
                //TODO: finished here - make this an edit toggle button -> new exercise button appears and dropdowns become selectable to be edited in the form
                return ExerciseFormTile(
                  formKey: new GlobalKey<FormState>(),
                  exerciseTitle: 'Needs to change',
                  workoutTitle: widget.title,
                );
              }),
            );
          },*/ /* */ /*
        onPressed: () {
          showOverlay(context);
        },
        child: Icon(Icons.edit),
        //backgroundColor: Colors.blueGrey, //Color.fromARGB(255, 44, 62, 80),
      ),*/ /*
//        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }*/

  Widget newExercisePage() {
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
    return HangboardPage(
      index: index,
      exerciseParameters: Map<String, dynamic>.from(document.data),
    );
  }

  Widget dotsIndicator() {
    return new Positioned(
      bottom: 0.0,
      left: 0.0,
      right: 0.0,
      child: new Container(
        //color: Color.fromARGB(255, 44, 62, 80),
        padding: const EdgeInsets.all(20.0),
        child: new Center(
          child: new DotsIndicator(
            color: Theme.of(context).primaryColor,
            controller: _controller,
            itemCount: _index,
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
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
