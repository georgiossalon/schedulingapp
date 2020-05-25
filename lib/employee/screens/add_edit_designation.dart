import 'package:flutter/material.dart';
import 'package:snapshot_test/employee/blocs/designations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddEditDesignation extends StatefulWidget {
  static const String screenId = 'add_edit_designation';

  final bool isEditing;

  AddEditDesignation({Key key, this.isEditing}) : super(key: key);

  @override
  _AddEditDesignationState createState() => _AddEditDesignationState();
}

class _AddEditDesignationState extends State<AddEditDesignation> {
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool get isEditing => widget.isEditing;

  Widget _buildDesignationField() {
    return BlocBuilder<DesignationsBloc, DesignationsState>(
      builder: (context, state) {
        return TextFormField(
          initialValue:
              isEditing ? state.designationsObj.currentDesignation : '',
          decoration: InputDecoration(labelText: 'Designation'),
          validator: (String value) {
            return value.trim().isEmpty
                ? 'Please set a Designation for the Employee'
                : null;
          },
          onChanged: (String value) {
            // _designation = value.trim();
            BlocProvider.of<DesignationsBloc>(context)
                .add(DesignationChanged(designationChanged: value));
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.pink,
          title: Text(isEditing ? 'Edit Designation' : 'Add Designation'),
        ),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: _buildDesignationField(),
          ),
        ),
        floatingActionButton: BlocBuilder<DesignationsBloc, DesignationsState>(
          builder: (context, state) {
            return FloatingActionButton(
              tooltip: isEditing ? 'Save Changes' : 'Add Employee',
              child: Icon(isEditing ? Icons.check : Icons.add),
              backgroundColor: Colors.pink,
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  _formKey.currentState.save();
                  //todo: add designation event to save in firestore
                  BlocProvider.of<DesignationsBloc>(context).add(
                    DesignationUploaded(designationsObj: state.designationsObj)
                  );
                  Navigator.pop(context);
                }
              },
            );
          },
        ),
      ),
    );
  }
}
