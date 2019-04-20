import 'package:crux/utils/base_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_calendar/flutter_calendar.dart';

class CalendarScreen extends StatefulWidget {
  final BaseAuth auth;

  CalendarScreen({this.auth});

  @override
  State<StatefulWidget> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  int _currentIndex;
  OverlayEntry _overlayEntry;
  bool _overlayVisible;

  @override
  void initState() {
    super.initState();
    _currentIndex = 0;
    _overlayVisible = false;
  }

  @override
  Widget build(BuildContext context) {
    return calendarWidget();
  }

  Widget calendarWidget() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 2.5,
        child: Material(
          child: new Calendar(
            /*dayBuilder: (context, dateTime) {
                    if(dateTime.day == DateTime.now().day) {
                      calendarTile(true);//TODO: need to put this in it's own widget to have selected property
                    }
                    return Material(
                      child: InkWell(
                        onTap: () {

                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(4.0)),
                            border: Border.all(color: Colors.black38)
                          ),
                          child: new Text(dateTime.day.toString()),
                        ),
                      ),
                    );
                  },*/
            isExpandable: true,
            onSelectedRangeChange: (range) =>
                print("Range is ${range.item1}, ${range.item2}"),
            onDateSelected: (date) {
              /* FocusScope.of(context).requestFocus(_focusNode);
                    _focusNode.addListener(() {
                      if(!_focusNode.hasFocus)
                        this._overlayEntry.remove();
                    });*/
              handleNewDate(date);
            },
          ),
        ),
      ),
    );
  }

  void handleNewDate(DateTime date) {
    //TODO: format date in overlay better

    //TODO: Link workouts here (look at #3 in link below)
    //https://pub.dartlang.org/packages/flutter_calendar#-readme-tab-
    print("handleNewDate $date");
    this._overlayEntry = createOverlayEntry(date);
    Overlay.of(context).insert(_overlayEntry);
  }

  OverlayEntry createOverlayEntry(DateTime date) {
    RenderBox renderBox = context.findRenderObject();
    var size = renderBox.size;

    return OverlayEntry(builder: (context) {
      return Positioned(
        width: size.width / 1.5,
        height: size.height / 3.0,
        left: size.width / 6.0,
        top: size.height / 4.0,
        child: Card(
          child: Column(
            children: <Widget>[
              GestureDetector(
                onTap: () => _overlayEntry.remove(),
                child: Icon(
                  Icons.cancel,
                ),
              ),
              Text(
                '${date.toString()}',
                //TODO: going to need to go to db to find workout assoc w/ this day
                //TODO: if nothing there, option to create new or select from premade workouts
//                style: TextStyle(fontSize: 12.0, color: Colors.black),
              ),
            ],
          ),
        ),
      );
    });
  }
}
