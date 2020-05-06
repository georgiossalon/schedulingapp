import 'package:employees_repository/employees_repository.dart';
import 'package:flutter/material.dart';
import 'package:snapshot_test/employee/blocs/employees.dart';
import 'package:snapshot_test/employee/blocs/employees_bloc.dart';
import 'package:snapshot_test/employee/screens/add_edit_employee.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snapshot_test/employee/widgets/employee_container.dart';

class EmployeesList extends StatefulWidget {
  EmployeesList({Key key}) : super(key: key);

  @override
  _EmployeesListState createState() => _EmployeesListState();
}

class _EmployeesListState extends State<EmployeesList> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EmployeesBloc, EmployeesState>(
        builder: (context, state) {
      if (state is EmployeesLoaded) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Employees'),
            actions: <Widget>[
              // IconButton(icon: FontsAwesome.users,)
            ],
          ),
          body: ListView.builder(
            itemCount: state.employees.length,
            itemBuilder: (context, index){
              return EmployeeContainer(employee: state.employees[index], scaffoldContext: context,);
            }),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            backgroundColor: Colors.pink,
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return AddEditEmployee(
                  onSave: (
                    designation,
                    employeeName,
                    weeklyHours,
                    salary,
                    email,
                    hiringDate,
                  ) {
                    // * context.bloc<EmployeesBloc>().add ...
                    BlocProvider.of<EmployeesBloc>(context).add(AddEmployee(
                        Employee(
                            designation: designation,
                            name: employeeName,
                            weeklyHours: weeklyHours,
                            salary: salary,
                            email: email,
                            hiringDate: hiringDate)));
                  },
                  isEditing: false,
                );
              }));
            },
          ),
          //  child: child,
        );
      }
    });
  }
}
