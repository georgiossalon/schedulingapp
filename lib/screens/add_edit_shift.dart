
import 'package:flutter/material.dart';
import 'package:shifts_repository/shifts_repository.dart';

typedef OnSaveCallback = Function(
    String designation, String employeeName,DateTime shiftDate,);

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
  String 

  @override
  Widget build(BuildContext context) {
    return Container(
       child: child,
    );
  }
}