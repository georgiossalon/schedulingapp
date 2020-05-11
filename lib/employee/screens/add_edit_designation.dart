import 'package:flutter/material.dart';

typedef OnSaveCallBack = Function(
  String designation,
);

class AddEditDesignation extends StatefulWidget {
  static const String screenId = 'add_edit_designation';

  final bool isEditing;
  final OnSaveCallBack onSave;
  final String designation;

  AddEditDesignation({Key key, this.isEditing, this.onSave, this.designation})
      : super(key: key);

  @override
  _AddEditDesignationState createState() => _AddEditDesignationState();
}

class _AddEditDesignationState extends State<AddEditDesignation> {
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _designation;

  bool get isEditing => widget.isEditing;

  Widget _buildDesignationField() {
    return TextFormField(
      initialValue: isEditing ? widget.designation : '',
      decoration: InputDecoration(labelText: 'Designation'),
      validator: (String value) {
        return value.trim().isEmpty
            ? 'Please set a Designation for the Employee'
            : null;
      },
      onSaved: (String value) {
        _designation = value.trim();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
          child: Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.pink,
            title: Text(isEditing
                ? 'Edit Designation: ${widget.designation}'
                : 'Add Designation'),
          ),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: _buildDesignationField(),
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
                );
                Navigator.pop(context);
              }
            },
          ),
      ),
    );
  }
}
