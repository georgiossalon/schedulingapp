import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shifts_repository/shifts_repository.dart';
import 'package:snapshot_test/blocs/blocs.dart';
import 'package:snapshot_test/screens/add_edit_shift.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarWidget extends StatelessWidget {
  static const String screenId = 'calendar_screen';
  static DateTime selectedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShiftsBloc, ShiftsState>(
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
              CalendarWidget.shiftListToCalendarEventMap(shiftsList);
          return SafeArea(
                      child: Scaffold(
              body: Calendar(
                map: map,
              ),
              floatingActionButton: FloatingActionButton(
                child: Icon(Icons.add),
                backgroundColor: Colors.pink,
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return AddEditShift(
                      onSave: (designation, employeeName, start_shift, end_shift,
                          shift_date) {
                        BlocProvider.of<ShiftsBloc>(context).add(AddShift(
                          Shift(
                              designation: designation,
                              employee: employeeName,
                              start_shift: start_shift,
                              end_shift: end_shift,
                              shift_date: shift_date),
                        ));
                      },
                      daySelected: selectedDay,
                      isEditing: false,
                    );
                  }));
                },
              ),
            ),
          );
        } else {
          return Container(
            child: Text('Shit happens'),
          );
        }
      },
    );
  }

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

  showSnackBar(context,deletedShift) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text('Shift Deleted!'),
        duration: Duration(seconds: 3),
        action: SnackBarAction(
          label: 'UNDO',
          onPressed: () {
            BlocProvider.of<ShiftsBloc>(context).add(RedoShift(
              deletedShift
            ));
          },
        ),
      )
    );
  }

  Widget _buildShiftContainer({Shift shift}) {
    return Container(
      color: Colors.blueGrey,
      height: 65.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
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
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 17.0),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              GestureDetector(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    child: Icon(Icons.delete),
                    color: Colors.red,
                  ),
                ),
                onTap: () {
                  BlocProvider.of<ShiftsBloc>(context).add(DeleteShift(shift));
                    // hide previous snackbars and show only the current one
                    Scaffold.of(context).hideCurrentSnackBar();
                    showSnackBar(context, shift);
                },
              ),
              GestureDetector(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                child: Icon(Icons.edit),
                color: Colors.yellow.shade700,
              ),
            ),
            onTap: () {
              Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return AddEditShift(
                    onSave: (designation, employeeName, start_shift, end_shift,
                        shift_date) {
                      BlocProvider.of<ShiftsBloc>(context).add(UpdateShift(
                        shift.copyWith(
                          designation: designation,
                          employee: employeeName,
                          start_shift: start_shift,
                          end_shift: end_shift,)
                      ));
                    },
                    daySelected: CalendarWidget.selectedDay,
                    isEditing: true,
                    shift: shift,
                  );
                }));
            },
          )
            ],
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
      onDaySelected: (date, events) {
        setState(() {
          CalendarWidget.selectedDay = _calendarController.selectedDay;
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
