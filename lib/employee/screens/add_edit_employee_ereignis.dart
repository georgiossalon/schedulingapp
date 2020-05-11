import 'package:employees_repository/employees_repository.dart';
import 'package:flutter/material.dart';
import 'package:snapshot_test/employee/blocs/employees.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

typedef OnSaveCallback = Function(
  String description,
  String designation,
  String employee,
  String end_shift,
  String reason,
  String start_shift,
  DateTime ereignis_date,
  String parentId,
);

class AddEditEmployeeEreignis extends StatefulWidget {
  static const String screenId = 'add_edit_employee_ereignis';

  final DateTime daySelected;
  final bool isEditing;
  final bool isShift;
  final OnSaveCallback onSave;
  final Ereignis ereignis;

  AddEditEmployeeEreignis({
    Key key,
    this.daySelected,
    this.isEditing,
    this.isShift,
    this.onSave,
    this.ereignis,
  }) : super(key: key);

  @override
  _AddEditEmployeeEreignisState createState() =>
      _AddEditEmployeeEreignisState();
}

class _AddEditEmployeeEreignisState
    extends State<AddEditEmployeeEreignis> {
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _description;
  String _designation;
  String _employee;
  String _end_shift;
  String _reason;
  String _start_shift;
  String _parentId;


  bool get isEditing => widget.isEditing;
  
  bool get isShift => widget.isShift;

  //todo: When editing time the initial time is always the current Time!
  //todo... I might have to change _start/_end time data type from String
  Future<TimeOfDay> selectTime(BuildContext context) async {
    final TimeOfDay _picked =
        await showTimePicker(context: context, initialTime: TimeOfDay.now()
            // initialTime: selected == null
            //                 ? TimeOfDay.now()
            //                 : selected,
            );
    if (_picked != null) {
      return _picked;
    } else {
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
  }

  List<Employee> getAvailableEmployeesAccordingToDesignation(String designation) {
    //todo the available employees for a given date and designation can be retrieved
    //todo... create a dropdown to insert these employees
    //todo... create a new ereignis and add it with the blocs to firestore

    // return BlocBuilder<EmployeesBloc, EmployeesState>(
    //   builder: (context, state) {
    //     if (state is EmployeesLoading) {
    //       return Container(child: Text('Loading'),);
    //     } else if () {
    //     }
    //   },
    // );
  }

  Widget _buildEmployeeDropdown() {

  }

  // build dropdown with all possible designations

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.pink,
          title: Text(
            //check if editing first
            isEditing
                  // then check if it is a shift or another event
                ? isShift
                    ? 'Edit Shift on ${widget.daySelected.day}.${widget.daySelected.month}.${widget.daySelected.year}'
                    : 'Edit Event on ${widget.daySelected.day}.${widget.daySelected.month}.${widget.daySelected.year}'
                : isShift
                    ? 'Add Shift on ${widget.daySelected.day}.${widget.daySelected.month}.${widget.daySelected.year}'
                    : 'Add Event on ${widget.daySelected.day}.${widget.daySelected.month}.${widget.daySelected.year}'
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
              key: _formKey,
              child: ListView(
                children: <Widget>[
                  TextFormField(
                    enabled: isShift ? false : true,
                    initialValue: isEditing
                                      ? isShift
                                          ? 'shift'
                                          : widget.ereignis.reason
                                       : isShift
                                          ? 'shift'
                                          : '',
                    autofocus: !isEditing,
                    decoration: InputDecoration(
                        hintText: 'Reason for the Event'),
                      validator: (val) {
                        return val.trim().isEmpty
                            ? 'Please give a Reason'
                            : null;
                      },
                      onSaved: (value) => _reason = value,
                  ),
                  TextFormField(
                    initialValue: isEditing ? widget.ereignis.description : '',   
                    decoration: InputDecoration(hintText: 'Description'),
                    validator: (val) {
                      return val.trim().isEmpty
                          ? 'Please give a description'
                          : null;
                    },
                    onSaved: (value) => _description = value,
                  ),
                  TextFormField(
                    initialValue: isEditing ? widget.ereignis.designation : '',
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
                    initialValue: isEditing ? widget.ereignis.employee : '',
                  decoration:
                      InputDecoration(hintText: 'Employee Name for the Shift'),
                  validator: (val) {
                    return val.trim().isEmpty
                        ? 'Please give a Employee Name'
                        : null;
                  },
                  onSaved: (value) => _employee = value,
                  ),
                  RaisedButton(
                  child: Text(
                      _start_shift == null ? 'Select Start' : _start_shift),
                  onPressed: () async {
                    TimeOfDay timeOfDay = await selectTime(context);
                    setState(() {
                      if (timeOfDay != null) {
                        _start_shift = '${timeOfDay.hour}:${timeOfDay.minute}';
                      }
                    });
                  },
                ),
                  RaisedButton(
                  child: Text(_end_shift == null ? 'Select End' : _end_shift),
                  onPressed: () async {
                    TimeOfDay timeOfDay = await selectTime(context);
                    setState(() {
                      if (timeOfDay != null) {
                        _end_shift = '${timeOfDay.hour}:${timeOfDay.minute}';
                      }
                    });
                  },
                ),
                ],
              )),
        ),
        floatingActionButton: FloatingActionButton(
          tooltip: isEditing ? 'Save Changes' : 'Add ereignis',
          child: Icon(isEditing ? Icons.check : Icons.add),
          backgroundColor: Colors.pink,
          onPressed: () {
            if (_formKey.currentState.validate()) {
              _formKey.currentState.save();
              widget.onSave(
                _description,
                _designation,
                _employee,
                _end_shift,
                _reason,
                _start_shift,
                widget.daySelected,
                _parentId,
              );
              Navigator.pop(context);
            }
          },
        ),
      ),
    );
  }
}
