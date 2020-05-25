
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
    return BlocBuilder<DesignationsBloc, DesignationsState>(
      builder: (context, state) {
        if (state.designationsObj == null) {
          return Container(
            child: Text('Loading'),
          );
        } else if (state.designationsObj.designations != null) {
          return SafeArea(
            child: Scaffold(
              appBar: AppBar(
                title: Text('Designation List'),
              ),
              body: ListView.builder(
                  itemCount: state.designationsObj.designations.length,
                  itemBuilder: (context, index) {
                    return DesignationContainer(
                        designation: state.designationsObj.designations[index]);
                  }),
              floatingActionButton: FloatingActionButton(
                child: Icon(Icons.add),
                backgroundColor: Colors.pink,
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    //  todo use DesignationCreated event
                    BlocProvider.of<DesignationsBloc>(context)
                        .add(DesignationCreated(designationsObj: state.designationsObj));

                    return AddEditDesignation(
                      // onSave: (
                      //   designation,
                      // ) {
                      //   BlocProvider.of<DesignationsBloc>(context).add(
                      //     AddDesignation(
                      //       designationsObj: Designations(
                      //           designations:
                      //               state.designationsObj.designations,
                      //           id: state.designationsObj
                      //               .id //! id at the first time null
                      //           ),
                      //     ),
                      //   );
                      // },
                      isEditing: false,
                    );
                  }));
                },
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
