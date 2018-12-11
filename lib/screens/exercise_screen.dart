import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crux/shared_layouts/app_bar.dart';
import 'package:crux/shared_layouts/fab_bottom_app_bar.dart';
import 'package:crux/utils/base_auth.dart';
import 'package:crux/widgets/exercise_form_tile.dart';
import 'package:crux/widgets/hangboard_list_tile.dart';
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

class _ExerciseScreenState extends State<ExerciseScreen> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return new Scaffold(
      appBar:
      SharedAppBar.sharedAppBar(widget.title, widget.auth, this.context),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Flexible(
            fit: FlexFit.loose,
            child: ListView.builder(
              controller: new ScrollController(),
              key: PageStorageKey('ExerciseListBuilder'),
              itemCount: widget.snapshot.data['exercises'].length,
              shrinkWrap: true,
              itemBuilder: (context, fieldIndex) {
                return HangboardListTile(
                    index: fieldIndex,
                    exerciseParameters: Map<String, dynamic>.from(widget.snapshot
                    .data['exercises'][fieldIndex]),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: new FABBottomAppBar(
        backgroundColor: Colors.white,
        //Color.fromARGB(255, 229, 191, 126),
        color: Colors.black54,
        selectedColor: Colors.black,
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
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) {
              //todo: do this in an overlay?
              return ExerciseFormTile(
                formKey: new GlobalKey<FormState>(),
                exerciseTitle: 'Needs to change',
                workoutTitle: widget.title,
              );
            }),
          );
        },
        child: Icon(Icons.edit),
        backgroundColor: Color.fromARGB(255, 44, 62, 80),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}