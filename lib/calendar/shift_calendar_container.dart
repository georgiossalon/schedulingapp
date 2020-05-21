import 'package:employees_repository/employees_repository.dart';
import 'package:flutter/material.dart';
import 'package:snapshot_test/employee/blocs/employees.dart';
import 'package:snapshot_test/date_events/blocs/date_events.dart';
import 'package:snapshot_test/employee/screens/add_edit_employee_date_event.dart';
import 'package:snapshot_test/date_events/blocs/shifts.dart';
import 'package:snapshot_test/date_events/blocs/shifts_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snapshot_test/date_events/screens/add_edit_shift.dart';
import 'package:snapshot_test/date_events/widgets/shifts_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_events_repository/date_events_repository.dart';

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
                onTap: () async {
                  // todo the following should be in the repository. I should not have Firestore.instance in the UI
                  //todo: check why I am fetching an employee from firestore when I already have this passed within this widget
                  // ! the following snapshot, employee are there for the dropdown
                  // DocumentSnapshot snapshot = await Firestore.instance
                  //     .collection('Employees')
                  //     .document(dateEvent.parentId)
                  //     .get();
                  // Employee oldEmployee = Employee.fromEntity(
                  //     EmployeeEntity.fromSnapshot(snapshot));
                  // BlocProvider.of<EmployeesBloc>(context).add(LoadEmployees());
                  // ! end

                  BlocProvider.of<ShiftsBloc>(context).add(ShiftEdited(
                    currentEmployee: Employee(
                      id: dateEvent.employeeId,
                      name: dateEvent.employeeName,
                    ),
                    currentDesignation: dateEvent.designation,
                    shiftDate: dateEvent.dateEvent_date,
                    description: dateEvent.description,
                    shiftStart: dateEvent.start_shift,
                    shiftEnd: dateEvent.end_shift,
                  ));

                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return AddEditEmployeeDateEvent(
                      // onSave: (description,
                      //     designation,
                      //     employeeName,
                      //     end_shift,
                      //     reason,
                      //     start_shift,
                      //     dateEvent_date,
                      //     employeeId,) {
                      //     BlocProvider.of<DateEventsBloc>(context)
                      //         .add(UpdateDateEvent(
                      //       //todo might have to add the parentId field
                      //       dateEvent.copyWith(
                      //           description: description,
                      //           designation: designation,
                      //           employeeName: employeeName,
                      //           end_shift: end_shift,
                      //           reason: reason,
                      //           start_shift: start_shift,
                      //           parentId: employeeId),
                      //     ));
                      // },
                      daySelected: ShiftsView.shiftCalendarSelectedDay,
                      isEditing: true,
                      isShift: true,
                      dateEvent: dateEvent,
                      employee: Employee(
                        name: dateEvent.employeeName,
                        id: dateEvent.employeeId,
                      ),
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
