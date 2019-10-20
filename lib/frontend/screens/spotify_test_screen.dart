import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SpotifyTestScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SpotifyTestScreenState();
}

class _SpotifyTestScreenState extends State<SpotifyTestScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*appBar: null,*/
      body: Center(
        child: Row(
          children: <Widget>[
            Text('Spotify Integration'),
          ],
        ),
      ),
    );
  }
}
