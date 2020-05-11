import 'package:flutter/material.dart';
import 'package:employees_repository/employees_repository.dart';
import 'package:snapshot_test/core/validators.dart';
import 'package:snapshot_test/employee/blocs/designations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

typedef OnSaveCallback = Function(
  String designation,
  String employeeName,
  double weeklyHours,
  double salary,
  String email,
  DateTime hiringDate,
  Map<DateTime, bool> busyMap,
);

class AddEditEmployee extends StatefulWidget {
  static const String screenId = 'add_edit_employee';

  final bool isEditing;
  final OnSaveCallback onSave;
  final Employee employee;

  AddEditEmployee(
      {Key key, @required this.onSave, @required this.isEditing, this.employee})
      : super(key: key);

  @override
  _AddEditEmployeeState createState() => _AddEditEmployeeState();
}

class _AddEditEmployeeState extends State<AddEditEmployee> {
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _designation;
  String _employeeName;
  double _weeklyHours;
  double _salary;
  String _email;
  DateTime _hiringDate;
  Map<DateTime, bool> _busyMap;

  bool get isEditing => widget.isEditing;

  Future<DateTime> selectDate(BuildContext context) async {
    final DateTime _picked = await showDatePicker(
      firstDate: DateTime(1980),
      lastDate: DateTime.now().add((Duration(days: 60))),
      context: context,
      initialDate: _hiringDate == null ? DateTime.now() : _hiringDate,
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
      _designation = widget.employee.designation;
      _employeeName = widget.employee.name;
      _weeklyHours = widget.employee.weeklyHours;
      _salary = widget.employee.salary;
      _email = widget.employee.email;
      _hiringDate = widget.employee.hiringDate;
    } else {
      _designation = 'open';
    }
  }

  Widget _buildNameField() {
    return TextFormField(
      initialValue: _employeeName,
      autofocus: !isEditing,
      decoration: InputDecoration(labelText: 'Employee Name'),
      validator: (String value) {
        return value.trim().isEmpty ? 'Please give a Employee Name' : null;
      },
      onSaved: (String value) {
        _employeeName = value.trim();
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
                onChanged: (String newValue) {
                  setState(() {
                    _designation = newValue;
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

  Widget _buildSalaryField() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Salary'),
      initialValue: isEditing ? widget.employee.salary.toString() : '',
      keyboardType: TextInputType.number,
      validator: (String value) {
        // in germany the use "," instead of "." for decimals
        value = value.replaceFirst(RegExp(','), '.');
        double salary = double.tryParse(value);
        if (salary == null || salary <= 0) {
          return 'A valid Salary is Required';
        }
      },
      onSaved: (String value) {
        _salary = double.parse(value.trim());
      },
    );
  }

  Widget _buildWeeklyHoursField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Weekly Working Hours',
      ),
      initialValue: isEditing ? widget.employee.weeklyHours.toString() : '',
      keyboardType: TextInputType.number,
      validator: (String value) {
        double number = double.tryParse(value);
        if (number == null) {
          return 'Weekly Hours are Required';
        }
      },
      onSaved: (String value) {
        _weeklyHours = double.parse(value.trim());
      },
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Email'),
      initialValue: _email,
      keyboardType: TextInputType.emailAddress,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Email is Required';
        }
        //todo: the mail has regexp has to get stricted, e.x. 1@1.c is not a valid mail for firestore
        if (!Validators.isValidEmail(value)) {
          return 'Please enter a valid email Address';
        }

        return null;
      },
      onSaved: (String value) {
        _email = value.trim();
      },
    );
  }

  //todo add validator?
  Widget _hiringDateButton() {
    return RaisedButton(
      child: Text(_hiringDate == null
          ? 'Pick Hiring Date'
          : 'Hiring Date: ${_hiringDate.day}.${_hiringDate.month}.${_hiringDate.year}'),
      onPressed: () async {
        DateTime dateTimeOfHiring = await selectDate(context);
        setState(() {
          if (dateTimeOfHiring != null) {
            _hiringDate = dateTimeOfHiring;
          }
        });
      },
    );
  }

  Map<DateTime, bool> setEmployeeBusy() {
    DateTime mondayOfCurrentWeek =
        DateTime.now().subtract(new Duration(days: DateTime.now().weekday - 1));
    // DateTime dateOfSundayForXthWeek =
    //     mondayOfCurrentWeek.add(new Duration(days: 7 - 1));
    Map<DateTime, bool> hMap = new Map<DateTime, bool>();
    DateTime hDate = mondayOfCurrentWeek;
    for (var i = 0; i < 7; i++) {
      hMap[hDate] = false;
      hDate = hDate.add(new Duration(days: 1));
    }
    return hMap;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.pink,
          title: Text(isEditing
              ? 'Edit Employee: ${widget.employee.name}'
              : 'Add Employee'),
        ),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: <Widget>[
                _buildNameField(),
                _buildDesignationField(),
                _buildWeeklyHoursField(),
                _buildSalaryField(),
                _buildEmailField(),
                _hiringDateButton(),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          tooltip: isEditing ? 'Save Changes' : 'Add Employee',
          child: Icon(isEditing ? Icons.check : Icons.add),
          backgroundColor: Colors.pink,
          onPressed: () {
            if (_formKey.currentState.validate()) {
              _formKey.currentState.save();
              widget.onSave(
                  _designation,
                  _employeeName,
                  _weeklyHours,
                  _salary,
                  _email,
                  _hiringDate,
                  _busyMap == null
                      ? setEmployeeBusy()
                      : widget.employee.busyMap);
              Navigator.pop(context);
            }
          },
        ),
      ),
    );
  }
}
