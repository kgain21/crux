import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crux/widgets/hangboard_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HangboardWorkoutListTab extends StatefulWidget {
  @override
  State createState() => new _HangboardWorkoutListTabState();
}

class _HangboardWorkoutListTabState extends State<HangboardWorkoutListTab>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {

 /* ScrollController _workoutListScrollController;

  @override
  void initState() {
    super.initState();
    //_workoutListScrollController = new ScrollController();
  }*/

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
          children: <Widget>[
            new StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance.collection('hangboard').snapshots(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Card(
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Retrieving workouts...'),
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
                    );
                  default:
                    return Expanded(
                      child: ListView.builder(
                        controller: new ScrollController(),
                        //List of all workouts
                        key: PageStorageKey('WorkoutListBuilder'),
                        shrinkWrap: true,
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (context, docIndex) {
                          return exerciseListBuilder(snapshot, docIndex);
                        },
                      ),
                    );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget exerciseListBuilder(AsyncSnapshot<QuerySnapshot> snapshot, int docIndex) {
    return new Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Flexible(
            fit: FlexFit.loose,
            child: ListView.builder(
              controller: new ScrollController(),
              key: PageStorageKey('ExerciseListBuilder'),
              itemCount: snapshot.data.documents[docIndex].data['exercises'].length,
              shrinkWrap: true,
              itemBuilder: (context, fieldIndex) {
                return HangboardPage(
                    index: fieldIndex,
                    exerciseParameters: Map<String, dynamic>.from(snapshot
                    .data
                    .documents[docIndex]
                    .data['exercises'][fieldIndex]),
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
