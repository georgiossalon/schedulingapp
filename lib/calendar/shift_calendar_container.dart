import 'package:employees_repository/employees_repository.dart';
import 'package:flutter/material.dart';
import 'package:snapshot_test/employee/blocs/ereignises.dart';
import 'package:snapshot_test/employee/screens/add_edit_employee_ereignis.dart';
import 'package:snapshot_test/shifts/blocs/shifts.dart';
import 'package:snapshot_test/shifts/blocs/shifts_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snapshot_test/shifts/screens/add_edit_shift.dart';
import 'package:snapshot_test/shifts/widgets/shifts_view.dart';

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
                    'Start ${ereignis.start_shift}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17.0,
                    ),
                  ),
                  SizedBox(
                    width: 20.0,
                  ),
                  Text(
                    'End ${ereignis.end_shift}',
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
                'Employee: ${ereignis.employee}',
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
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return AddEditEmployeeEreignis(
                      onSave: (
                        description,
                        designation,
                        employee,
                        end_shift,
                        reason,
                        start_shift,
                        shift_date,
                        parentId,
                      ) {
                        BlocProvider.of<EreignisesBloc>(context).add(UpdateEreignis(
                          //todo might have to add the parentId field
                          ereignis.copyWith(
                            description: description,
                            designation: designation,
                            employee: employee,
                            end_shift: end_shift,
                            reason: reason,
                            start_shift: start_shift,
                          ),
                        ));
                      },
                      daySelected: ShiftsView.shiftCalendarSelectedDay,
                      isEditing: true,
                      ereignis: ereignis,
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
