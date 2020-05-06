import 'package:flutter/material.dart';
import 'package:shifts_repository/shifts_repository.dart';
import 'package:snapshot_test/blocs/blocs.dart';
import 'package:snapshot_test/shifts/blocs/shifts_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snapshot_test/shifts/screens/add_edit_shift.dart';
import 'package:snapshot_test/calendar/shift_calendar_widget.dart';

class BuildShiftContainer extends StatelessWidget {
  final Shift shift;
  final BuildContext scaffoldContext;

  const BuildShiftContainer({Key key,this.shift,this.scaffoldContext}) : super(key: key);

  showSnackBar(context, deletedShift) {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text('Shift Deleted!'),
      duration: Duration(seconds: 3),
      action: SnackBarAction(
        label: 'UNDO',
        onPressed: () {
          BlocProvider.of<ShiftsBloc>(context).add(RedoShift(deletedShift));
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
                    'Start ${shift.start_shift}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17.0,
                    ),
                  ),
                  SizedBox(
                    width: 20.0,
                  ),
                  Text(
                    'End ${shift.end_shift}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17.0,
                    ),
                  ),
                ],
              ),
              Text(
                'Designation: ${shift.designation}',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),
                textAlign: TextAlign.left,
              ),
              Text(
                'Employee: ${shift.employee}',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),
                textAlign: TextAlign.left,
              ),
              Visibility(
                visible: false,
                child: Row(
                  children: <Widget>[
                    Text(
                      '${shift.id}',
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
                  BlocProvider.of<ShiftsBloc>(context).add(DeleteShift(shift));
                  // hide previous snackbars and show only the current one
                  Scaffold.of(context).hideCurrentSnackBar();
                  showSnackBar(scaffoldContext, shift);
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
                    return AddEditShift(
                      onSave: (designation, employeeName, start_shift,
                          end_shift, shift_date) {
                        BlocProvider.of<ShiftsBloc>(context)
                            .add(UpdateShift(shift.copyWith(
                          designation: designation,
                          employee: employeeName,
                          start_shift: start_shift,
                          end_shift: end_shift,
                        )));
                      },
                      daySelected: ShiftCalendarWidget.selectedDay,
                      isEditing: true,
                      shift: shift,
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