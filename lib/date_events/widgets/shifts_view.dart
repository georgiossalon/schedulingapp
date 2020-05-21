import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:date_events_repository/date_events_repository.dart';
import 'package:snapshot_test/date_events/blocs/date_events.dart';
import 'package:snapshot_test/date_events/blocs/shifts.dart';
import 'package:snapshot_test/calendar/calendar_widget.dart';
import 'package:snapshot_test/date_events/screens/add_edit_date_event.dart';

class ShiftsView extends StatelessWidget {
  static const String screenId = 'shifts_view';
  static DateTime shiftCalendarSelectedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DateEventsBloc, DateEventsState>(
      builder: (context, state) {
        if (state is DateEventsLoading) {
          return Padding(
              padding: EdgeInsets.all(20.0),
              child: Container(
                child: Text(
                  'Loading',
                  style: TextStyle(fontSize: 20.0),
                ),
              ));
        } else if (state is ShiftDateEventsLoaded) {
          //todo this should only load after the shift dateEvents are read from firestore
          final shiftsList = state.dateEvents;
          Map<DateTime, List<DateEvent>> map =
              ShiftsView.shiftListToCalendarEventMap(shiftsList);
          return Scaffold(
            appBar: AppBar(
              title: Text('Shifts'),
            ),
            body: CalendarWidget(
              map: map,
              isShift: true,
            ),
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.add),
              backgroundColor: Colors.pink,
              onPressed: () {
                
                BlocProvider.of<ShiftsBloc>(context).add(NewShiftCreated(
                  shiftDate: shiftCalendarSelectedDay,
                ));

                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return AddEditDateEvent(
                    daySelected: shiftCalendarSelectedDay,
                    isShift: true,
                    isEditing: false,
                  );
                }));
              },
            ),
          );
        } else {
          return Container(
            child: Text('Ups Error'),
          );
        }
      },
    );
  }

  static Map<DateTime, List<DateEvent>> shiftListToCalendarEventMap(
      List<DateEvent> shiftList) {
    Map<DateTime, List<DateEvent>> map = {};
    for (int i = 0; i < shiftList.length; i++) {
      //todo maybe map dateEvent to a shift object?
      //todo... it maybe though to much hustle to put it back to the DateEventBloc (add/edit/delete/)
      DateEvent shift = shiftList[i];
      DateTime shiftDateTime = shift.dateEvent_date;
      if (map[shiftDateTime] == null) {
        // creating a new List and passing a widget
        map[shiftDateTime] = [shift];
      } else {
        List<DateEvent> helpList = map[shiftDateTime];
        helpList.add(shift);
      }
    }
    return map;
  }
}
