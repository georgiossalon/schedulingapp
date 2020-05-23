import 'package:date_events_repository/date_events_repository.dart';
import 'package:employees_repository/employees_repository.dart';
import 'package:flutter/material.dart';
import 'package:snapshot_test/date_events/blocs/shifts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snapshot_test/employee/blocs/employees.dart';

class AddEditDayOff extends StatefulWidget {
  static const String screenId = 'add_edit_dayoff';

  final bool isEditing;
  final DateTime daySelected;
  final DateEvent dateEvent;

  AddEditDayOff(
      {Key key,
      @required this.isEditing,
      @required this.daySelected,
      @required this.dateEvent})
      : super(key: key);

  @override
  _AddEditDayOffState createState() => _AddEditDayOffState();
}

class _AddEditDayOffState extends State<AddEditDayOff> {
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool get isEditing => widget.isEditing;

  //! I do not really need a Field when the field is disabled
  Widget _buildReasonField() {
    return BlocBuilder<ShiftsBloc, ShiftsState>(
      builder: (context, state) {
        return TextFormField(
          enabled: false,
          initialValue: 'Day Off',
          autofocus: !isEditing,
          decoration: InputDecoration(hintText: 'Reason for the Day Off'),
          validator: (val) {
            return val.trim().isEmpty ? 'Please give a Reason' : null;
          },
          onSaved: (value) {},
        );
      },
    );
  }

  //! Rolly
  //todo: make this description needed (add validator).
  Widget _buildDescriptionField() {
    return BlocBuilder<ShiftsBloc, ShiftsState>(builder: (context, state) {
      if (state is CreatedOrEditedDayOff) {
        return TextFormField(
            initialValue: isEditing ? state.description : '',
            decoration: InputDecoration(hintText: 'Description'),
            onChanged: (value) {
              BlocProvider.of<ShiftsBloc>(context).add(DayOffDescriptionChanged(
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.pink,
          title: Text(isEditing
              ? 'Edit Day Off on ${widget.daySelected.day}.${widget.daySelected.month}.${widget.daySelected.year}'
              : 'Add Day Off on ${widget.daySelected.day}.${widget.daySelected.month}.${widget.daySelected.year}'),
        ),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
              key: _formKey,
              child: ListView(
                children: <Widget>[
                  _buildReasonField(),
                  _buildDescriptionField(),
                  //add container showing the employees name (user help)
                ],
              )),
        ),
        floatingActionButton: BlocBuilder<ShiftsBloc, ShiftsState>(
          builder: (context, state) {
            if (state is CreatedOrEditedDayOff) {
              return FloatingActionButton(
                tooltip: isEditing ? 'Save Changes' : 'Add DayOff',
                child: Icon(isEditing ? Icons.check : Icons.add),
                backgroundColor: Colors.pink,
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();

                    //! Rolly same as add_edit_shift
                    DateEvent dateEvent = DateEvent(
                      dateEvent_date: state.dayOffDate,
                      description: state.description,
                      employeeId: state.employeeId,
                      employeeName: state.employeeName,
                      reason: state.reason,
                      id: state.id,
                    );

                    // save this shift as dateEvent in firestore
                    BlocProvider.of<ShiftsBloc>(context)
                        .add(UploadDateEventAdded(dateEvent: dateEvent));



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
                    // add in employees busy_map
                    BlocProvider.of<EmployeesBloc>(context)
                          .add(UpdateEmployeeBusyMap(employeeDateEvent: employeeDateEvent));
                    
                    Navigator.pop(context);
                  }
                },
              );
            }
            else {
              return Container(child: Text('ups'),);
            }
          },
        ),
      ),
    );
  }
}
