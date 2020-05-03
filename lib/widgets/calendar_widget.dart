import 'package:flutter/material.dart';
import 'package:shifts_repository/shifts_repository.dart';
import 'package:snapshot_test/widgets/build_shift_container.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarWidget extends StatefulWidget {
  Map<DateTime, List<Shift>> map;
  DateTime selectedDay;

  CalendarWidget({Key key, this.map, this.selectedDay}) : super(key: key);

  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<CalendarWidget> {
  // Example holidays
  final Map<DateTime, List> _holidays = {
    DateTime(2019, 1, 1): ['New Year\'s Day'],
    DateTime(2019, 1, 6): ['Epiphany'],
    DateTime(2019, 2, 14): ['Valentine\'s Day'],
    DateTime(2019, 4, 21): ['Easter Sunday'],
    DateTime(2019, 4, 22): ['Easter Monday'],
  };
  Map<DateTime, List> _events;
  List _selectedEvents;
  CalendarController _calendarController;

  @override
  void initState() {
    super.initState();
    // final _selectedDay = DateTime.now();
    _calendarController = CalendarController();
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  void _onDaySelected(DateTime day, List events) {
    print('CALLBACK: _onDaySelected');
    setState(() {
      if (_selectedEvents != null) {
        _selectedEvents = events;
      }
    });
  }

  void _onVisibleDaysChanged(
      DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onVisibleDaysChanged');
  }

  void _onCalendarCreated(
      DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onCalendarCreated');
  }


  Widget _buildTableCalendarWithBuilders() {
    return TableCalendar(
      locale: 'de_DE',
      events: widget.map,
      initialCalendarFormat: CalendarFormat.twoWeeks,
      calendarController: _calendarController,
      calendarStyle: CalendarStyle(),
      headerStyle: HeaderStyle(
        centerHeaderTitle: true,
        formatButtonDecoration: BoxDecoration(
          color: Colors.pinkAccent.shade100,
          borderRadius: BorderRadius.circular(20.0),
        ),
        formatButtonShowsNext: false,
      ),
      startingDayOfWeek: StartingDayOfWeek.monday,
      initialSelectedDay: DateTime.now(),
      onDaySelected: (date, events) {
        setState(() {
          widget.selectedDay = _calendarController.selectedDay;
        });
      },
      builders: CalendarBuilders(
          selectedDayBuilder: (context, date, events) => Container(
                alignment: Alignment.center,
                margin: EdgeInsets.all(4.0),
                color: Colors.pink,
                child: Text(
                  date.day.toString(),
                ),
              ),
          todayDayBuilder: (context, date, events) => Container(
                alignment: Alignment.center,
                margin: EdgeInsets.all(4.0),
                color: Colors.teal.shade100,
                child: Text(
                  date.day.toString(),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                ),
              ),
          markersBuilder: (context, date, events, holidays) {
            final children = <Widget>[];

            if (events.isNotEmpty) {
              children.add(
                Positioned(
                  right: 1,
                  bottom: 1,
                  child: _buildEventsMarker(date, events),
                ),
              );
            }
            return children;
          }),
    );
  }

  Widget _buildEventsMarker(DateTime date, List events) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: _calendarController.isSelected(date)
            ? Colors.brown[500]
            : _calendarController.isToday(date)
                ? Colors.brown[300]
                : Colors.blue[400],
      ),
      width: 16.0,
      height: 16.0,
      child: Center(
        child: Text(
          '${events.length}',
          style: TextStyle().copyWith(
            color: Colors.white,
            fontSize: 12.0,
          ),
        ),
      ),
    );
  }

  static DateTime utcTo12oclock(DateTime dateTimeToChange) {
    if (dateTimeToChange != null) {
      DateTime dateOfShift = dateTimeToChange.toLocal();
      /*each device has a different utc. The table_calendar gives back
    everything as utc. Thus I have to find a way to edit everything to 12 o'clock*/
      return new DateTime(
          dateOfShift.year, dateOfShift.month, dateOfShift.day, 12);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          _buildTableCalendarWithBuilders(),
          Expanded(
            child: ListView.builder(
              itemCount:
                  widget.map[utcTo12oclock(_calendarController.selectedDay)] !=
                          null
                      ? widget
                          .map[utcTo12oclock(_calendarController.selectedDay)]
                          .length
                      : 0,
              itemBuilder: (context, index) {
                final shift = widget
                    .map[utcTo12oclock(_calendarController.selectedDay)][index];
                return BuildShiftContainer(shift: shift, scaffoldContext: context,);
              },
            ),
          ),
        ],
      ),
    );
  }
}