import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:snapshot_test/blocs/blocs.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shifts_repository/shifts_repository.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void main() {
  BlocSupervisor.delegate = SimpleBlocDelegate();
  initializeDateFormatting().then((_) => runApp(ShiftsApp()));
  // runApp(ShiftsApp());
}

class ShiftsApp extends StatelessWidget {
  static Map<DateTime, List<Shift>> shiftListToCalendarEventMap(
      List<Shift> shiftList) {
    Map<DateTime, List<Shift>> map = {};
    for (int i = 0; i < shiftList.length; i++) {
      Shift shift = shiftList[i];
      DateTime shiftDateTime = shift.shift_date;
      if (map[shiftDateTime] == null) {
        // creating a new List and passing a widget
        map[shiftDateTime] = [shift];
      } else {
        List<Shift> helpList = map[shiftDateTime];
        helpList.add(shift);
      }
    }
    return map;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider<ShiftsBloc>(
        create: (context) {
          return ShiftsBloc(
            shiftsRepository: FirebaseShiftsRepository(),
          )..add(LoadShifts());
        },
        child: ShiftListPage(),
      ),
    );
  }
}

class ShiftListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ShiftsBloc, ShiftsState>(
        builder: (context, state) {
          if (state is ShiftsLoading) {
            return Padding(
                padding: EdgeInsets.all(20.0),
                child: Container(
                  child: Text(
                    'Loading',
                    style: TextStyle(fontSize: 20.0),
                  ),
                ));
          } else if (state is ShiftsLoaded) {
            final shiftsList = state.shifts;
            Map<DateTime, List<Shift>> map =
                ShiftsApp.shiftListToCalendarEventMap(shiftsList);
            return Calendar(
              map: map,
            );
          } else {
            return Container(
              child: Text('Shit happens'),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Navigator.pushNamed(context, routeName);
          }
        ),
    );
  }
}

class Calendar extends StatefulWidget {
  Map<DateTime, List<Shift>> map;

  Calendar({Key key, this.map}) : super(key: key);

  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
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
  AnimationController _animationController;
  CalendarController _calendarController;

  @override
  void initState() {
    super.initState();
    // final _selectedDay = DateTime.now();
    _calendarController = CalendarController();
  }

  @override
  void dispose() {
    _animationController.dispose();
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

  Widget _buildShiftContainer({Shift shift}) {
//    new Builder(builder: (gestureBuilder) {
    return Container(
//      height: 250.0,
      color: Colors.blueGrey,
      height: 65.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
//            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text(
                'Start ${shift.start_shift}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17.0,
                ),
              ),
              SizedBox(
                width: 20.0,
              ),
              Text(
                'End ${shift.end_shift}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17.0,
                ),
              ),
            ],
          ),
          Text(
            'Designation: ${shift.designation}',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),
            textAlign: TextAlign.left,
          ),
          Text(
            'Employee: ${shift.employee}',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),
            textAlign: TextAlign.left,
          ),
          Visibility(
            visible: false,
            child: Row(
              children: <Widget>[
                Text(
                  '${shift.id}',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),
                  textAlign: TextAlign.left,
                ),
                // Text(
                //   '${shift.firestoreId}',
                //   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),
                //   textAlign: TextAlign.left,
                // )
              ],
            ),
          ),
        ],
      ),
    );
//    });
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
//      initialSelectedDay: DateTime(2020, 3, 25),
      onDaySelected: (date, events) {
        setState(() {
          // I use this for the length of the ListView.separator/builder
          // _listOfShiftsPerGivenDay = events;
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
                return _buildShiftContainer(shift: shift);
              },
            ),
          ),
        ],
      ),
    );
  }
}
