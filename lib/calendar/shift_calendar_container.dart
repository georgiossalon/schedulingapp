import 'package:employees_repository/employees_repository.dart';
import 'package:flutter/material.dart';
import 'package:snapshot_test/employee/blocs/employees.dart';
import 'package:snapshot_test/employee/blocs/ereignises.dart';
import 'package:snapshot_test/employee/screens/add_edit_employee_ereignis.dart';
import 'package:snapshot_test/shifts/blocs/shifts.dart';
import 'package:snapshot_test/shifts/blocs/shifts_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snapshot_test/shifts/screens/add_edit_shift.dart';
import 'package:snapshot_test/shifts/widgets/shifts_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ShiftCalendarContainer extends StatelessWidget {
  final Ereignis ereignis;
  final BuildContext scaffoldContext;

  const ShiftCalendarContainer({Key key, this.ereignis, this.scaffoldContext})
      : super(key: key);

  showSnackBar(context, deletedEreignis) {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text('Shift Deleted!'),
      duration: Duration(seconds: 3),
      action: SnackBarAction(
        label: 'UNDO',
        onPressed: () {
          BlocProvider.of<EreignisesBloc>(context)
              .add(RedoEreignis(deletedEreignis));
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
                    ereignis.start_shift != null
                        ? 'Start ${ereignis.start_shift}'
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
                    ereignis.end_shift != null
                        ? 'End ${ereignis.end_shift}'
                        : '',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17.0,
                    ),
                  ),
                ],
              ),
              Text(
                'Designation: ${ereignis.designation}',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),
                textAlign: TextAlign.left,
              ),
              Text(
                'Employee: ${ereignis.employeeName}',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),
                textAlign: TextAlign.left,
              ),
              Visibility(
                visible: false,
                child: Row(
                  children: <Widget>[
                    Text(
                      '${ereignis.id}',
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
                  BlocProvider.of<EreignisesBloc>(context)
                      .add(DeleteEreignis(ereignis));
                  // hide previous snackbars and show only the current one
                  Scaffold.of(context).hideCurrentSnackBar();
                  showSnackBar(scaffoldContext, ereignis);
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
                  // ! the following snapshot, employee are there for the dropdown
                  DocumentSnapshot snapshot = await Firestore.instance
                      .collection('Employees')
                      .document(ereignis.parentId)
                      .get();
                  Employee oldEmployee = Employee.fromEntity(
                      EmployeeEntity.fromSnapshot(snapshot));
                  // BlocProvider.of<EmployeesBloc>(context).add(LoadEmployees());
                  // ! end

                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return AddEditEmployeeEreignis(
                      onSave: (description,
                          designation,
                          employeeName,
                          end_shift,
                          reason,
                          start_shift,
                          ereignis_date,
                          parentId,
                          oldParentId,
                          changedEmployee,
                          employeeObj) {
                        // if I change the employee then delete and add to
                        // the sub-collection of the new employee
                        if (changedEmployee) {
                          BlocProvider.of<EreignisesBloc>(context)
                              .add(DeleteEreignis(
                            ereignis.copyWith(
                                description: description,
                                designation: designation,
                                employeeName: employeeName,
                                end_shift: end_shift,
                                reason: reason,
                                start_shift: start_shift,
                                parentId: oldParentId),
                          ));
                          BlocProvider.of<EreignisesBloc>(context)
                              .add(AddEreignis(
                            ereignis.copyWith(
                                description: description,
                                designation: designation,
                                employeeName: employeeName,
                                end_shift: end_shift,
                                reason: reason,
                                start_shift: start_shift,
                                parentId: parentId),
                          ));
                          // -- update the busy_map
                          // the employeeObj gets only initialized when I click on the dropdown
                          // if I still choose the same employee I will not be running in here
                          // since I am using and if-statement with the bool changedEmployee
                          Map<DateTime, bool> hbusyMap = employeeObj.busyMap;
                          hbusyMap[ereignis_date] = true;
                          var hMap =
                              EmployeeEntity.changeMapKeyForDocument(hbusyMap);
                          BlocProvider.of<EmployeesBloc>(context)
                              .add(UpdateEmployeeBusyMap(employeeObj.id, hMap));
                          // -- now I have to remove the event from the old employee's busy_map
                          Map<DateTime, bool> hbusyMapOldEmployee =
                              oldEmployee.busyMap;
                          hbusyMapOldEmployee[ereignis_date] = false;
                          var hMapOldEmployee =
                              EmployeeEntity.changeMapKeyForDocument(
                                  hbusyMapOldEmployee);
                          BlocProvider.of<EmployeesBloc>(context).add(
                              UpdateEmployeeBusyMap(
                                  oldEmployee.id, hMapOldEmployee));
                          // -- end
                        } else {
                          //if I only update the values of the shift then update
                          BlocProvider.of<EreignisesBloc>(context)
                              .add(UpdateEreignis(
                            //todo might have to add the parentId field
                            ereignis.copyWith(
                                description: description,
                                designation: designation,
                                employeeName: employeeName,
                                end_shift: end_shift,
                                reason: reason,
                                start_shift: start_shift,
                                parentId: parentId),
                          ));
                        }
                      },
                      daySelected: ShiftsView.shiftCalendarSelectedDay,
                      isEditing: true,
                      isShift: true,
                      ereignis: ereignis,
                      employee: oldEmployee,
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
