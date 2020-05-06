import 'package:employees_repository/employees_repository.dart';
import 'package:flutter/material.dart';

typedef OnSaveCallback = Function(
  String reason,
  String description,
  DateTime daySelected,
);

class AddEditEmployeeUnavailability extends StatefulWidget {
  static const String screenId = 'add_edit_employee_unavailability';

  final DateTime daySelected;
  final bool isEditing;
  final OnSaveCallback onSave;
  final Unavailability unavailability;

  AddEditEmployeeUnavailability({
    Key key,
    this.daySelected,
    this.isEditing,
    this.onSave,
    this.unavailability,
  }) : super(key: key);

  @override
  _AddEditEmployeeUnavailabilityState createState() =>
      _AddEditEmployeeUnavailabilityState();
}

class _AddEditEmployeeUnavailabilityState
    extends State<AddEditEmployeeUnavailability> {
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _reason;
  String _description;

  bool get isEditing => widget.isEditing;

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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.pink,
          title: Text(
            isEditing
                ? 'Edit Unavailability on ${widget.daySelected.day}.${widget.daySelected.month}.${widget.daySelected.year}'
                : 'Add Unavailability on ${widget.daySelected.day}.${widget.daySelected.month}.${widget.daySelected.year}',
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
              key: _formKey,
              child: ListView(
                children: <Widget>[
                  TextFormField(
                    initialValue: isEditing ? widget.unavailability.reason : '',
                    autofocus: !isEditing,
                    decoration: InputDecoration(
                        hintText: 'Reason for the Unavailability'),
                      validator: (val) {
                        return val.trim().isEmpty
                            ? 'Please give a Reason'
                            : null;
                      },
                      onSaved: (value) => _reason = value,
                  ),
                  TextFormField(
                    initialValue: isEditing ? widget.unavailability.description : '',   
                    decoration: InputDecoration(hintText: 'Unavailability Description'),
                    validator: (val) {
                      return val.trim().isEmpty
                          ? 'Please give a description'
                          : null;
                    },
                    onSaved: (value) => _description = value,
                  )
                ],
              )),
        ),
        floatingActionButton: FloatingActionButton(
          tooltip: isEditing ? 'Save Changes' : 'Add Unavailability',
          child: Icon(isEditing ? Icons.check : Icons.add),
          backgroundColor: Colors.pink,
          onPressed: () {
            if (_formKey.currentState.validate()) {
              _formKey.currentState.save();
              widget.onSave(
                _reason,
                _description,
                widget.daySelected,
              );
              Navigator.pop(context);
            }
          },
        ),
      ),
    );
  }
}
