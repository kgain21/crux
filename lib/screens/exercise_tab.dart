import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crux/widgets/hangboard_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ExerciseTab extends StatefulWidget {
  @override
  State createState() => new _ExerciseTabState();
}

class _ExerciseTabState extends State<ExerciseTab>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[],
        ),
      ),
    );
  }

  Widget exerciseListBuilder(
      AsyncSnapshot<QuerySnapshot> snapshot, int docIndex) {
    return new Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Flexible(
            fit: FlexFit.loose,
            child: ListView.builder(
              controller: new ScrollController(),
              key: PageStorageKey('ExerciseListBuilder'),
              itemCount:
                  snapshot.data.documents[docIndex].data['exercises'].length,
              shrinkWrap: true,
              itemBuilder: (context, fieldIndex) {
                return HangboardPage(
                  index: fieldIndex,
                  exerciseParameters: Map<String, dynamic>.from(snapshot
                      .data.documents[docIndex].data['exercises'][fieldIndex]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  // TODO: implement wantKeepAlive
  @override
  bool get wantKeepAlive => true;
}
