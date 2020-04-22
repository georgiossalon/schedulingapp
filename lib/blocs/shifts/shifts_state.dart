import 'package:equatable/equatable.dart';
import 'package:shifts_repository/shifts_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class ShiftsState extends Equatable {
  const ShiftsState();

  @override
  List<Object> get props => [];
}

class ShiftsLoading extends ShiftsState {}

class ShiftsLoaded extends ShiftsState {
  final Map<DateTime, List<Shift>> shiftsMap;

  const ShiftsLoaded([this.shiftsMap = const {}]);

  @override
  List<Object> get props => [_shiftsMap];

  @override
  String toString() => 'ShiftsLoaded {shifts: $shiftsMap }';

  Map<String, List<Shift>> get _shiftsMap =>
      Map<DateTime, List<Shift>>.from(shiftsMap).map(
        (dateTime, shifts) => MapEntry<String, List<Shift>>(
          dateTime.toIso8601String(),
          shifts,
        ),
      );
}

class ShiftsNotLoaded extends ShiftsState {}
