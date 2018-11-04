import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crux/widgets/hangboard_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HangboardWorkoutListTab extends StatefulWidget {
  @override
  State createState() => new _HangboardWorkoutListTabState();
}

class _HangboardWorkoutListTabState extends State<HangboardWorkoutListTab>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return WillPopScope(
      onWillPop: () async {
        return true; //todo: do i need this? might need for somehtign in the future
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          child: new Column(
            children: <Widget>[
              //TODO: look at separated listview
              new StreamBuilder<DocumentSnapshot>(
                stream: Firestore.instance
                    .document('workouts/hangboard')
                    .snapshots(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                      return Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Retrieving workout...'),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                          ],
                        ),
                      );
                    default:
                      return Flexible(
                        fit: FlexFit.tight,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data['max_hangs'].length,
                          itemBuilder: (context, index) {
                            return HangboardListTile(
                              index: index,
                              snapshot: snapshot.data,
                            );
                          },
                        ),
                      );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // TODO: implement wantKeepAlive
  @override
  bool get wantKeepAlive => true;
}
