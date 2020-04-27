import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:snapshot_test/blocs/blocs.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shifts_repository/shifts_repository.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:snapshot_test/screens/add_edit_shift.dart';
import 'package:snapshot_test/widgets/calendar_screen.dart';
import 'package:snapshot_test/screens/home_screen.dart';
import 'package:snapshot_test/screens/splash_screen.dart';
import 'package:user_repository/user_repository.dart';

import 'blocs/authentication_bloc/authentication.dart';
import 'blocs/login/login.dart';

void main() {
  BlocSupervisor.delegate = SimpleBlocDelegate();
  initializeDateFormatting().then((_) => runApp(ShiftsApp()));
}

class ShiftsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthenticationBloc>(create: (context) {
          return AuthenticationBloc(
            userRepository: FirebaseUserRepository(),
          )..add(AppStarted());
        }),
        BlocProvider<ShiftsBloc>(create: (context) {
          return ShiftsBloc(
            shiftsRepository: FirebaseShiftsRepository(),
          )..add(LoadShifts());
        })
      ],
      // todo after restarting the app the user is still loged in
      child: MaterialApp(
        theme: ThemeData(primaryColor: Colors.pink),
        initialRoute: HomeScreen.screenId,
        routes: {
          HomeScreen.screenId: (context) {
            return BlocBuilder<AuthenticationBloc, AuthenticationState>(
                builder: (context, state) {
              if (state is Uninitialized) {
                // todo edit the splash screen
                return SplashScreen();
              } else if (state is Authenticated) {
                return BlocProvider<TabBloc>(
                  create: (context) => TabBloc(),
                  child: HomeScreen(userEmail: state.userEmail,),
                );
              } else if (state is Unauthenticated) {
                return LoginScreen(
                  userRepository: FirebaseUserRepository(),
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            });
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
    );
  }
}
