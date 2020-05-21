import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snapshot_test/employee/blocs/employees.dart';
import 'package:snapshot_test/date_events/blocs/date_events.dart';
import 'package:snapshot_test/date_events/blocs/shifts.dart';
import 'package:snapshot_test/date_events/widgets/shifts_view.dart';
import 'package:snapshot_test/current_day/current_day.dart';
import 'package:snapshot_test/employee/widgets/employees_list.dart';
import 'package:snapshot_test/tabs/app_tab.dart';
import 'package:snapshot_test/tabs/blocs/tab.dart';
import 'package:snapshot_test/tabs/widgets/custom_tab_selector.dart';
import 'package:snapshot_test/user/user_widget.dart';

class HomeScreen extends StatelessWidget {
  static const String screenId = 'home_screen';
  final String userEmail;

  HomeScreen({Key key, @required this.userEmail}) : super(key: key);

  Widget setBody(AppTab activeTab, BuildContext context) {
    if (activeTab == AppTab.calendar) {
      return ShiftsView();
    } else if (activeTab == AppTab.currentDay) {
      return CurrentDay();
    } else if (activeTab == AppTab.user) {
      return UserWidget(
        userEmail: userEmail,
      );
    } else if (activeTab == AppTab.employees) {
      return EmployeesList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TabBloc, AppTab>(
      builder: (context, activeTab) {
        return SafeArea(
          child: Scaffold(
            body: setBody(activeTab, context),
            bottomNavigationBar: CustomTabSelector(
                activeTab: activeTab,
                onTabSelected: (tab) {
                  BlocProvider.of<TabBloc>(context).add(UpdateTab(tab));
                  //! where should I use this instead?
                  if (tab == AppTab.calendar) {
                    BlocProvider.of<DateEventsBloc>(context)
                        .add(LoadAllShiftsForXWeeks(4));
                  } else if (tab == AppTab.employees) {
                    BlocProvider.of<EmployeesBloc>(context)
                        .add(LoadEmployees());
                  }
                }),
          ),
        );
      },
    );
  }
}
