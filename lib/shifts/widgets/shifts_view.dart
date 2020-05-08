import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shifts_repository/shifts_repository.dart';
import 'package:snapshot_test/shifts/blocs/shifts.dart';
import 'package:snapshot_test/shifts/screens/add_edit_shift.dart';
import 'package:snapshot_test/calendar/calendar_widget.dart';

class ShiftsView extends StatelessWidget {
  static const String screenId = 'shifts_view';
  static DateTime shiftCalendarSelectedDay = DateTime.now();

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

