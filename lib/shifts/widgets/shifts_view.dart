import 'package:employees_repository/employees_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shifts_repository/shifts_repository.dart';
import 'package:snapshot_test/employee/blocs/statuses.dart';
import 'package:snapshot_test/shifts/blocs/shifts.dart';
import 'package:snapshot_test/shifts/screens/add_edit_shift.dart';
import 'package:snapshot_test/calendar/calendar_widget.dart';

class ShiftsView extends StatelessWidget {
  static const String screenId = 'shifts_view';
  static DateTime shiftCalendarSelectedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StatusesBloc, StatusesState>(
      builder: (context, state) {
        if (state is StatusesLoading) {
          return Padding(
              padding: EdgeInsets.all(20.0),
              child: Container(
                child: Text(
                  'Loading',
                  style: TextStyle(fontSize: 20.0),
                ),
              ));
        } else if (state is ShiftStatusesLoaded) {
          //todo this should only load after the shift statuses are read from firestore
          final shiftsList = state.statuses;
          Map<DateTime, List<Status>> map = ShiftsView.shiftListToCalendarEventMap(shiftsList);
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
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return AddEditShift(
                    onSave: (
                      designation,
                      employeeName,
                      start_shift,
                      end_shift,
                      shift_date,
                    ) {
                      //todo add this also to the status of the chosen employee
                      BlocProvider.of<ShiftsBloc>(context).add(AddShift(
                        Shift(
                            designation: designation,
                            employee: employeeName,
                            start_shift: start_shift,
                            end_shift: end_shift,
                            shift_date: shift_date),
                      ));
                    },
                    daySelected: shiftCalendarSelectedDay,
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

  static Map<DateTime, List<Status>> shiftListToCalendarEventMap(
      List<Status> shiftList) {
    Map<DateTime, List<Status>> map = {};
    for (int i = 0; i < shiftList.length; i++) {
      //todo maybe map status to a shift object?
      //todo... it maybe though to much hustle to put it back to the StatusBloc (add/edit/delete/)
      Status shift = shiftList[i];
      DateTime shiftDateTime = shift.status_date;
      if (map[shiftDateTime] == null) {
        // creating a new List and passing a widget
        map[shiftDateTime] = [shift];
      } else {
        List<Status> helpList = map[shiftDateTime];
        helpList.add(shift);
      }
    }
    return map;
  }
}

