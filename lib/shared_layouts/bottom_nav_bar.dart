import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SharedBottomNavBar {
  static Container bottomNavBar() {
    return Container(
      decoration: new BoxDecoration(
          gradient: new LinearGradient(
              colors: [Colors.grey.shade500, Colors.grey.shade400])),
      child: new BottomNavigationBar(
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
