import 'package:employees_repository/employees_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:snapshot_test/date_events/blocs/shifts.dart';
import 'package:date_events_repository/date_events_repository.dart';

// typedef OnSaveCallback = Function(
//   String description,
//   String designation,
//   String employeeName,
//   String end_shift,
//   String reason,
//   String start_shift,
//   DateTime dateEvent_date,
//   String employeeId,
// );

class AddEditEmployeeDateEvent extends StatefulWidget {
  static const String screenId = 'add_edit_employee_dateEvent';

  final DateTime daySelected;
  final bool isEditing;
  final bool isShift;
  // final OnSaveCallback onSave;
  final DateEvent dateEvent;
  final Employee employee;

  AddEditEmployeeDateEvent({
    Key key,
    this.daySelected,
    this.isEditing,
    this.isShift,
    // this.onSave,
    this.dateEvent,
    this.employee,
  }) : super(key: key);

  @override
  _AddEditEmployeeDateEventState createState() =>
      _AddEditEmployeeDateEventState();
}

class _AddEditEmployeeDateEventState extends State<AddEditEmployeeDateEvent> {
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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

  Widget _buildEmployeeDropdown() {
    return BlocBuilder<ShiftsBloc, ShiftsState>(
      builder: (context, state) {
        if (state is ShiftCreatedOrEdited) {
          Employee open = Employee(name: 'open');
          List<Employee> hList = [open];
          state.availableEmployees != null
              ? hList.addAll(state.availableEmployees)
              : '';
          return InputDecorator(
            decoration: InputDecoration(
              icon: Icon(FontAwesomeIcons.user),
              labelText: 'Employee',
            ),
            child: DropdownButtonHideUnderline(
              // -- String choosing
              child: DropdownButton<String>(
                // items: state.employees.map((Employee employee) {
                items: hList.map((Employee employee) {
                  return new DropdownMenuItem<String>(
                    value: employee.name,
                    child: Text(employee.name),
                  );
                }).toList(),
                onChanged: (String newEmployeeName) {
                  //! I somehow need to get the employee from his name
                  //! I am comparing names in order to get the employee
                  //! This will cause mistakes when having equally named Employees
                  //! How should I do it better?

                  for (Employee employee in hList) {
                    if (employee.name == newEmployeeName) {
                      BlocProvider.of<ShiftsBloc>(context).add(ShiftsEmployeeChanged(
                        employee: employee,
                      ));
                      //! should I avoid using such parameters? and only use Bloc
                      break;
                    }
                  }
                },
                value: state.currentEmployee != null
                    ? state.currentEmployee.name
                    : 'open',
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
                    fontWeight: FontWeight.bold),
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
    return BlocBuilder<ShiftsBloc, ShiftsState>(
      builder: (context, state) {
        if (state is ShiftCreatedOrEdited) {
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
                  BlocProvider.of<ShiftsBloc>(context).add(ShiftsDesignationChanged(
                    designation: newDesignation,
                  ));
                },
                // When I am creating a new Shift, I pass open as currentDesignation
                // In the CreateNewShift event
                value: state.currentDesignation,
              ),
            ),
          );
        } else {
          return Container(
            child: Text('ups'),
          );
        }
      },
    );
  }

  Widget _buildDescriptionField() {
    return BlocBuilder<ShiftsBloc, ShiftsState>(builder: (context, state) {
      if (state is ShiftCreatedOrEdited) {
        return TextFormField(
            initialValue: isEditing ? widget.dateEvent.description : '',
            decoration: InputDecoration(hintText: 'Description (optional)'),
            onChanged: (value) {
              BlocProvider.of<ShiftsBloc>(context).add(ShiftsDescriptionChanged(
                description: value,
              ));
            },
            onSaved: (value) {});
      } else {
        return Container(
          child: Text('ups'),
        );
      }
    });
  }

  Widget _buildReasonField() {
    return BlocBuilder<ShiftsBloc, ShiftsState>(
      builder: (context, state) {
        return TextFormField(
          enabled: isShift ? false : true,
          initialValue: isEditing
              ? isShift ? 'shift' : widget.dateEvent.reason
              : isShift ? 'shift' : '',
          autofocus: !isEditing,
          decoration: InputDecoration(hintText: 'Reason for the Event'),
          validator: (val) {
            return val.trim().isEmpty ? 'Please give a Reason' : null;
          },
          onSaved: (value) {},
        );
      },
    );
  }

  Widget _buildStartShiftField() {
    return BlocBuilder<ShiftsBloc, ShiftsState>(
      builder: (context, state) {
        if (state is ShiftCreatedOrEdited) {
          return RaisedButton(
            child: Text(
                state.shiftStart == null ? 'Select Start' : state.shiftStart),
            onPressed: () async {
              TimeOfDay timeOfDay = await selectTime(context);
              if (timeOfDay != null) {
                //! Do I need to pass every time all these values?
                BlocProvider.of<ShiftsBloc>(context).add(ShiftEdited(
                  currentDesignation: state.currentDesignation,
                  shiftDate: state.shiftDate,
                  currentEmployee: state.currentEmployee,
                  description: state.description,
                  shiftEnd: state.shiftEnd,
                  shiftStart: '${timeOfDay.hour}:${timeOfDay.minute}',
                ));
              } else {
                //todo add parameter and use it for the validator
              }
            },
          );
        }
      },
    );
  }

  Widget _buildEndShiftField() {
    return BlocBuilder<ShiftsBloc, ShiftsState>(
      builder: (context, state) {
        if (state is ShiftCreatedOrEdited) {
          return RaisedButton(
            child: Text(state.shiftEnd == null ? 'Select End' : state.shiftEnd),
            onPressed: () async {
              TimeOfDay timeOfDay = await selectTime(context);
              if (timeOfDay != null) {
                //! Do I need to pass every time all these values?
                BlocProvider.of<ShiftsBloc>(context).add(ShiftEdited(
                  currentDesignation: state.currentDesignation,
                  shiftDate: state.shiftDate,
                  currentEmployee: state.currentEmployee,
                  description: state.description,
                  shiftEnd: '${timeOfDay.hour}:${timeOfDay.minute}',
                  shiftStart: state.shiftStart,
                ));
              } else {
                //todo add parameter and use it for the validator
              }
            },
          );
        }
      },
    );
  }

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
              autovalidate: true,
              key: _formKey,
              child: ListView(
                children: <Widget>[
                  _buildReasonField(),
                  _buildDescriptionField(),
                  _buildDesignationField(),
                  _buildEmployeeDropdown(),
                  _buildStartShiftField(),
                  _buildEndShiftField(),
                ],
              )),
        ),
        floatingActionButton: BlocBuilder<ShiftsBloc, ShiftsState>(
          builder: (context, state) {
            if (state is ShiftCreatedOrEdited) {
              return FloatingActionButton(
                tooltip: isEditing ? 'Save Changes' : 'Add dateEvent',
                child: Icon(isEditing ? Icons.check : Icons.add),
                backgroundColor: Colors.pink,
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();

                    BlocProvider.of<ShiftsBloc>(context)
                        .add(ShiftAsDateEventAdded(
                            dateEvent: DateEvent(
                      dateEvent_date: state.shiftDate,
                      description:
                          state.description, 
                      designation: state.currentDesignation,
                      employeeId: state.currentEmployee != null
                                     ? state.currentEmployee.id
                                     : null,
                      employeeName: state.currentEmployee != null
                                        ? state.currentEmployee.name
                                        : null,
                      end_shift: state.shiftEnd,
                      reason: state.reason,
                      start_shift: state.shiftStart,
                    )));
                    Navigator.pop(context);
                  }
                },
              );
            }
          },
        ),
      ),
    );
  }
}
