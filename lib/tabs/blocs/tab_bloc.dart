import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:snapshot_test/blocs/tab/tab.dart';
import 'package:snapshot_test/models/models.dart';

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
