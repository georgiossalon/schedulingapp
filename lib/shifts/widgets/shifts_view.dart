// import 'dart:js';

import 'package:employees_repository/employees_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shifts_repository/shifts_repository.dart';
import 'package:snapshot_test/employee/blocs/employees.dart';
import 'package:snapshot_test/employee/blocs/date_events.dart';
import 'package:snapshot_test/employee/screens/add_edit_employee_date_event.dart';
import 'package:snapshot_test/shifts/blocs/shifts.dart';
import 'package:snapshot_test/shifts/screens/add_edit_shift.dart';
import 'package:snapshot_test/calendar/calendar_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
                // BlocProvider.of<EmployeesBloc>(context)
                //     .add(LoadEmployeesWithGivenDesignation(
                //   designation: 'open',
                //   date: shiftCalendarSelectedDay,
                // ));
                // designation = 'open';

                BlocProvider.of<DateEventsBloc>(context)
                    .add(LoadDesignationsForShift());

                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return AddEditEmployeeDateEvent(
                    onSave: (description,
                        designation,
                        employeeName,
                        end_shift,
                        reason,
                        start_shift,
                        dateEvent_date,
                        parentId,
                        oldParentId,
                        changedEmployee,
                        employeeObj) {
                      BlocProvider.of<DateEventsBloc>(context).add(AddDateEvent(
                        DateEvent(
                            description: description,
                            designation: designation,
                            employeeName: employeeName,
                            end_shift: end_shift,
                            reason: reason,
                            start_shift: start_shift,
                            dateEvent_date: dateEvent_date,
                            parentId: parentId),
                      ));
                      // -- adding the new event into the busy map
                      Map<DateTime, bool> hbusyMap = employeeObj.busyMap;
                      hbusyMap[dateEvent_date] = true;
                      var hMap =
                          EmployeeEntity.changeMapKeyForDocument(hbusyMap);
                      BlocProvider.of<EmployeesBloc>(context)
                          .add(UpdateEmployeeBusyMap(employeeObj.id, hMap));
                      // -- end
                    },
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
