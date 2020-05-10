import 'package:employees_repository/employees_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shifts_repository/shifts_repository.dart';
import 'package:snapshot_test/employee/blocs/ereignises.dart';
import 'package:snapshot_test/employee/screens/add_edit_employee_ereignis.dart';
import 'package:snapshot_test/shifts/blocs/shifts.dart';
import 'package:snapshot_test/shifts/screens/add_edit_shift.dart';
import 'package:snapshot_test/calendar/calendar_widget.dart';

class ShiftsView extends StatelessWidget {
  static const String screenId = 'shifts_view';
  static DateTime shiftCalendarSelectedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EreignisesBloc, EreignisesState>(
      builder: (context, state) {
        if (state is EreignisesLoading) {
          return Padding(
              padding: EdgeInsets.all(20.0),
              child: Container(
                child: Text(
                  'Loading',
                  style: TextStyle(fontSize: 20.0),
                ),
              ));
        } else if (state is ShiftEreignisesLoaded) {
          //todo this should only load after the shift ereignises are read from firestore
          final shiftsList = state.ereignises;
          Map<DateTime, List<Ereignis>> map = ShiftsView.shiftListToCalendarEventMap(shiftsList);
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
                  return AddEditEmployeeEreignis(
                    onSave: (
                      description,
                      designation,
                      employee,
                      end_shift,
                      reason,
                      start_shift,
                      ereignis_date,
                      parentId
                    ) {
                      //todo add this also to the ereignis of the chosen employee
                      BlocProvider.of<EreignisesBloc>(context).add(AddEreignis(
                        Ereignis(
                          description: description,
                            designation: designation,
                            employee: employee,
                            end_shift: end_shift,
                            reason: reason,
                            start_shift: start_shift,
                            ereignis_date: ereignis_date,
                            parentId: parentId),
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

  static Map<DateTime, List<Ereignis>> shiftListToCalendarEventMap(
      List<Ereignis> shiftList) {
    Map<DateTime, List<Ereignis>> map = {};
    for (int i = 0; i < shiftList.length; i++) {
      //todo maybe map ereignis to a shift object?
      //todo... it maybe though to much hustle to put it back to the EreignisBloc (add/edit/delete/)
      Ereignis shift = shiftList[i];
      DateTime shiftDateTime = shift.ereignis_date;
      if (map[shiftDateTime] == null) {
        // creating a new List and passing a widget
        map[shiftDateTime] = [shift];
      } else {
        List<Ereignis> helpList = map[shiftDateTime];
        helpList.add(shift);
      }
    }
    return map;
  }
}

