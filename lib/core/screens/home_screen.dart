import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snapshot_test/authentication/blocs/authentication.dart';
import 'package:snapshot_test/employee/blocs/employees.dart';
import 'package:snapshot_test/date_events/blocs/date_events.dart';
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

  @override
  Widget build(BuildContext context) {
    return BlocListener<TabBloc, AppTab>(
      listener: (context, activeTab) {
        if (activeTab == AppTab.calendar) {
          BlocProvider.of<DateEventsBloc>(context)
              .add(LoadAllShiftsForXWeeks(4));
        } else if (activeTab == AppTab.employees) {
          BlocProvider.of<EmployeesBloc>(context).add(LoadEmployees());
        }
      },
      child: SafeArea(
        child: Scaffold(
          body: const _HomeScreenBody(),
          bottomNavigationBar: const _BottomNavBar(),
        ),
      ),
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  const _BottomNavBar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TabBloc, AppTab>(
      builder: (context, activeTab) {
        return CustomTabSelector(
            activeTab: activeTab,
            onTabSelected: (tab) {
              BlocProvider.of<TabBloc>(context).add(UpdateTab(tab));
            });
      },
    );
  }
}

class _HomeScreenBody extends StatelessWidget {
  const _HomeScreenBody({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TabBloc, AppTab>(
      // condition: (previous, current) => previous.index != current.index,
      builder: (context, activeTab) {
        if (activeTab == AppTab.calendar) {
          return ShiftsView();
        } else if (activeTab == AppTab.currentDay) {
          return CurrentDay();
        } else if (activeTab == AppTab.user) {
          return UserWidget(
            userEmail:
                (context.bloc<AuthenticationBloc>().state as Authenticated)
                        ?.userEmail ??
                    '',
          );
        } else if (activeTab == AppTab.employees) {
          return EmployeesList();
        } else {
          return Container(
            child: Text('ups'),
          );
        }
      },
    );
  }
}
