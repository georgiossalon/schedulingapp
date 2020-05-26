import 'package:date_events_repository/date_events_repository.dart';
import 'package:employees_repository/employees_repository.dart';
import 'package:flutter/material.dart';
import 'package:snapshot_test/date_events/blocs/date_events.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snapshot_test/date_events/blocs/shifts.dart';
import 'package:snapshot_test/date_events/screens/add_edit_dayoff.dart';
import 'package:snapshot_test/employee/blocs/employees.dart';
import 'package:snapshot_test/employee/screens/employee_date_event.dart';

class CalendarDayOffContainer extends StatelessWidget {
  final DateEvent dateEvent;
  final BuildContext scaffoldContext;
  final bool isShiftsView;

  const CalendarDayOffContainer({
    Key key,
    @required this.dateEvent,
    @required this.scaffoldContext,
    @required this.isShiftsView,
  }) : super(key: key);

  //! Rolly: How should I implement this snackBar?
  showSnackBar(context, deletedDateEvent) {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text('Day Off Deleted!'),
      duration: Duration(seconds: 3),
      action: SnackBarAction(
        label: 'UNDO',
        onPressed: () {
          BlocProvider.of<DateEventsBloc>(context)
              .add(RedoDateEvent(deletedDateEvent));
          // add in employees busy_map
          EmployeeDateEvent employeeDateEvent = EmployeeDateEvent(
            designation: dateEvent.description,
            dateEvent_date: dateEvent.dateEvent_date,
            description: dateEvent.description,
            employeeId: dateEvent.employeeId,
            employeeName: dateEvent.employeeName,
            end_shift: dateEvent.end_shift,
            id: dateEvent.id,
            reason: dateEvent.reason,
            start_shift: dateEvent.start_shift,
          );
          BlocProvider.of<EmployeesBloc>(context)
              .add(UpdateEmployeeBusyMap(employeeDateEvent: employeeDateEvent));
        },
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.pink.shade100,
      height: 80.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Day Off',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17.0,
                ),
              ),
              Text(
                'Description: ${dateEvent.description}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17.0,
                ),
              ),
              Text(
                'Employee: ${dateEvent.employeeName}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17.0,
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              GestureDetector(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    child: Icon(Icons.delete),
                    color: Colors.red,
                  ),
                ),
                onTap: () {
                  BlocProvider.of<DateEventsBloc>(context)
                      .add(DeleteDateEvent(dateEvent));
                  // hide previous snackbars and show only the current one
                  Scaffold.of(context).hideCurrentSnackBar();
                  //!Rolly: how to implement the snackBar witout passing the
                  //! scaffoldContext? This should somehow work with the BlocListener?
                  //todo use BlocListener instead of passing the context

                  showSnackBar(scaffoldContext, dateEvent);
                  BlocProvider.of<EmployeesBloc>(context)
                      .add(EmployeesBusyMapDateEventRemoved(
                          oldEmployee: Employee(
                            id: dateEvent.employeeId,
                            name: dateEvent.employeeName,
                          ),
                          oldEmployeeName: dateEvent.employeeName,
                          dateTime: dateEvent.dateEvent_date));
                },
              ),
              GestureDetector(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    child: Icon(Icons.edit),
                    color: Colors.yellow.shade700,
                  ),
                ),
                onTap: () {
                  Employee currentEmployee = Employee(
                    id: dateEvent.employeeId,
                    name: dateEvent.employeeName,
                  );
                  BlocProvider.of<ShiftsBloc>(context).add(DayOffEdited(
                    employeeId: dateEvent.employeeId,
                    dayOffDate: dateEvent.dateEvent_date,
                    description: dateEvent.description,
                    id: dateEvent.id,
                  ));

                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return AddEditDayOff(
                      daySelected: EmployeeDateEventScreen.employeeDateEventSelectedDay,
                      isEditing: true,
                      dateEvent: dateEvent,
                    );
                  }));
                },
              )
            ],
          ),
        ],
      ),
    );
  }
}
