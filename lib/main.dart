import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:snapshot_test/blocs/blocs.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shifts_repository/shifts_repository.dart';

void main() {
  BlocSupervisor.delegate = SimpleBlocDelegate();
  runApp(ShiftsApp());
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
          // )..add(AppStarted());
        },
        child: ShiftListPage(),
      ),
    );
  }
}

class ShiftListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ShiftsBloc, ShiftsState>(
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
            final shifts = state.shifts;
            return ListView.builder(
              itemCount: shifts.length,
              itemBuilder: (context, index) {
                final shift = shifts[index];
                return Text('shift');
              },
            );
          } else {
            return Container(
              child: Text('Shit happens'),
            );
          }
        },
      ),
    );
  }
}

