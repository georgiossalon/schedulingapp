import 'package:flutter/material.dart';

class EmployeesList extends StatefulWidget {
  EmployeesList({Key key}) : super(key: key);

  @override
  _EmployeesListState createState() => _EmployeesListState();
}

class _EmployeesListState extends State<EmployeesList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Employees'),
        actions: <Widget>[
          // IconButton(icon: FontsAwesome.users,)
        ],
      ),
      //  child: child,
    );
  }
}