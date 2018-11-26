import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class FABBottomAppBarItem {
  IconData iconData;
  String text;
  String route;

  FABBottomAppBarItem({this.iconData, this.text, this.route});
}

class FABBottomAppBar extends StatefulWidget {
  final double height;
  final double iconSize;
  final Color backgroundColor;
  final Color color;
  final Color selectedColor;
  final List<FABBottomAppBarItem> items;
  final ValueChanged<int> onTabSelected;

  FABBottomAppBar({
    this.height: 60.0,
    this.iconSize: 24.0,
    this.backgroundColor,
    this.color,
    this.selectedColor,
    this.items,
    this.onTabSelected,
  });

  @override
  State createState() => _FABBottomAppBarState();
}

class _FABBottomAppBarState extends State<FABBottomAppBar> {
  int _currentIndex;

  void _updateIndex(int index) {
    widget.onTabSelected(index);
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(context) {
    List<Widget> items = List.generate(widget.items.length, (index) {
      return _buildTabItem(
        item: widget.items[index],
        index: index,
        onPressed: _updateIndex,
      );
    });
    return BottomAppBar(
      shape: CircularNotchedRectangle(),
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: items,
      ),
      color: widget.backgroundColor,
    );
  }

  Widget _buildTabItem({
    FABBottomAppBarItem item,
    int index,
    ValueChanged<int> onPressed,
  }) {
    Color color = _currentIndex == index ? widget.selectedColor : widget.color;
    return Expanded(
      child: SizedBox(
        height: widget.height,
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: () => onPressed(index),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(
                  item.iconData,
                  color: color,
                  size: widget.iconSize,
                ),
                Text(
                  item.text,
                  style: TextStyle(color: color),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
