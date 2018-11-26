import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crux/shared_layouts/app_bar.dart';
import 'package:crux/utils/base_auth.dart';
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

class _ExerciseScreenState extends State<ExerciseScreen> {
  @override
  Widget build(BuildContext context) {
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
      //bottomNavigationBar: null,
    );
  }
}