import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:snapshot_test/tabs/app_tab.dart';
import 'package:snapshot_test/tabs/blocs/tab.dart';

class TabBloc extends Bloc<TabEvent, AppTab> {
  @override
  AppTab get initialState => AppTab.currentDay;

  @override
  Stream<AppTab> mapEventToState(TabEvent event) async* {
    if (event is UpdateTab) {
      yield event.tab;
    }
  }

}
