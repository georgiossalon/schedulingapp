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
  final Map<DateTime,List<Shift>> shiftsMap;

  const ShiftsLoaded([this.shiftsMap = const{}]);

  @override
  List<Object> get props => [shiftsMap];

  @override
  String toString() => 'ShiftsLoaded {shifts: $shiftsMap }';
}

class ShiftsNotLoaded extends ShiftsState {}