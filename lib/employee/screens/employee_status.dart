import 'package:employees_repository/employees_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:shifts_repository/shifts_repository.dart';
import 'package:snapshot_test/employee/blocs/statuses.dart';
import 'package:snapshot_test/employee/screens/add_edit_employee_status.dart';
import 'package:snapshot_test/shifts/blocs/shifts.dart';
import 'package:snapshot_test/shifts/screens/add_edit_shift.dart';
import 'package:snapshot_test/calendar/calendar_widget.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmployeeAvailability extends StatelessWidget {
  static const String screenId = 'employee_availability';
  final Employee employee;
  static DateTime selectedDay = DateTime.now();

  const EmployeeAvailability({Key key, this.employee}) : super(key: key);

  static Map<DateTime, List<dynamic>> unavailabilityListToCalendarMap(
      List<Status> currentWeekUnavailability) {
    Map<DateTime, List<dynamic>> hMap = new Map<DateTime, List<dynamic>>();
    if (currentWeekUnavailability != null) {
      for (Status status in currentWeekUnavailability) {
        //!! only one event is allowed for the availability calendar
        //!! still I use a List. Change this in the future?
        hMap[status.statusDate] = [status];
      }
    }
    return hMap;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Employee Availability'),
        ),
        body: CalendarWidget(
          selectedDay: selectedDay,
          map: unavailabilityListToCalendarMap(
              employee.currentWeekUnavailability),
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
                        //todo: add the shift to the employees unavailabilities (Bloc)
                        BlocProvider.of<ShiftsBloc>(context).add(AddShift(
                          Shift(
                            designation: designation,
                            employee: employeeName,
                            start_shift: start_shift,
                            end_shift: end_shift,
                            shift_date: shift_date,
                          ),
                        ));
                      },
                      daySelected: selectedDay,
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
                    return AddEditEmployeeUnavailability(
                      onSave: (reason, description, selectedDay) {
                        //todo add status bloc
                        // BlocProvider.of<Employee(context)
                        BlocProvider.of<UnavailabilitiesBloc>(context).add(
                            AddStatus(
                                Status(
                                    reason: reason,
                                    description: description,
                                    statusDate: selectedDay),
                                employee));
                      },
                      daySelected: selectedDay,
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
}
