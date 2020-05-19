import 'dart:js';

import 'package:employees_repository/employees_repository.dart';
import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shifts_repository/shifts_repository.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:snapshot_test/core/simple_bloc_delegate.dart';
import 'package:snapshot_test/employee/blocs/employees.dart';
import 'package:snapshot_test/employee/screens/add_edit_employee.dart';
import 'package:snapshot_test/shifts/blocs/shifts.dart';
import 'package:snapshot_test/shifts/screens/add_edit_shift.dart';
import 'package:snapshot_test/core/screens/home_screen.dart';
import 'package:snapshot_test/core/screens/splash_screen.dart';
import 'package:snapshot_test/tabs/blocs/tab.dart';
import 'package:user_repository/user_repository.dart';
import 'package:snapshot_test/employee/blocs/date_events.dart';

import 'authentication/blocs/authentication.dart';
import 'employee/blocs/designations.dart';
import 'employee/blocs/employees_bloc.dart';
import 'login/login.dart';

void main() {
  BlocSupervisor.delegate = SimpleBlocDelegate();
  initializeDateFormatting().then((_) => runApp(ShiftsApp()));
  // todo -- runZoned -- set up uncaught exception logging with firebase crashlytics
  // todo -- move all global blocs into a MultiBlocProvider here - eg auth bloc + child ShiftsApp
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
        //fixme: why not load after the Authenticated state?
        //todo: update the employee busy_map snippets each week (cloud functions)
        BlocProvider<EmployeesBloc>(create: (context) {
          return EmployeesBloc(
            employeesRepository: FirebaseEmployeesRepository(),
          );
          // )..add(LoadEmployees());
          // )..add(LoadEmployeesWithGivenDesignation('5',DateTime.now()));
        }
        ,),
        BlocProvider<DesignationsBloc>(create: (context) {
          return DesignationsBloc(employeesRepository: FirebaseEmployeesRepository()
          )..add(LoadDesignations());
        }),
        BlocProvider<DateEventsBloc>(create: (context) {
          return DateEventsBloc(
            context.bloc<DesignationsBloc>(), // consume the same instance
            employeesRepository: FirebaseEmployeesRepository(),
            );
            // )..add(LoadAllShiftsForXWeeks(4));
        },),
        
      ],
      // fixme: after restarting the app the user is still loged in
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
          },
          AddEditEmployee.screenId: (context) {
            return AddEditEmployee(
              onSave: (
                designation,
                employeeName,
                weeklyHours,
                salary,
                email,
                hiringDate,
                busyMap
              ) {
                BlocProvider.of<EmployeesBloc>(context).add(AddEmployee(
                  Employee(
                    designations: designation,
                    name: employeeName,
                    weeklyHours: weeklyHours,
                    salary: salary,
                    email: email,
                    hiringDate: hiringDate,
                    busyMap: busyMap
                  )
                )
                );
              },
              isEditing: false,
            );
          }
        },
      ),
    );
  }
}
