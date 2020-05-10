import 'package:employees_repository/employees_repository.dart';
import 'package:flutter/material.dart';
import 'package:snapshot_test/employee/blocs/employees.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snapshot_test/employee/screens/add_edit_employee_ereignis.dart';
import 'package:snapshot_test/shifts/widgets/shifts_view.dart';

class EreignisCalendarContainer extends StatelessWidget {
  final Ereignis ereignis;
  final BuildContext scaffoldContext;

  const EreignisCalendarContainer({Key key, this.ereignis, this.scaffoldContext}) : super(key: key);

  showSnackBar(context, deletedEreignis) {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text('ereignis Deleted!'),
      duration: Duration(seconds: 3),
      action: SnackBarAction(
        label: 'UNDO',
        onPressed: () {
          BlocProvider.of<EmployeesBloc>(context).add(RedoEmployee(deletedEreignis));
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
                'Reason ${ereignis.reason}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17.0,
                ),
              ),
              Text(
                'Description ${ereignis.description}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17.0,
                ),
              ),
              Row(
                children: <Widget>[
                  Text(
                    ereignis.start_shift != null 
                        ? 'start_shift ${ereignis.start_shift}'
                        : '',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17.0,
                    ),
                  ),
                   SizedBox(width: 20.0,),
                  Text(
                    ereignis.end_shift != null 
                        ? 'end_shift ${ereignis.end_shift}'
                        : '',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17.0,
                    ),
                  ),
                ],
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
                  //todo need ereignis Bloc
                  //todo also at the shift calendar page, I should link the ereignis
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
                  //todo create ereignis add/edit screen
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    // return AddEditEmployeeEreignis(
                    //   onSave: (reason, description, selectedDay,
                    //       ) {
                    //         //todo use the ereignis bloc
                    //     // BlocProvider.of<ShiftsBloc>(context)
                    //     //     .add(UpdateShift(shift.copyWith(
                    //     //   designation: designation,
                    //     //   employee: employeeName,
                    //     //   start_shift: start_shift,
                    //     //   end_shift: end_shift,
                    //     // )));
                    //   },
                    //   daySelected: ShiftsView.shiftCalendarSelectedDay,
                    //   isEditing: true,
                    //   ereignis: ereignis,
                    // );
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