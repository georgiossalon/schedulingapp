import 'package:flutter/material.dart';
import 'package:employees_repository/employees_repository.dart';
import 'package:snapshot_test/core/validators.dart';
import 'package:snapshot_test/employee/blocs/designations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

typedef OnSaveCallback = Function(
  List<String> designation,
  String employeeName,
  double weeklyHours,
  double salary,
  String email,
  DateTime hiringDate,
  Map<DateTime, String> busyMap,
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

  List<String> _designations;
  String _employeeName;
  double _weeklyHours;
  double _salary;
  String _email;
  DateTime _hiringDate;
  Map<DateTime, String> _busyMap;

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
      _designations = widget.employee.designations;
      _employeeName = widget.employee.name;
      _weeklyHours = widget.employee.weeklyHours;
      _salary = widget.employee.salary;
      _email = widget.employee.email;
      _hiringDate = widget.employee.hiringDate;
    } else {
      _designations = new List();
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

  String listToString(List<String> designationsList) {
    String hString = '';
    for (String designation in designationsList) {
      if (hString.isEmpty) {
        hString = designation;
      } else {
        hString = hString + ', ' + designation;
      }
    }
    return hString;
  }

  Widget _buildDesignationField(BuildContext context) {
    return BlocBuilder<DesignationsBloc, DesignationsState>(
      builder: (context, state) {
        if (state is DesignationsLoading) {
          return Container(
            child: Text('Loading'),
          );
        } else if (state is DesignationsLoaded) {
          return Container(
            height: 70.0,
            decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey))),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          child: Padding(
                            padding: EdgeInsets.only(top: 6.0),
                            child: Text(
                              'Designations:',
                              style: TextStyle(
                                color: Colors.grey.shade700,
                                fontSize: 15.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Align(
                        child: Container(
                            width: 250.0,
                            height: 25.0,
                            child: Text(
                              '${listToString(_designations)} ',
                            )),
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: ButtonTheme(
                      height: 30.0,
                      // child: Container(),
                      child: FlatButton(
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        color: Colors.blueGrey.shade200,
                        onPressed: () {
                          // I need this map to see which designations are
                          // assigned to an employee
                          Map<String, bool> hCheck = new Map<String, bool>();
                          for (var i = 0; i < state.designationsObj.designations.length; i++) {
                            hCheck[state.designationsObj.designations[i]] = false;
                          }
                          if (_designations.isNotEmpty) {
                            // this means I am editing an employee and I have
                            // to take his old designations into consideration
                            for (String designation in _designations) {
                              hCheck[designation] = true;
                            }
                          }
                          
                          showDialog(
                              context: context,
                              builder: (context) => DesignationDialog(
                                    allDesignations: state.designationsObj.designations,
                                    hChecked: hCheck,
                                    employeesDesignations: _designations,
                                    parent: this,
                                  ));
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0)),
                        child: Text(
                          'Add/Edit',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
          // return InputDecorator(
          //   decoration: InputDecoration(
          //     icon: Icon(FontAwesomeIcons.tasks),
          //     labelText: 'Designation',
          //   ),
          //   child: DropdownButtonHideUnderline(
          //     child: DropdownButton<String>(
          //       items: state.designations.map((Designation designation) {
          //         return new DropdownMenuItem<String>(
          //           value: designation.designation,
          //           child: Text(designation.designation),
          //         );
          //       }).toList(),
          //       onChanged: (String newValue) {
          //         setState(() {
          //           _designation = newValue;
          //         });
          //       },
          //       value: _designation,
          //     ),
          //   ),
          // );

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

  // Map<DateTime, bool> setEmployeeBusy() {
  //   DateTime mondayOfCurrentWeek =
  //       DateTime.now().subtract(new Duration(days: DateTime.now().weekday - 1));
  //   // DateTime dateOfSundayForXthWeek =
  //   //     mondayOfCurrentWeek.add(new Duration(days: 7 - 1));
  //   Map<DateTime, bool> hMap = new Map<DateTime, bool>();
  //   DateTime hDate = mondayOfCurrentWeek;
  //   for (var i = 0; i < 7; i++) {
  //     hMap[hDate] = false;
  //     hDate = hDate.add(new Duration(days: 1));
  //   }
  //   return hMap;
  // }

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
                _buildDesignationField(context),
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
                  _designations,
                  _employeeName,
                  _weeklyHours,
                  _salary,
                  _email,
                  _hiringDate,
                  _busyMap == null
                      ? Map<DateTime,String>()
                      : widget.employee.busyMap);
              Navigator.pop(context);
            }
          },
        ),
      ),
    );
  }
}

class DesignationDialog extends StatefulWidget {
  final List<String> allDesignations;
  final List<String> employeesDesignations;
  final Map<String, bool> hChecked;
  _AddEditEmployeeState parent;

  DesignationDialog(
      {Key key,
      this.allDesignations,
      this.hChecked,
      this.employeesDesignations,
      this.parent})
      : super(key: key);

  @override
  _DesignationDialogState createState() => _DesignationDialogState();
}

class _DesignationDialogState extends State<DesignationDialog> {
  _buildDialogChild(BuildContext context, List<String> allDesignations) {
    return Container(
      height: 200.0,
      child: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
                itemCount: allDesignations.length,
                itemBuilder: (context, index) {
                  // -- With Switch
                  return Row(
                    children: <Widget>[
                      Expanded(
                          child: Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          height: 20.0,
                          child: Text(
                            allDesignations[index],
                            style: TextStyle(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          width: 90.0,
                          color: widget
                                  .hChecked[allDesignations[index]]
                              ? Colors.green
                              : Colors.grey,
                        ),
                      )),
                      Expanded(
                        child: SwitchListTile(
                            value: widget
                                .hChecked[allDesignations[index]],
                            onChanged: (bool value) {
                              setState(() {
                                widget.hChecked[
                                    allDesignations[index]] = value;
                              });
                            }),
                      )
                    ],
                  );
                  // -- end

                  // return ButtonTheme(
                  //   //todo: fix the width of the buttons is not working
                  //   minWidth: 20,
                  //   child: RaisedButton(
                  //     color: widget.hChecked[hDesignations[index].designation]
                  //         ? Colors.green
                  //         : Colors.grey,
                  //     child: Text(hDesignations[index].designation),
                  //     onPressed: () {
                  //       //todo mark designation and add to an array
                  //       setState(() {
                  //         widget.hChecked[hDesignations[index].designation] =
                  //             !widget
                  //                 .hChecked[hDesignations[index].designation];
                  //       });
                  //     },
                  //   ),
                  // );
                }),
          ),
          SizedBox(
            height: 15.0,
          ),
          RaisedButton(
            color: Colors.blueGrey,
            child: Text(
              'set',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              // so that I update the code in the parent widget
              widget.parent.setState(() {

              widget.hChecked.forEach((k, v) {
                if (v == true) {
                  // The chosen designations have to get added to the employees
                  // designations set
                  if (!widget.employeesDesignations.contains(k)) {
                    widget.employeesDesignations.add(k);
                  }
                } else {
                  // remove the values if existant from the designation list
                  if (widget.employeesDesignations.contains(k)) {
                    widget.employeesDesignations.remove(k);
                  }
                  
                }
              });
              });
              Navigator.of(context).pop();
              //todo when clicking on set also the main widget should get rebuild
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // -- I need the Align to contain the Container.
    // so that I can choose a custom width
    return Align(
      child: Container(
        width: 300.0,
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusDirectional.circular(8.0),
          ),
          child: _buildDialogChild(context, widget.allDesignations),
        ),
      ),
    );
  }
}
