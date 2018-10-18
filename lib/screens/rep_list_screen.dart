import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crux/shared_layouts/app_bar.dart';
import 'package:crux/shared_layouts/bottom_nav_bar.dart';
import 'package:crux/utils/base_auth.dart';
import 'package:crux/widgets/hangboard_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class RepListScreen extends StatefulWidget {
  final String title;
  final BaseAuth auth;
  final Firestore firestore;

  //TODO: going to have to make sure this syncs offline***
  //TODO: can i access firestore statically? Do i need to pass it as var to different screens?

  RepListScreen({Key key, this.title, this.auth, this.firestore})
      : super(key: key);

  @override
  _RepListScreenState createState() => new _RepListScreenState();
}

class _RepListScreenState extends State<RepListScreen> {
  Stopwatch stopwatch = new Stopwatch();
  CollectionReference maxHangs;
  DocumentSnapshot snapshot;

  //AsyncMemoizer _memoizer = AsyncMemoizer();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true; //todo: do i need this? might need for somehtign in the future
      },
      child: new Scaffold(
        appBar: SharedAppBar.sharedAppBar(
          widget.title,
          widget.auth,
          this.context,
        ),
        body: Column(
          children: <Widget>[
            //TODO: look at separated listview
            new StreamBuilder<DocumentSnapshot>(
              stream:
                  Firestore.instance.document('workouts/hangboard').snapshots(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        children: <Widget>[
                          Text('Retrieving workout... '),
                          Center(
                            child: CircularProgressIndicator(),
                            //TODO: this isn't centered
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
        bottomNavigationBar: SharedBottomNavBar.bottomNavBar(),
      ),
    );
  }
}
