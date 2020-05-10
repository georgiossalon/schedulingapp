import 'package:employees_repository/employees_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:shifts_repository/shifts_repository.dart';
import 'package:snapshot_test/employee/blocs/ereignises.dart';
import 'package:snapshot_test/employee/screens/add_edit_employee_ereignis.dart';
import 'package:snapshot_test/main.dart';
import 'package:snapshot_test/shifts/blocs/shifts.dart';
import 'package:snapshot_test/shifts/screens/add_edit_shift.dart';
import 'package:snapshot_test/calendar/calendar_widget.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmployeeEreignis extends StatelessWidget {
  //todo cancel the subscription for the employees ereignis when clicking on the 
  //todo... arrow of the top left corner of the screen

  static const String screenId = 'employee_availability';
  final Employee employee;
  static DateTime employeeEreignisSelectedDay = DateTime.now();

  const EmployeeEreignis({Key key, this.employee}) : super(key: key);

  static Map<DateTime, List<dynamic>> ereignisListToCalendarMap(
      List<Ereignis> currentWeekEreignis) {
    Map<DateTime, List<dynamic>> hMap = new Map<DateTime, List<dynamic>>();
    if (currentWeekEreignis != null) {
      for (Ereignis ereignis in currentWeekEreignis) {
        //!! only one event is allowed for the availability calendar
        //!! still I use a List. Change this in the future?
        hMap[ereignis.ereignis_date] = [ereignis];
      }
    }
    return hMap;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EreignisesBloc, EreignisesState>(
      builder: (context, state) {
        if (state is EreignisesLoaded) {
          List<Ereignis> currentEmployeesEreignises = state.ereignises;
          //todo take only the info for the given employee
          return SafeArea(
            child: Scaffold(
              appBar: AppBar(
                title: Text('Employee Availability'),
              ),
              body: CalendarWidget(
                map: ereignisListToCalendarMap(currentEmployeesEreignises),
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
                              //todo: add the shift to the employees ereignises (Bloc)
                              BlocProvider.of<ShiftsBloc>(context).add(AddShift(
                                Shift(
                                  designation: designation,
                                  employee: employeeName,
                                  start_shift: start_shift,
                                  end_shift: end_shift,
                                  shift_date: shift_date,
                                ),
                              ));
                              BlocProvider.of<EreignisesBloc>(context).add(AddEreignis(
                                Ereignis(
                                  reason: 'shift',
                                  description: designation,
                                  start_shift: start_shift,
                                  end_shift: end_shift,
                                  ereignis_date: shift_date
                                )));
                            },
                            daySelected: employeeEreignisSelectedDay,
                            isEditing: false,
                          );
                        }));
                      }),
                  SpeedDialChild(
                      child: Icon(FontAwesomeIcons.couch),
                      label: 'Add ereignis',
                      backgroundColor: Colors.grey,
                      onTap: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          // return AddEditEmployeeEreignis(
                          //   onSave: (reason, description, selectedDay) {
                          //     BlocProvider.of<EreignisesBloc>(context).add(
                          //         AddEreignis(
                          //             Ereignis(
                          //                 reason: reason,
                          //                 description: description,
                          //                 ereignis_date: selectedDay),
                          //             employee.id));
                          //   },
                          //   daySelected: employeeEreignisSelectedDay,
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
