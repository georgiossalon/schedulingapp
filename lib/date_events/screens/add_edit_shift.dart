import 'package:employees_repository/employees_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:snapshot_test/date_events/blocs/shifts.dart';
import 'package:date_events_repository/date_events_repository.dart';
import 'package:snapshot_test/employee/blocs/employees.dart';

//!Tolly: does my form have to be stateful?
class AddEditShift extends StatefulWidget {
  static const String screenId = 'add_edit_shift';

  final DateTime daySelected;
  final bool isEditing;
  final DateEvent dateEvent;

  AddEditShift({
    Key key,
    this.daySelected,
    this.isEditing,
    this.dateEvent,
  }) : super(key: key);

  @override
  _AddEditShiftState createState() => _AddEditShiftState();
}

class _AddEditShiftState extends State<AddEditShift> {
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool get isEditing => widget.isEditing;
  // bool get isShift => widget.isShift;

  static Future<TimeOfDay> selectTime(
      BuildContext context, String selectedTime) async {
    // the shift time saved within the saved is of String type
    TimeOfDay hSelectedTime = selectedTime == null
        ? TimeOfDay.now()
        : TimeOfDay(
            hour: int.parse(selectedTime.split(":")[0]),
            minute: int.parse(selectedTime.split(":")[1]));
    final TimeOfDay _picked = await showTimePicker(
      context: context,
      initialTime: hSelectedTime == null ? TimeOfDay.now() : hSelectedTime,
    );

    if (_picked != null) {
      return _picked;
    } else {
      return null;
    }
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
                    ? 'Edit Shift on ${widget.daySelected.day}.${widget.daySelected.month}.${widget.daySelected.year}'
                    : 'Add Shift on ${widget.daySelected.day}.${widget.daySelected.month}.${widget.daySelected.year}'),
          ),
          body: Padding(
            padding: EdgeInsets.all(16.0),
            child: Form(
                //! Rolly: validation method with bloc. Also why need autovalidate?
                autovalidate: true,
                key: _formKey,
                child: ListView(
                  children: <Widget>[
                    //! Rolly: How to pass the isEditing value down?
                    //! I can not use const for widget
                    _ReasonField(
                      isEditing: isEditing,
                    ),
                    _DescriptionField(
                      isEditing: isEditing,
                    ),
                    const _DesignationDropdown(),
                    const _EmployeeDropdown(),
                    //!Rolly: how to use the selectTime method in from this classs
                    const _StartShiftField(),
                    const _EndShiftField(),
                  ],
                )),
          ),
          floatingActionButton: FloatingActionButton(
            tooltip: isEditing ? 'Save Changes' : 'Add Shift',
            child: Icon(isEditing ? Icons.check : Icons.add),
            backgroundColor: Colors.pink,
            onPressed: () {
              //! Rolly Opinion, using this instead of BlocBuilder<ShiftsBloc> to get state
              var state =
                  (context.bloc<ShiftsBloc>().state as ShiftCreatedOrEdited);
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();

                DateEvent dateEvent = DateEvent(
                  dateEvent_date: state.shiftDate,
                  description: state.description,
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
                  id: state.id,
                );

                // save this shift as dateEvent in firestore
                BlocProvider.of<ShiftsBloc>(context).add(UploadDateEventAdded(
                  dateEvent: dateEvent,
                  // oldEmployee: state.oldEmployee,
                  // availableEmployees: state.availableEmployees,
                  // currentEmployee: state.currentEmployee,
                  // designationsList: state.designations,
                ));

                //! Rolly: Opinion
                EmployeeDateEvent employeeDateEvent = EmployeeDateEvent(
                  designation: dateEvent.description,
                  dateEvent_date: dateEvent.dateEvent_date,
                  description: dateEvent.description,
                  employeeId: dateEvent.employeeId,
                  employeeName: dateEvent.employeeName,
                  end_shift: dateEvent.end_shift,
                  id: dateEvent.id,
                  reason: dateEvent.reason,
                  start_shift: dateEvent.start_shift,
                );
                //! - currently I am saving all dateEvents into the busy_map of an employee
                //! after a while I will be having too many of them
                //! In addition, when I am editing shifts I should delete from the old employee
                //! the dateEvent from its busyMap

                // remove the dateEvent from the old employees busy_map
                //!Rolly
                //! I moved the if-statements into the Bloc
                BlocProvider.of<EmployeesBloc>(context).add(
                    EmployeesBusyMapDateEventRemoved(
                        oldEmployee: state.oldEmployee,
                        currentEmployeeId: employeeDateEvent.employeeId,
                        dateTime: dateEvent.dateEvent_date));
                // add in employees busy_map
                BlocProvider.of<EmployeesBloc>(context).add(
                    UpdateEmployeeBusyMap(
                        employeeDateEvent: employeeDateEvent,
                        oldEmployee: state.oldEmployee));
                Navigator.pop(context);
              }
            },
          )
          // } else {
          //   return Container(
          //     child: Text('ups'),
          //   );
          // }
          //   },
          // ),
          ),
    );
  }
}

class _DescriptionField extends StatelessWidget {
  final bool isEditing;

  const _DescriptionField({Key key, this.isEditing}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShiftsBloc, ShiftsState>(builder: (context, state) {
      if (state is ShiftCreatedOrEdited) {
        return TextFormField(
            initialValue: isEditing ? state.description : '',
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
}

class _ReasonField extends StatelessWidget {
  final bool isEditing;

  const _ReasonField({Key key, @required this.isEditing}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShiftsBloc, ShiftsState>(
      builder: (context, state) {
        return TextFormField(
          enabled: false,
          initialValue: 'shift',
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
}

class _DesignationDropdown extends StatelessWidget {
  const _DesignationDropdown({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                  BlocProvider.of<ShiftsBloc>(context)
                      .add(ShiftsDesignationChanged(
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
}

class _EmployeeDropdown extends StatelessWidget {
  const _EmployeeDropdown({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShiftsBloc, ShiftsState>(
      builder: (context, state) {
        if (state is ShiftCreatedOrEdited) {
          return InputDecorator(
            decoration: InputDecoration(
              icon: Icon(FontAwesomeIcons.user),
              labelText: 'Employee',
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<Employee>(
                  items: state.availableEmployees.map((Employee employee) {
                    return new DropdownMenuItem<Employee>(
                      value: employee,
                      child: Text(employee.name),
                    );
                  }).toList(),
                  onChanged: (Employee employee) {
                    BlocProvider.of<ShiftsBloc>(context)
                        .add(ShiftsEmployeeChanged(
                      employee: employee,
                    ));
                  },
                  value: state.currentEmployee),
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
}

class _EndShiftField extends StatelessWidget {
  const _EndShiftField({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShiftsBloc, ShiftsState>(
      builder: (context, state) {
        if (state is ShiftCreatedOrEdited) {
          return RaisedButton(
            child: Text(state.shiftEnd == null ? 'Select End' : state.shiftEnd),
            onPressed: () async {
              TimeOfDay timeOfDay =
                  await _AddEditShiftState.selectTime(context, state.shiftEnd);
              if (timeOfDay != null) {
                BlocProvider.of<ShiftsBloc>(context).add(ShiftsEndTimeChanged(
                  shiftEnd: '${timeOfDay.hour}:${timeOfDay.minute}',
                ));
              } else {
                //todo add parameter and use it for the validator
              }
            },
          );
        } else {
          return Container(
            child: Text('ups'),
          );
        }
      },
    );
  }
}

class _StartShiftField extends StatelessWidget {
  const _StartShiftField({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShiftsBloc, ShiftsState>(
      builder: (context, state) {
        if (state is ShiftCreatedOrEdited) {
          return RaisedButton(
            child: Text(
                state.shiftStart == null ? 'Select Start' : state.shiftStart),
            onPressed: () async {
              TimeOfDay timeOfDay = await _AddEditShiftState.selectTime(
                  context, state.shiftStart);
              if (timeOfDay != null) {
                BlocProvider.of<ShiftsBloc>(context).add(ShiftsStartTimeChanged(
                  shiftStart: '${timeOfDay.hour}:${timeOfDay.minute}',
                ));
              } else {
                //todo add parameter and use it for the validator
              }
            },
          );
        } else {
          return Container(
            child: Text('ups'),
          );
        }
      },
    );
  }
}
