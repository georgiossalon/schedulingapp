import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:snapshot_test/tabs/app_tab.dart';

class CustomTabSelector extends StatelessWidget {
  final AppTab activeTab;
  final Function(AppTab) onTabSelected;

  CustomTabSelector({
    Key key,
    @required this.activeTab,
    @required this.onTabSelected,
  }) : super(key: key);

  IconData iconForNavigationTab(AppTab tab) {
    if (tab == AppTab.calendar) {
      return FontAwesomeIcons.calendarAlt;
    } else if (tab == AppTab.currentDay) {
      return FontAwesomeIcons.calendarDay;
    } else if(tab == AppTab.employees) {
      return FontAwesomeIcons.users;
    } else if (tab == AppTab.user) {
      return FontAwesomeIcons.user;
    }
  }

  Text titleForNavigatorTab(AppTab tab) {
    if (tab == AppTab.calendar) {
          return Text('Calendar');
        } else if (tab == AppTab.currentDay) {
          return Text('Today');
        } else if (tab == AppTab.employees) {
          return Text('Employees');
        } else if (tab == AppTab.user) {
          return Text('User');
        }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: AppTab.values.indexOf(activeTab),
      onTap: (index) => onTabSelected(AppTab.values[index]),
      items: AppTab.values.map((tab) {
        return BottomNavigationBarItem(
          icon: Icon(
            iconForNavigationTab(tab),
          ),
          title: titleForNavigatorTab(tab)
        );
      }).toList(),
    );
  }
}
