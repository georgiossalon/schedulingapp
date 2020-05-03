import 'package:employees_repository/employees_repository.dart';
import 'package:flutter/material.dart';
import 'package:snapshot_test/widgets/calendar_widget.dart';
import 'package:intl/intl.dart';

class EmployeeAvailability extends StatelessWidget {
  static const String screenId = 'employee_availability';
  final Employee employee;
  static DateTime selectedDay = DateTime.now();

  const EmployeeAvailability({Key key, this.employee}) : super(key: key);

   static Map<DateTime, List<dynamic>> unavailabilityListToCalendarMap (List<Unavailability> currentWeekUnavailability) {
    Map<DateTime, List<dynamic>> hMap = new Map<DateTime, List<dynamic>>();
    for (Unavailability unavailability in currentWeekUnavailability) {
      //!! only one event is allowed for the availability calendar
      //!! still I use a List. Change this in the future?
      hMap[unavailability.unavailabilityDate] = [unavailability];
    }
    return hMap;
  }
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
          child: Scaffold(
            appBar: AppBar(
              title: Text('Employee Availability'),
            ),
        body: CalendarWidget(
          selectedDay: selectedDay,
          map: unavailabilityListToCalendarMap(employee.currentWeekUnavailability),
          isShift: false,
        ),
      ),
    );
  }
}
