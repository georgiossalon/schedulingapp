import 'package:employees_repository/employees_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:snapshot_test/date_events/blocs/date_events.dart';
import 'package:snapshot_test/date_events/blocs/shifts.dart';
import 'package:snapshot_test/calendar/calendar_widget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:date_events_repository/date_events_repository.dart';
import 'package:snapshot_test/date_events/screens/add_edit_dayoff.dart';
import 'package:snapshot_test/date_events/screens/add_edit_shift.dart';

class EmployeeDateEventScreen extends StatelessWidget {
  //! Rolly ask him about this
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
          return SafeArea(
            child: Scaffold(
              appBar: AppBar(
                title: Text('Employee Availability'),
              ),
              body: CalendarWidget(
                map: dateEventListToCalendarMap(currentEmployeesDateEvents),
                isShiftsView: false,
              ),
              floatingActionButton: SpeedDial(
                animatedIcon: AnimatedIcons.add_event,
                children: [
                  SpeedDialChild(
                      child: Icon(FontAwesomeIcons.briefcase),
                      label: 'Add Shift',
                      backgroundColor: Colors.green.shade400,
                      onTap: () {
                        BlocProvider.of<ShiftsBloc>(context)
                            .add(NewShiftEmployeeSpecificCreated(
                          employee: employee,
                          shiftDate: employeeDateEventSelectedDay,
                        ));
                        //todo do not allow to add an event on a day where there is a registered event
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return AddEditShift(
                            daySelected: employeeDateEventSelectedDay,
                            isEditing: false,
                            // isShift: true,
                          );
                        }));
                      }),
                  SpeedDialChild(
                      child: Icon(FontAwesomeIcons.couch),
                      label: 'Add Day Off',
                      backgroundColor: Colors.grey,
                      onTap: () {
                        BlocProvider.of<ShiftsBloc>(context).add(
                            NewDayOffCreated(
                                employeeId: employee.id,
                                employeeName: employee.name,
                                dayOffDate: employeeDateEventSelectedDay));
                        //todo add day offs while using the same AddEditDateEvent screen
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return AddEditDayOff(
                            daySelected: employeeDateEventSelectedDay,
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
        } else {
          return Container(child: Text('ups'),);
        }
      },
    );
  }
}
