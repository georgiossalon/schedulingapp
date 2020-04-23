import 'package:flutter/material.dart';
import 'package:shifts_repository/shifts_repository.dart';

typedef OnSaveCallback = Function(String designation, String employeeName,
    String start_shift, String end_shift, DateTime shift_Date);

class AddEditShift extends StatefulWidget {
  static const String screenId = 'add_edit_shift';

  final DateTime daySelected;
  final bool isEditing;
  final OnSaveCallback onSave;
  final Shift shift;

  AddEditShift(
      {Key key, 
      @required this.onSave, @required this.isEditing,@required this.daySelected,
      this.shift})
      : super(key: key);

  @override
  _AddEditShiftState createState() => _AddEditShiftState();
}

class _AddEditShiftState extends State<AddEditShift> {
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _designation;
  String _employeeName;
  String _start_shift;
  String _end_shift;
  DateTime _shift_date;

  bool get isEditing => widget.isEditing;

  Future<TimeOfDay> selectTime(BuildContext context) async {
    final TimeOfDay _picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (_picked != null) {
      return _picked;
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: Text(
          isEditing ? 'Edit Shift on ${widget.daySelected.day}.${widget.daySelected.month}.${widget.daySelected.year}' : 'Add Shift on ${widget.daySelected.day}.${widget.daySelected.month}.${widget.daySelected.year}',
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
                decoration:
                    InputDecoration(hintText: 'Designation for the Shift'),
                validator: (val) {
                  return val.trim().isEmpty
                      ? 'Please give a Designation'
                      : null;
                },
                onSaved: (value) => _designation = value,
              ),
              TextFormField(
                initialValue: isEditing ? widget.shift.employee : '',
                decoration:
                    InputDecoration(hintText: 'Employee Name for the Shift'),
                validator: (val) {
                  return val.trim().isEmpty
                      ? 'Please give a Employee Name'
                      : null;
                },
                onSaved: (value) => _employeeName = value,
              ),
              RaisedButton(
                child: Text(_start_shift == null ?'Select start_shift' :_start_shift),
                onPressed: () async {
                  TimeOfDay timeOfDay = await selectTime(context);
                  setState(() {
                  _start_shift = '${timeOfDay.hour}:${timeOfDay.minute}';
                  });
                },
              ),
              RaisedButton(
                child: Text(_end_shift == null ?'Select end_shift' :_end_shift),
                onPressed: () async {
                  TimeOfDay timeOfDay = await selectTime(context);
                  setState(() {
                  _end_shift = '${timeOfDay.hour}:${timeOfDay.minute}';
                  });
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: isEditing ? 'Save Changes' : 'Add Shift',
        child: Icon(isEditing ? Icons.check : Icons.add),
        backgroundColor: Colors.pink,
        onPressed: () {
          if (_formKey.currentState.validate()) {
            _formKey.currentState.save();
            widget.onSave(
                _designation, _employeeName, _start_shift, _end_shift,widget.daySelected,);
            Navigator.pop(context);
          }
        },
      ),
    );
  }
}
