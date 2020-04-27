import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snapshot_test/blocs/blocs.dart';
import 'package:snapshot_test/widgets/calendar_screen.dart';
import 'package:snapshot_test/widgets/widgets.dart';
import 'package:snapshot_test/models/models.dart';

class HomeScreen extends StatelessWidget {
  static const String screenId = 'home_screen';
  final String userEmail;

  HomeScreen({Key key, @required this.userEmail}) : super(key: key);
  
  Widget setBody(AppTab activeTab) {
    if (activeTab == AppTab.calendar) {
      return CalendarWidget();
    } else if( activeTab == AppTab.currentDay) {
      //todo
    } else if (activeTab == AppTab.user) {
      return UserPage(userEmail: userEmail,);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TabBloc, AppTab>(
      builder: (context, activeTab) {
        return Scaffold(
          body: setBody(activeTab),
          bottomNavigationBar: TabSelector(
            activeTab: activeTab,
            onTabSelected: (tab) =>
                BlocProvider.of<TabBloc>(context).add(UpdateTab(tab)),
          ),
        );
      },
    );
  }
}