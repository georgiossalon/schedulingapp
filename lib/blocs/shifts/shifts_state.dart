import 'package:equatable/equatable.dart';
import 'package:shifts_repository/shifts_repository.dart';

abstract class ShiftsState extends Equatable {
  const ShiftsState();

  @override
  List<Object> get props => [];
}

class ShiftsLoading extends ShiftsState {}

class ShiftsLoaded extends ShiftsState {
  final List<Shift> shifts;

  const ShiftsLoaded([this.shifts = const[]]);

  @override
  List<Object> get props => [shifts];

  @override
  String toString() => 'ShiftsLoaded {shifts: $shifts }';
}

class ShiftsNotLoaded extends ShiftsState {}