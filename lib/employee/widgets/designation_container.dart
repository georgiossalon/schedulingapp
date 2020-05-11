import 'package:employees_repository/employees_repository.dart';
import 'package:flutter/material.dart';

class DesignationContainer extends StatelessWidget {
  final Designation designation;

  const DesignationContainer({Key key, this.designation}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            designation.designation,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
