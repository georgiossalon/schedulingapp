import 'package:employees_repository/employees_repository.dart';
import 'package:flutter/material.dart';
import 'package:snapshot_test/employee/blocs/date_events.dart';
import 'package:snapshot_test/employee/blocs/designations.dart';
import 'package:snapshot_test/employee/blocs/designations_bloc.dart';
import 'package:snapshot_test/employee/blocs/employees.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

typedef OnSaveCallback = Function(
    String description,
    String designation,
    String employeeName,
    String end_shift,
    String reason,
    String start_shift,
    DateTime dateEvent_date,
    String parentId,
    String oldParentId,
    bool changedEmployee,
    Employee employeeObj);

class AddEditEmployeeDateEvent extends StatefulWidget {
  static const String screenId = 'add_edit_employee_dateEvent';

  final DateTime daySelected;
  final bool isEditing;
  final bool isShift;
  final OnSaveCallback onSave;
  final DateEvent dateEvent;
  final Employee employee;

  AddEditEmployeeDateEvent({
    Key key,
    this.daySelected,
    this.isEditing,
    this.isShift,
    this.onSave,
    this.dateEvent,
    this.employee,
  }) : super(key: key);

  @override
  _AddEditEmployeeDateEventState createState() =>
      _AddEditEmployeeDateEventState();
}

class _AddEditEmployeeDateEventState extends State<AddEditEmployeeDateEvent> {
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
  Set<Employee> _hSet = new Set(); //todo do I need this?

  bool get isEditing => widget.isEditing;

  bool get isShift => widget.isShift;

  @override
  void initState() {
    super.initState();
    //todo: avoid the if-statement (no calculations within the initState)
    //todo... the computations should happen in beforehand
    if (isEditing) {
      _description = widget.dateEvent.description;
      _designation = widget.dateEvent.designation;
      _employeeName = widget.dateEvent.employeeName;
      _reason = widget.dateEvent.reason;
      _start_shift = widget.dateEvent.start_shift;
      _end_shift = widget.dateEvent.end_shift;
      _parentId = widget.dateEvent.parentId;
      // _employeeObj = widget.employee; // todo probably need this when editing

      // when editing a shift, I should give the user the choice to choose
      // another employee for the current designation without clicking on the
      // designation again
      BlocProvider.of<EmployeesBloc>(context)
          .add(LoadEmployeesWithGivenDesignation(
        designation: _designation,
        date: widget.daySelected,
      ));
      // -- end
      // load the current designation for this shift
      BlocProvider.of<DesignationsBloc>(context)
          .add(AssignDesignationsToEmployee(_designation));
      _hSet.add(widget.employee);
    } else {
      // when creating a new shift, the default designation is set to open
      _designation = 'open';
      // I chose to load the open employee for this case but I do not have to
      // otherwise the dropdown would be set as Loading...
      //! This does not note a change when I go from an editted shift to a new shift
      //! this means that the onTransition in the simple_bloc_delegate
      // Alternative 1: I can fetch only the open employee without using the Bloc
      // Alternative 2: (not working) Write the BlocProvider outside the init before calling this screen
      BlocProvider.of<EmployeesBloc>(context)
          .add(LoadEmployeesWithGivenDesignation(
        designation: _designation,
        date: widget.daySelected,
      ));
      // report to the DesignationsBloc, that the initial designation is open
      BlocProvider.of<DesignationsBloc>(context)
          .add(AssignDesignationsToEmployee(_designation));
    }
  }

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

  Widget _buildEmployeeDropdown() {
    return BlocBuilder<EmployeesBloc, EmployeesState>(
      builder: (context, state) {
        //! why is the old state getting loaded after I have clicked on a shift
        //! to edit and then want to create a new shift? In my init method
        //! I am calling only the available employees ('open')
        if (state is EmployeesLoading) {
          return Container(
            child: Text('Loading'),
          );
        } else if (state is EmployeesLoadedWithGivenDesignation) {
          // the open employee will always be shown, when added in the employees list

          //todo when setting the new employee for the shift, the list
          //todo... gets updated and I will always have an error because of the dropdown

          //! the following 'method' saves the old and new assigned employee,
          //! so that I do not have a problem with the dropdown
          // -- adding the old employee to the list for the dropdown
          for (var employee in state.employees) {
            bool hbool = false;
            for (var employeeInSet in _hSet) {
              if (employeeInSet.id == employee.id) {
                hbool = true;
              }
            }
            // if the employee is not within the map, then add him
            !hbool ? _hSet.add(employee) : null;
          }
          // --end

          return InputDecorator(
            decoration: InputDecoration(
              icon: Icon(FontAwesomeIcons.user),
              labelText: 'Employee',
            ),
            child: DropdownButtonHideUnderline(
              // -- String choosing
              child: DropdownButton<String>(
                // items: state.employees.map((Employee employee) {
                items: _hSet.map((Employee employee) {
                  return new DropdownMenuItem<String>(
                    value: employee.name,
                    child: Text(employee.name),
                  );
                }).toList(),
                onChanged: (String newEmployeeName) {
                  setState(() {
                    _employeeName = newEmployeeName;
                    if (state is EmployeesLoaded) {
                      // -- this method is prone to erros, since
                      // -- different employees may have the same name
                      List<Employee> hList = state.employees;
                      for (var employee in hList) {
                        if (employee.name == _employeeName) {
                          _parentId = employee.id;
                          _employeeObj = employee;
                          break;
                        }
                      }
                      // -- end
                    }
                  });
                },
                // value: _employeeName != null ? null : _employeeName,
                value: _employeeName,
              ),
            ),
          );
        } else {
          return Container(
            padding: EdgeInsets.all(5.0),
            child: Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: Text(
                'No Employee for this Designation',
                style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.red,
                  fontWeight: FontWeight.bold
                ),
                textAlign: TextAlign.center,
              ),
            ),
            height: 40.0,
          );
        }
      },
    );
  }

  Widget _buildDesignationField() {
    return BlocBuilder<DateEventsBloc, DateEventsState>(
      builder: (context, state) {
        // if (state is ) {
        //   return Container(
        //     child: Text('Loading'),
        //   );
        // } else 
        // if (state.designationsObj.designations.isNotEmpty &&
        //     state.designationsObj.currentDesignation != null) {
          if (state is NewShiftCreated) {
          return InputDecorator(
            decoration: InputDecoration(
              icon: Icon(FontAwesomeIcons.tasks),
              labelText: 'Designation',
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                items: state.designations.map((String designation) {
                  return new DropdownMenuItem<String>(
                    value: designation,
                    child: Text(designation),
                  );
                }).toList(),
                onChanged: (String newDesignation) {
                  // call only the capable employees for this designation
                  BlocProvider.of<EmployeesBloc>(context)
                      .add(LoadEmployeesWithGivenDesignation(
                    designation: newDesignation,
                    date: widget.daySelected,
                  ));
                  // setState(() {
                  _designation = newDesignation;
                  BlocProvider.of<DesignationsBloc>(context)
                      .add(AssignDesignationsToEmployee(_designation));
                  // After changing the designation, I have to set the employeeName
                  // to null, otherwise I will be getting errors, since my
                  // employee dropdown does not contain the name for the new designation
                  _employeeName = null;
                  _employeeObj = null;
                  _hSet = new Set();
                  // });
                },
                value: _designation,
              ),
            ),
          );
        } else {
          print(state);
          return Container(
            child: Text('ups'),
          );
        }
      },
    );
  }

  void updateValuesForWhenEditingAndChangingEmployees() {
// -- to check if an employee got changed when editing
    // --  this has an impact on the firebase db
    if (isEditing) {
      // while editing I can change multiple times the name on the dropdown
      // but if in the end the employeeName remains the same, then nothing changes
      // this means that this dateEvent will only get updated
      if (widget.dateEvent.employeeName == _employeeName) {
        _changedEmployee = false;
      } else {
        // this means that the employee was changed. The dateEvent will get
        // deleted from the sub-collection of the former employee and then
        // added to the new one
        _changedEmployee = true;
        _oldParentId = widget.dateEvent.parentId;
      }
    } else {
      _changedEmployee = false;
    }
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
                        ? isShift ? 'shift' : widget.dateEvent.reason
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
                    initialValue: isEditing ? widget.dateEvent.description : '',
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
                  // todo add validator for when choosing a shift time
                  //! this should be only a must when creating a shift and nothing else
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
          tooltip: isEditing ? 'Save Changes' : 'Add dateEvent',
          child: Icon(isEditing ? Icons.check : Icons.add),
          backgroundColor: Colors.pink,
          onPressed: () {
            // -- to check if an employee got changed when editing
            // --  this has an impact on the firebase db
            updateValuesForWhenEditingAndChangingEmployees();

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
                  _employeeObj);
              Navigator.pop(context);
            }
          },
        ),
      ),
    );
  }
}
