import 'package:employees_repository/employees_repository.dart';
import 'package:flutter/material.dart';
import 'package:snapshot_test/date_events/blocs/date_events.dart';
import 'package:snapshot_test/date_events/blocs/shifts.dart';
import 'package:snapshot_test/date_events/blocs/shifts_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snapshot_test/date_events/screens/add_edit_shift.dart';
import 'package:snapshot_test/date_events/widgets/shifts_view.dart';
import 'package:date_events_repository/date_events_repository.dart';
import 'package:snapshot_test/employee/blocs/employees.dart';

class ShiftCalendarContainer extends StatelessWidget {
  final DateEvent dateEvent;
  final BuildContext scaffoldContext;

  const ShiftCalendarContainer({Key key, this.dateEvent, this.scaffoldContext})
      : super(key: key);

  showSnackBar(context, deletedDateEvent) {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text('Shift Deleted!'),
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
      color: Colors.blueGrey,
      height: 65.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(
                    dateEvent.start_shift != null
                        ? 'Start ${dateEvent.start_shift}'
                        : '',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17.0,
                    ),
                  ),
                  SizedBox(
                    width: 20.0,
                  ),
                  Text(
                    dateEvent.end_shift != null
                        ? 'End ${dateEvent.end_shift}'
                        : '',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17.0,
                    ),
                  ),
                ],
              ),
              Text(
                'Designation: ${dateEvent.designation}',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),
                textAlign: TextAlign.left,
              ),
              Text(
                'Employee: ${dateEvent.employeeName}',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),
                textAlign: TextAlign.left,
              ),
              Visibility(
                visible: false,
                child: Row(
                  children: <Widget>[
                    Text(
                      '${dateEvent.id}',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 17.0),
                      textAlign: TextAlign.left,
                    ),
                  ],
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
                  showSnackBar(scaffoldContext, dateEvent);
                  // delete from the employees busy_map
                   BlocProvider.of<EmployeesBloc>(context)
                            .add(EmployeesBusyMapDateEventRemoved(oldEmployeeId: dateEvent.employeeId, dateTime: dateEvent.dateEvent_date));
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
                  BlocProvider.of<ShiftsBloc>(context).add(ShiftEdited(
                    currentEmployee: currentEmployee,
                    currentDesignation: dateEvent.designation,
                    shiftDate: dateEvent.dateEvent_date,
                    description: dateEvent.description,
                    shiftStart: dateEvent.start_shift,
                    shiftEnd: dateEvent.end_shift,
                    id: dateEvent.id,
                    oldEmployee: currentEmployee,
                  ));

                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return AddEditShift(
                      daySelected: ShiftsView.shiftCalendarSelectedDay,
                      isEditing: true,
                      isShift: true,
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
