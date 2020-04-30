import 'package:employees_repository/employees_repository.dart';
import 'package:flutter/material.dart';
import 'package:snapshot_test/blocs/employees/employees.dart';
import 'package:snapshot_test/screens/add_edit_employee.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//!! Maybe stateful?
class EmployeeContainer extends StatelessWidget {
  final Employee employee;
  final BuildContext scaffoldContext;

  const EmployeeContainer({Key key, this.employee, this.scaffoldContext}) : super(key: key);

  showSnackBar(context, deletedEmployee) {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text('Employee Deleted!'),
      duration: Duration(seconds: 3),
      action: SnackBarAction(
        label: 'UNDO',
        onPressed: () {
          BlocProvider.of<EmployeesBloc>(context).add(RedoEmployee(deletedEmployee));
        },
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(10.0),
      child: Card(
        color: Colors.blueGrey.shade50,
        elevation: 5.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.all(5.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    width: 55.0,
                    height: 55.0,
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(
                          'https://m.media-amazon.com/images/M/MV5BMTcxOTk4NzkwOV5BMl5BanBnXkFtZTcwMDE3MTUzNA@@._V1_.jpg'),
                    ),
                  ),
                  SizedBox(width: 25.0),
                  Column(
                    children: <Widget>[
                      Text(
                        employee.name,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        employee.designation,
                        style: TextStyle(color: Colors.grey),
                      )
                    ],
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  //Availability
                  Expanded(
                                      child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(10.0),
                      child: FlatButton(
                        onPressed: () {
                          //todo implement the availability on click
                        },
                        color: Colors.blueGrey.shade400,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0)),
                        child: Text(
                          'Availability',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  // Edit
                  Expanded(
                                      child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(10.0),
                      child: FlatButton(
                        onPressed: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return AddEditEmployee(
                              onSave: (
                                designation,
                                employeeName,
                                weeklyHours,
                                salary,
                                email,
                                hiringDate,
                              ) {
                                BlocProvider.of<EmployeesBloc>(context)
                                    .add(UpdateEmployee(employee.copyWith(
                                      designation: designation,
                                      email: email,
                                      hiringDate: hiringDate,
                                      name: employeeName,
                                      salary: salary,
                                      weeklyHours: weeklyHours
                                    )));
                              },
                              isEditing: true,
                              employee: employee,
                            );
                          }));
                        },
                        color: Colors.blueGrey.shade400,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0)),
                        child: Text(
                          'Edit',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  // Delete
                  Expanded(
                                      child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(10.0),
                      child: FlatButton(
                        onPressed: () {
                          BlocProvider.of<EmployeesBloc>(context).add(DeleteEmployee(employee));
                          Scaffold.of(scaffoldContext).hideCurrentSnackBar();
                          showSnackBar(scaffoldContext, employee);
                        },
                        color: Colors.blueGrey.shade400,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0)),
                        child: Text(
                          'Delete',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
