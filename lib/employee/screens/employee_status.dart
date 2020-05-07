import 'package:employees_repository/employees_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:shifts_repository/shifts_repository.dart';
import 'package:snapshot_test/employee/blocs/statuses.dart';
import 'package:snapshot_test/employee/screens/add_edit_employee_status.dart';
import 'package:snapshot_test/main.dart';
import 'package:snapshot_test/shifts/blocs/shifts.dart';
import 'package:snapshot_test/shifts/screens/add_edit_shift.dart';
import 'package:snapshot_test/calendar/calendar_widget.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmployeeStatus extends StatelessWidget {
  //todo cancel the subscription for the employees status when clicking on the 
  //todo... arrow of the top left corner of the screen

  static const String screenId = 'employee_availability';
  final Employee employee;
  static DateTime employeeStatusSelectedDay = DateTime.now();

  const EmployeeStatus({Key key, this.employee}) : super(key: key);

  static Map<DateTime, List<dynamic>> statusListToCalendarMap(
      List<Status> currentWeekStatus) {
    Map<DateTime, List<dynamic>> hMap = new Map<DateTime, List<dynamic>>();
    if (currentWeekStatus != null) {
      for (Status status in currentWeekStatus) {
        //!! only one event is allowed for the availability calendar
        //!! still I use a List. Change this in the future?
        hMap[status.status_date] = [status];
      }
    }
    return hMap;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StatusesBloc, StatusesState>(
      builder: (context, state) {
        if (state is StatusesLoaded) {
          List<Status> currentEmployeesStatuses = state.statuses;
          //todo take only the info for the given employee
          return SafeArea(
            child: Scaffold(
              appBar: AppBar(
                title: Text('Employee Availability'),
              ),
              body: CalendarWidget(
                map: statusListToCalendarMap(currentEmployeesStatuses),
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
                              //todo: add the shift to the employees statuses (Bloc)
                              BlocProvider.of<ShiftsBloc>(context).add(AddShift(
                                Shift(
                                  designation: designation,
                                  employee: employeeName,
                                  start_shift: start_shift,
                                  end_shift: end_shift,
                                  shift_date: shift_date,
                                ),
                              ));
                              BlocProvider.of<StatusesBloc>(context).add(AddStatus(
                                Status(
                                  reason: 'shift',
                                  description: designation,
                                  start_shift: start_shift,
                                  end_shift: end_shift,
                                  status_date: shift_date
                                ), employee.id));
                            },
                            daySelected: employeeStatusSelectedDay,
                            isEditing: false,
                          );
                        }));
                      }),
                  SpeedDialChild(
                      child: Icon(FontAwesomeIcons.couch),
                      label: 'Add status',
                      backgroundColor: Colors.grey,
                      onTap: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return AddEditEmployeeStatus(
                            onSave: (reason, description, selectedDay) {
                              BlocProvider.of<StatusesBloc>(context).add(
                                  AddStatus(
                                      Status(
                                          reason: reason,
                                          description: description,
                                          status_date: selectedDay),
                                      employee.id));
                            },
                            daySelected: employeeStatusSelectedDay,
                            isEditing: false,
                          );
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
