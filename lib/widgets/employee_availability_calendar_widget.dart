import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:snapshot_test/blocs/blocs.dart';

class EmployeeAvailabilityCalendarWidget extends StatelessWidget {
  static const String screenId = 'availability_calendar_widget';
  static DateTime selectedDay = DateTime.now();

  const EmployeeAvailabilityCalendarWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //todo I only want to load data from one employee
    // return BlocBuilder<EmployeesBloc, EmployeesState>(
    //   builder: (context, state) {
    //     return Container();
    //   },
    // );
    
  }
}