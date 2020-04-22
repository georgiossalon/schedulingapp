import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:snapshot_test/blocs/blocs.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shifts_repository/shifts_repository.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:snapshot_test/screens/add_edit_shift.dart';
import 'package:snapshot_test/screens/calendar_screen.dart';

void main() {
  BlocSupervisor.delegate = SimpleBlocDelegate();
  initializeDateFormatting().then((_) => runApp(ShiftsApp()));
  // runApp(ShiftsApp());
}

class ShiftsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider<ShiftsBloc>(
        create: (context) {
          return ShiftsBloc(
            shiftsRepository: FirebaseShiftsRepository(),
          )..add(LoadShifts());
        },
        child: MaterialApp(
          initialRoute: CalendarScreen.screenId,
          routes: {
            CalendarScreen.screenId: (context) {
              return BlocBuilder<ShiftsBloc, ShiftsState>(
                builder: (context, state) {
                  if (state is ShiftsLoading) {
                    return Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Container(
                          child: Text(
                            'Loading',
                            style: TextStyle(fontSize: 20.0),
                          ),
                        ));
                  } else if (state is ShiftsLoaded) {
                    // final shiftsList = state.shifts;
                    // Map<DateTime, List<Shift>> map =
                    //     CalendarScreen.shiftListToCalendarEventMap(shiftsList);
                    // return Calendar(
                    //   map: map,
                    // );
                    return CalendarScreen();
                  } else {
                    return Container(
                      child: Text('Shit happens'),
                    );
                  }
                },
              );
            },
            AddEditShift.screenId: (context) {}
          },
        ),
      ),
    );
  }
}
