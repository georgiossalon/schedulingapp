
import 'package:flutter/material.dart';
import 'package:shifts_repository/shifts_repository.dart';

typedef OnSaveCallback = Function(
    String designation, String employeeName,DateTime start_shift, DateTime end_shift);

class AddEditShift extends StatefulWidget {
  static const String screenId = 'add_edit_shift';

  final bool isEditing;
  final OnSaveCallback onSave;
  final Shift shift;

  AddEditShift({
    Key key,
    @required this.onSave,
    @required this.isEditing,
    this.shift
  }) : super(key: key);

  @override
  _AddEditShiftState createState() => _AddEditShiftState();
}

class _AddEditShiftState extends State<AddEditShift> {
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _designation;
  String _employeeName;
  DateTime _start_shift;
  DateTime _end_shift;

  bool get isEditing => widget.isEditing;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditing ? 'Edit Todo' : 'Add Todo',
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey, 
          child: ListView(
            children: <Widget>[
              TextFormField(
                initialValue: isEditing ? widget.shift.designation : '',
                autofocus: !isEditing,
                decoration: InputDecoration(
                  hintText: 'Designation for the Shift'
                ),
                validator: (val) {
                  return val.trim().isEmpty ? 'Please give a Designation': null;
                },
                onSaved: (value) => _designation = value,
              ),
              TextFormField(
                initialValue: isEditing ? widget.shift.employee: '',
                decoration: InputDecoration(
                  hintText: 'Employee Name for the Shift'
                ),
                validator: (val) {
                  return val.trim().isEmpty ? 'Please give a Employee Name': null;
                },
                onSaved: (value) => _employeeName = value,
              ),
            ],
          ),
        ),
      ),
    );
  }
}