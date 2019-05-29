import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crux/services/base_auth.dart';
import 'package:crux/shared_layouts/app_bar.dart';
import 'package:crux/shared_layouts/fab_bottom_app_bar.dart';
import 'package:crux/widgets/exercise_form.dart';
import 'package:crux/widgets/hangboard_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ExerciseScreen extends StatefulWidget {
  final String title;
  final DocumentSnapshot snapshot;
  final BaseAuth auth;

  @override
  State<StatefulWidget> createState() => _ExerciseScreenState();

  ExerciseScreen({this.title, this.snapshot, this.auth});
}

class _ExerciseScreenState extends State<ExerciseScreen>
    with AutomaticKeepAliveClientMixin {
  OverlayEntry _overlayEntry;
  bool _overlayVisible;

  @override
  void initState() {
    super.initState();
    setState(() {
      _overlayVisible = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return WillPopScope(
      onWillPop: () async {
        if (_overlayVisible) {
          setState(() {
            _overlayVisible = false;
            _overlayEntry.remove();
          });
        }
        //TODO: Close stream? do this in workout screen?
        //this.dispose();
        return true;
        //TODO: make sure user saves set if there's any progress?
      },
      child: new Scaffold(
        appBar:
            SharedAppBar.sharedAppBar(widget.title, widget.auth, this.context),
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Flexible(
              fit: FlexFit.loose,
              //TODO: Can i get the open tile to go to the top of the screen?
              child: ListView.builder(
                controller: new ScrollController(),
                key: PageStorageKey('ExerciseListBuilder'),
                itemCount: widget.snapshot.data['exercises'].length,
                shrinkWrap: true,
                itemBuilder: (context, fieldIndex) {
                  return HangboardPage(
                    index: fieldIndex,
                    exerciseParameters: Map<String, dynamic>.from(
                        widget.snapshot.data['exercises'][fieldIndex]),
                  );
                },
              ),
            ),
          ],
        ),
        bottomNavigationBar: new FABBottomAppBar(
          backgroundColor: Colors.blueGrey,
          //Color.fromARGB(255, 44, 62, 80),
          //midnight blue// Colors.white,
          //Color.fromARGB(255, 229, 191, 126),
          color: Colors.white,
          selectedColor: Colors.white,
          items: <FABBottomAppBarItem>[
            FABBottomAppBarItem(
              iconData: Icons.home,
              text: 'Home',
            ),
            FABBottomAppBarItem(
              iconData: Icons.menu,
              text: 'Menu',
            ),
          ],
          onTabSelected: (index) {
            if (index == 0) {
              Navigator.popUntil(
                  context, ModalRoute.withName('/dashboard_screen'));
            } else {
              return null;
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          /*onPressed: () {
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
          },*/
          onPressed: () {
            showOverlay(context);
          },
          child: Icon(Icons.edit),
          backgroundColor: Colors.blueGrey, //Color.fromARGB(255, 44, 62, 80),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
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
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
