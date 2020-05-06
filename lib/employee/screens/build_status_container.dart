import 'package:employees_repository/employees_repository.dart';
import 'package:flutter/material.dart';
import 'package:snapshot_test/employee/blocs/employees.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snapshot_test/employee/screens/add_edit_employee_status.dart';
import 'package:snapshot_test/calendar/shift_calendar_widget.dart';

class BuildUnavailabilityContainer extends StatelessWidget {
  final Status status;
  final BuildContext scaffoldContext;

  const BuildUnavailabilityContainer({Key key, this.status, this.scaffoldContext}) : super(key: key);

  showSnackBar(context, deletedUnavailability) {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text('status Deleted!'),
      duration: Duration(seconds: 3),
      action: SnackBarAction(
        label: 'UNDO',
        onPressed: () {
          BlocProvider.of<EmployeesBloc>(context).add(RedoEmployee(deletedUnavailability));
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
              Text(
                'Reason ${status.reason}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17.0,
                ),
              ),
              Text(
                'Description ${status.description}',
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
                  //todo need status Bloc
                  // BlocProvider.of<EmployeesBloc>(context).add(DeleteEmployee(shift));
                  // // hide previous snackbars and show only the current one
                  // Scaffold.of(context).hideCurrentSnackBar();
                  // showSnackBar(scaffoldContext, shift);
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
                  //todo create status add/edit screen
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return AddEditEmployeeUnavailability(
                      onSave: (reason, description, selectedDay,
                          ) {
                            //todo use the status bloc
                        // BlocProvider.of<ShiftsBloc>(context)
                        //     .add(UpdateShift(shift.copyWith(
                        //   designation: designation,
                        //   employee: employeeName,
                        //   start_shift: start_shift,
                        //   end_shift: end_shift,
                        // )));
                      },
                      daySelected: ShiftCalendarWidget.selectedDay,
                      isEditing: true,
                      status: status,
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