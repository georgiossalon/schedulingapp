import 'package:employees_repository/employees_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:snapshot_test/date_events/blocs/date_events.dart';
import 'package:snapshot_test/employee/screens/add_edit_employee_date_event.dart';
import 'package:snapshot_test/main.dart';
import 'package:snapshot_test/date_events/blocs/shifts.dart';
import 'package:snapshot_test/date_events/screens/add_edit_shift.dart';
import 'package:snapshot_test/calendar/calendar_widget.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:date_events_repository/date_events_repository.dart';


class EmployeeDateEventScreen extends StatelessWidget {
  //todo cancel the subscription for the employees dateEvent when clicking on the
  //todo... arrow of the top left corner of the screen

  static const String screenId = 'employee_availability';
  final Employee employee;
  static DateTime employeeDateEventSelectedDay = DateTime.now();

  const EmployeeDateEventScreen({Key key, this.employee}) : super(key: key);

  static Map<DateTime, List<dynamic>> dateEventListToCalendarMap(
      List<DateEvent> currentWeekDateEvent) {
    Map<DateTime, List<dynamic>> hMap = new Map<DateTime, List<dynamic>>();
    if (currentWeekDateEvent != null) {
      for (DateEvent dateEvent in currentWeekDateEvent) {
        //!! only one event is allowed for the availability calendar
        //!! still I use a List. Change this in the future?
        hMap[dateEvent.dateEvent_date] = [dateEvent];
      }
    }
    return hMap;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DateEventsBloc, DateEventsState>(
      builder: (context, state) {
        if (state is DateEventsLoading) {
          return Container(
            child: Text('Loading'),
          );
        } else if (state is DateEventsLoaded) {
          List<DateEvent> currentEmployeesDateEvents = state.dateEvents;
          //todo take only the info for the given employee
          return SafeArea(
            child: Scaffold(
              appBar: AppBar(
                title: Text('Employee Availability'),
              ),
              body: CalendarWidget(
                map: dateEventListToCalendarMap(currentEmployeesDateEvents),
                isShift: false,
              ),
              floatingActionButton: SpeedDial(
                animatedIcon: AnimatedIcons.add_event,
                children: [
                  SpeedDialChild(
                      child: Icon(FontAwesomeIcons.briefcase),
                      label: 'Add Shift',
                      backgroundColor: Colors.green.shade400,
                      onTap: () {
                        //todo do not allow to add an event on a day where there is a registered event
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return AddEditShift(
                            onSave: (
                              designation,
                              //todo the employee name field should be assigned from the chosen employee
                              employeeName,
                              start_shift,
                              end_shift,
                              shift_date,
                            ) {
                              //todo: add the shift to the employees dateEvents (Bloc)
                              // BlocProvider.of<ShiftsBloc>(context).add(AddShift(
                              //   Shift(
                              //     designation: designation,
                              //     employee: employeeName,
                              //     start_shift: start_shift,
                              //     end_shift: end_shift,
                              //     shift_date: shift_date,
                              //   ),
                              // ));
                              // BlocProvider.of<DateEventsBloc>(context).add(
                              //     AddDateEvent(DateEvent(
                              //         reason: 'shift',
                              //         description: designation,
                              //         start_shift: start_shift,
                              //         end_shift: end_shift,
                              //         dateEvent_date: shift_date)));
                            },
                            daySelected: employeeDateEventSelectedDay,
                            isEditing: false,
                          );
                        }));
                      }),
                  SpeedDialChild(
                      child: Icon(FontAwesomeIcons.couch),
                      label: 'Add dateEvent',
                      backgroundColor: Colors.grey,
                      onTap: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          // return AddEditEmployeeDateEvent(
                          //   onSave: (reason, description, selectedDay) {
                          //     BlocProvider.of<DateEventsBloc>(context).add(
                          //         AddDateEvent(
                          //             DateEvent(
                          //                 reason: reason,
                          //                 description: description,
                          //                 dateEvent_date: selectedDay),
                          //             employee.id));
                          //   },
                          //   daySelected: employeeDateEventSelectedDay,
                          //   isEditing: false,
                          // );
                        }));
                      })
                ],
                child: Icon(Icons.add),
                backgroundColor: Colors.pink,
              ),
            ),
          );
        }
      },
    );
  }
}
