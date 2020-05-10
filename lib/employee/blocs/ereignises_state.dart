import 'package:equatable/equatable.dart';
import 'package:employees_repository/employees_repository.dart';

abstract class EreignisesState extends Equatable {
  const EreignisesState();

  @override
  List<Object> get props => [];
}

class EreignisesLoading extends EreignisesState {}

class EreignisesLoaded extends EreignisesState {
  final List<Ereignis> ereignises;

  const EreignisesLoaded([this.ereignises = const[]]);

  @override
  List<Object> get props => [ereignises];

  @override
  String toString() => 'Ereignises {ereignises $ereignises }';
}

class ShiftEreignisesLoaded extends EreignisesState {
  final List<Ereignis> ereignises;

  const ShiftEreignisesLoaded([this.ereignises = const[]]);

  @override
  List<Object> get props => [ereignises];

  @override
  String toString() => 'Ereignises {ereignises $ereignises }';
}

// class EreignisesForGivenEmployeeLoaded extends EreignisesState {
//   final List<Ereignis> ereignises;
//   final String employeeId;

//   const EreignisesForGivenEmployeeLoaded([this.ereignises = const[], this.employeeId]);

//   @override
//   List<Object> get props => [ereignises, employeeId];

//   @override
//   String toString() => 'Ereignises { ereignises $ereignises for employeeId: $employeeId }';
// }

class EreignisesNotLoaded extends EreignisesState {}