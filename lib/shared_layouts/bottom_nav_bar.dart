import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SharedBottomNavBar extends StatefulWidget {
  @override
  State createState() => _SharedBottomNavBarState();
}

class _SharedBottomNavBarState extends State<SharedBottomNavBar> {
  int _currentIndex = 0;

  @override
  Widget build(context) {
    return Container(
      decoration: new BoxDecoration(
          gradient: new LinearGradient(
              colors: [Colors.grey.shade500, Colors.grey.shade400])),
      child: new BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: <BottomNavigationBarItem>[
          new BottomNavigationBarItem(
            icon: new Icon(Icons.home),
            title: new Text('Home'),
          ),
          new BottomNavigationBarItem(
            icon: new Icon(Icons.menu),
            title: new Text('Menu'),
          ),
        ],
      ),
    );
  }
}
