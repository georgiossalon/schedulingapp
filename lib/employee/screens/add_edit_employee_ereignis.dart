import 'package:employees_repository/employees_repository.dart';
import 'package:flutter/material.dart';
import 'package:snapshot_test/employee/blocs/designations.dart';
import 'package:snapshot_test/employee/blocs/employees.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

typedef OnSaveCallback = Function(
    String description,
    String designation,
    String employee,
    String end_shift,
    String reason,
    String start_shift,
    DateTime ereignis_date,
    String parentId,
    String oldParentId,
    bool changedEmployee);

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

class _AddEditEmployeeEreignisState extends State<AddEditEmployeeEreignis> {
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _description;
  String _designation;
  String _employeeName;
  String _end_shift;
  String _reason;
  String _start_shift;
  String _parentId;
  String _oldParentId;
  Employee _employeeObj;
  bool _changedEmployee;

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
    if (isEditing) {
      _description = widget.ereignis.description;
      _designation = widget.ereignis.designation;
      _employeeName = widget.ereignis.employee;
      _reason = widget.ereignis.reason;
      _start_shift = widget.ereignis.start_shift;
      _end_shift = widget.ereignis.end_shift;
      _parentId = widget.ereignis.parentId;
      // _employeeObj = widget.employee;
      BlocProvider.of<EmployeesBloc>(context)
          .add(LoadEmployeesWithGivenDesignation(
        designation: _designation,
        date: widget.daySelected,
      ));
    } else {
      _designation = 'open';
      BlocProvider.of<EmployeesBloc>(context)
          .add(LoadEmployeesWithGivenDesignation(
        designation: _designation,
        date: widget.daySelected,
      ));
    }
  }

  Widget _buildEmployeeDropdown() {
    //todo: I should probably wait for the user to choose designation before
    //todo... fetching the capable employees
    return BlocBuilder<EmployeesBloc, EmployeesState>(
      builder: (context, state) {
        if (state is EmployeesLoading) {
          //todo let the user know that after choosing the designation
          //todo... the employee dropdown will be available
          return Container(
            child: Text('Loading'),
          );
        } else if (state is EmployeesLoaded) {
          return InputDecorator(
            decoration: InputDecoration(
              icon: Icon(FontAwesomeIcons.user),
              labelText: 'Employee',
            ),
            child: DropdownButtonHideUnderline(
              // -- object choosing
              // child: DropdownButton<Employee>(
              //   items: state.employees.map((Employee employee) {
              //     return new DropdownMenuItem<Employee>(
              //       value: employee,
              //       child: Text(employee.name),
              //     );
              //   }).toList(),
              //   onChanged: (Employee newEmployee) {
              //     setState(() {
              //       _employeeName = newEmployee.name;
              //       _parentId = newEmployee.id;
              //       _employeeObj = newEmployee;
              //     });
              //   },
              //   value:_employeeObj,
              // ),

              // -- String choosing
              child: DropdownButton<String>(
                items: state.employees.map((Employee employee) {
                  return new DropdownMenuItem<String>(
                    value: employee.name,
                    child: Text(employee.name),
                  );
                }).toList(),
                onChanged: (String newEmployeeName) {
                  setState(() {
                    _employeeName = newEmployeeName;
                    // -- this method is prone to erros, since
                    // -- different employees may have the same name
                    List<Employee> hList = state.employees;
                    for (var employee in hList) {
                      if (employee.name == _employeeName) {
                        _parentId = employee.id;
                        break;
                      }
                    }
                    // -- end
                    // _parentId = newEmployee.id;
                  });
                },
                value: _employeeName,
              ),
            ),
          );
        }
      },
    );
  }

  Widget _buildDesignationField() {
    return BlocBuilder<DesignationsBloc, DesignationsState>(
      builder: (context, state) {
        if (state is DesignationsLoading) {
          return Container(
            child: Text('Loading'),
          );
        } else if (state is DesignationsLoaded) {
          return InputDecorator(
            decoration: InputDecoration(
              icon: Icon(FontAwesomeIcons.tasks),
              labelText: 'Designation',
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                items: state.designations.map((Designation designation) {
                  return new DropdownMenuItem<String>(
                    value: designation.designation,
                    child: Text(designation.designation),
                  );
                }).toList(),
                onChanged: (String newDesignation) {
                  // call only the capable employees for this designation
                  BlocProvider.of<EmployeesBloc>(context)
                      .add(LoadEmployeesWithGivenDesignation(
                    designation: newDesignation,
                    date: widget.daySelected,
                  ));
                  setState(() {
                    _designation = newDesignation;
                    // After changing the designation, I have to set the employeeName
                    // to null, otherwise I will be getting errors, since my
                    // employee dropdown does not contain the name for the new designation
                    _employeeName = null;
                    _employeeObj = null;
                  });
                },
                value: _designation,
              ),
            ),
          );
        }
      },
    );
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
                      : 'Add Event on ${widget.daySelected.day}.${widget.daySelected.month}.${widget.daySelected.year}'),
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
                        ? isShift ? 'shift' : widget.ereignis.reason
                        : isShift ? 'shift' : '',
                    autofocus: !isEditing,
                    decoration:
                        InputDecoration(hintText: 'Reason for the Event'),
                    validator: (val) {
                      return val.trim().isEmpty ? 'Please give a Reason' : null;
                    },
                    onSaved: (value) => _reason = value,
                  ),
                  TextFormField(
                    initialValue: isEditing ? widget.ereignis.description : '',
                    decoration:
                        InputDecoration(hintText: 'Description (optional)'),
                    //todo description is optional
                    // validator: (val) {
                    //   return val.trim().isEmpty
                    //       ? 'Please give a description'
                    //       : null;
                    // },
                    onSaved: (value) => _description = value,
                  ),
                  _buildDesignationField(),
                  _buildEmployeeDropdown(),
                  // TextFormField(
                  //   initialValue: isEditing ? widget.ereignis.employee : '',
                  // decoration:
                  //     InputDecoration(hintText: 'Employee Name for the Shift'),
                  // validator: (val) {
                  //   return val.trim().isEmpty
                  //       ? 'Please give a Employee Name'
                  //       : null;
                  // },
                  // onSaved: (value) => _employee = value,
                  // ),
                  RaisedButton(
                    child: Text(
                        _start_shift == null ? 'Select Start' : _start_shift),
                    onPressed: () async {
                      TimeOfDay timeOfDay = await selectTime(context);
                      setState(() {
                        if (timeOfDay != null) {
                          _start_shift =
                              '${timeOfDay.hour}:${timeOfDay.minute}';
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
            
            // -- to check if an employee got changed when editing
            // --  this has an impact on the firebase db
            if (isEditing) {
              // while editing I can change multiple times the name on the dropdown
              // but if in the end the employeeName remains the same, then nothing changes
              // this means that this ereignis will only get updated
              if (widget.ereignis.employee == _employeeName) {
                _changedEmployee = false;
              } else {
                // this means that the employee was changed. The ereignis will get
                // deleted from the sub-collection of the former employee and then
                // added to the new one
                _changedEmployee = true;
                _oldParentId = widget.ereignis.parentId;
              }
            } else {
              _changedEmployee = false;
            }
            // -- end

            if (_formKey.currentState.validate()) {
              _formKey.currentState.save();
              widget.onSave(
                _description,
                _designation,
                _employeeName,
                _end_shift,
                _reason,
                _start_shift,
                widget.daySelected,
                _parentId,
                _oldParentId,
                _changedEmployee,
              );
              Navigator.pop(context);
            }
          },
        ),
      ),
    );
  }
}
