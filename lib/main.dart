import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:snapshot_test/blocs/blocs.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shifts_repository/shifts_repository.dart';
import 'package:snapshot_test/widgets/calendar.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  BlocSupervisor.delegate = SimpleBlocDelegate();
  initializeDateFormatting().then((_) => runApp(ShiftsApp()));
  // runApp(ShiftsApp());
}


class ShiftsApp extends StatelessWidget {

static Map<DateTime, List<Shift>> shiftListToCalendarEventMap(List<Shift> shiftList) {
    Map<DateTime, List<Shift>> map = {};
    for (int i = 0; i < shiftList.length; i++) {
      Shift shift = shiftList[i];
      DateTime shiftDateTime = shift.shift_date;
      if (map[shiftDateTime] == null) {
        // creating a new List and passing a widget
        map[shiftDateTime] = [shift];
      } else {
        List<Shift> helpList = map[shiftDateTime];
        helpList.add(shift);
      }
    }
    return map;
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider<ShiftsBloc>(
        create: (context) {
          return ShiftsBloc(
            shiftsRepository: FirebaseShiftsRepository(),
          )..add(LoadShifts());
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
            final shiftsList = state.shifts;
            Map<DateTime,List<Shift>> map = ShiftsApp.shiftListToCalendarEventMap(shiftsList);
            print(map);
            //todo work with the map above to arange the shifts within the calendar
            return Container(
              child: Column(
                children: <Widget>[
                  //fixme: how to get the selected day?
                  Calendar(),
                  Expanded(
                    child: ListView.builder(
                      itemCount: shiftsList.length,
                      itemBuilder: (context, index) {
                        final shift = shiftsList[index];
                        // return _buildShiftContainer(shift: shift);
                      },
                    ),
                  ),
                ],
              ),
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

  Widget _buildShiftContainer({Shift shift}) {
//    new Builder(builder: (gestureBuilder) {
    return Container(
//      height: 250.0,
      color: Colors.blueGrey,
      height: 65.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
//            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text(
                'Start ${shift.start_shift}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17.0,
                ),
              ),
              SizedBox(
                width: 20.0,
              ),
              Text(
                'End ${shift.end_shift}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17.0,
                ),
              ),
            ],
          ),
          Text(
            'Designation: ${shift.designation}',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),
            textAlign: TextAlign.left,
          ),
          Text(
            'Employee: ${shift.employee}',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),
            textAlign: TextAlign.left,
          ),
          Visibility(
            visible: false,
            child: Row(
              children: <Widget>[
                Text(
                  '${shift.id}',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),
                  textAlign: TextAlign.left,
                ),
                // Text(
                //   '${shift.firestoreId}',
                //   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),
                //   textAlign: TextAlign.left,
                // )
              ],
            ),
          ),
        ],
      ),
    );
//    });
  }
}
