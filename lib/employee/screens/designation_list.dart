import 'package:employees_repository/employees_repository.dart';
import 'package:flutter/material.dart';
import 'package:snapshot_test/employee/blocs/designations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snapshot_test/employee/blocs/designations_bloc.dart';
import 'package:snapshot_test/employee/widgets/designation_container.dart';

import 'add_edit_designation.dart';

class DesignationList extends StatelessWidget {
  static const String screenId = 'designation_list';

  const DesignationList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DesignationsBloc,DesignationsState>(
      builder: (context, state) {
        if (state.designations.isEmpty) {
          return Container(child: Text('Loading'),);
        } else if (state.designations.isNotEmpty) {
          return SafeArea(
            child: Scaffold(
          appBar: AppBar(title: Text('Designation List'),),
          body: ListView.builder(
            itemCount: state.designations.length,
            itemBuilder: (context,index) {
              return DesignationContainer(designation: state.designations[index]);
            }),
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.add),
              backgroundColor: Colors.pink,
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                  return AddEditDesignation(
                    onSave:(
                      designation,
                    ) {
                      BlocProvider.of<DesignationsBloc>(context).add(AddDesignation(
                        Designation(
                          designation: designation,
                        )
                      ));
                      //todo add the designation to the open Employee
                      //! this must have as a pre-requisite an open employee in the list
                    },
                    isEditing: false,
                  );
                }));
              },
            ),
        ),
      );
        }
      },
    );
  }
}