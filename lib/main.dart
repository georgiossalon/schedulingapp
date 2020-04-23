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
}

class ShiftsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.pink
      ),
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
              //todo do I have to use a bloc provider here?
              return CalendarScreen();
            },
            AddEditShift.screenId: (context) {
              return AddEditShift(
                onSave: (
                  designation,
                  employeeName,
                  start_shift,
                  end_shift,
                  shift_date,
                ) {
                  BlocProvider.of<ShiftsBloc>(context).add(AddShift(
                    Shift(
                      designation: designation,
                      employee: employeeName,
                      start_shift: start_shift,
                      end_shift: end_shift,
                      shift_date: shift_date,
                    ),
                  ));
                },
                isEditing: false,
              );
            }
          },
        ),
      ),
    );
  }
}
