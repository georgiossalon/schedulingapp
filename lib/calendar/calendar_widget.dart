import 'package:employees_repository/employees_repository.dart';
import 'package:flutter/material.dart';
import 'package:snapshot_test/employee/screens/employee_date_event.dart';
import 'package:snapshot_test/shifts/widgets/shifts_view.dart';
import 'package:table_calendar/table_calendar.dart';

import '../core/date_info.dart';
import 'shift_calendar_container.dart';
import 'date_event_calendar_container.dart';

class CalendarWidget extends StatefulWidget {
  Map<DateTime, List<dynamic>> map;
  bool isShift;

  CalendarWidget({Key key, this.map, this.isShift}) : super(key: key);

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
  // Map<DateTime, List> _events;
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

  Color dateColorAccordingToAction(DateTime dateTime, bool today) {
    if (widget.map[DateInfo.utcTo12oclock(dateTime)] == null ||
        widget.map[DateInfo.utcTo12oclock(dateTime)].isEmpty) {
      //for no input leave the color as is
      if (today) {
        // the today date gets a light blue color
        return Colors.blue.shade200;
      } else {
        // the remaining days get the standard white one
        return Colors.white24;
      }
    } else {
      // if the list _events[_calendarController.selectedDay] contains as
      // the first element a string, then I have an status entry
      // if it is not a string it is probably a shift object
      // employee unavailable then the color is red
      DateEvent dateEvent = widget.map[DateInfo.utcTo12oclock(dateTime)][0];
      if (dateEvent.reason == 'shift') {
        return Colors.green;
      } else {
        // employee has a shift
        return Colors.red;
      }
    }
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
          widget.isShift
              ? ShiftsView.shiftCalendarSelectedDay =
                  _calendarController.selectedDay
              : EmployeeDateEvent.employeeDateEventSelectedDay =
                  _calendarController.selectedDay;
        });
      },
      builders: CalendarBuilders(
          selectedDayBuilder: (context, date, events) => Container(
                alignment: Alignment.center,
                margin: EdgeInsets.all(4.0),
                color: Colors.blueGrey.shade200,
                child: Text(
                  date.day.toString(),
                ),
              ),
          todayDayBuilder: (context, date, events) => Container(
                alignment: Alignment.center,
                margin: EdgeInsets.all(4.0),
                color: widget.isShift
                    ? Colors.teal.shade100
                    : dateColorAccordingToAction(date, true),
                child: Text(
                  date.day.toString(),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                ),
              ),
          dayBuilder: (context, date, events) => Container(
                alignment: Alignment.center,
                margin: EdgeInsets.all(4.0),
                color: widget.isShift
                    ? Colors.white24
                    : dateColorAccordingToAction(date, false),
                child: Text(
                  date.day.toString(),
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
      DateTime dateOfEvent = dateTimeToChange.toLocal();
      /*each device has a different utc. The table_calendar gives back
    everything as utc. Thus I have to find a way to edit everything to 12 o'clock*/
      return new DateTime(
          dateOfEvent.year, dateOfEvent.month, dateOfEvent.day, 12);
    }
  }

  int searchOnlyIfMapNotNull(Map<DateTime, List<dynamic>> map) {
    if (map == null || map.isEmpty) {
      return 0;
    } else {
      if (widget.map[utcTo12oclock(_calendarController.selectedDay)] != null) {
        return widget
            .map[utcTo12oclock(_calendarController.selectedDay)].length;
      } else {
        return 0;
      }
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
              itemCount: searchOnlyIfMapNotNull(widget.map),
              itemBuilder: (context, index) {
                final DateEvent event = widget.map[
                            utcTo12oclock(_calendarController.selectedDay)] !=
                        null
                    ? widget.map[utcTo12oclock(_calendarController.selectedDay)]
                        [index]
                    : null;
                //todo if I want to reuse this Widget I have to specify
                //todo... if I have a shift or an other status
                return widget.isShift
                    ? ShiftCalendarContainer(
                        dateEvent: event,
                        scaffoldContext: context,
                      )
                    : DateEventCalendarContainer(
                        dateEvent: event,
                        scaffoldContext: context,
                      );
              },
            ),
          ),
        ],
      ),
    );
  }
}
