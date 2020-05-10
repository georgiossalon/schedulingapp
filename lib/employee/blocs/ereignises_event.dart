import 'package:equatable/equatable.dart';
import 'package:employees_repository/employees_repository.dart';
import 'package:snapshot_test/employee/blocs/ereignises.dart';

abstract class EreignisesEvent extends Equatable {
  const EreignisesEvent();

  @override
  List<Object> get props => [];
}

class LoadAllEreignisesForEmployeeForXWeeks extends EreignisesEvent {
  final String employeeId;
  final int numOfWeeks;

  const LoadAllEreignisesForEmployeeForXWeeks(this.employeeId, this.numOfWeeks);

  @override
  List<Object> get props => [employeeId, numOfWeeks];

  @override
  String toString() => 'LoadEreignises for employeeId: $employeeId for numOfWeeks: $numOfWeeks';
}

class LoadAllShiftsForXWeeks extends EreignisesEvent {
  final int numOfWeeks;

  const LoadAllShiftsForXWeeks(this.numOfWeeks);

  @override
  List<Object> get props => [numOfWeeks];

  @override
  String toString() => 'LoadAllShifts for numOfWeeks: $numOfWeeks';
}

class AddEreignis extends EreignisesEvent {
  final Ereignis ereignis;
  // I can still assign shifts to the "employee" 'Open'

  const AddEreignis(this.ereignis);

  @override
  List<Object> get props => [ereignis];

  @override
  String toString() => 'AddEreignis { ereignis: $ereignis for parentId: ${ereignis.parentId} }';
}

class UpdateEreignis extends EreignisesEvent {
  final Ereignis ereignis;

  const UpdateEreignis(this.ereignis);

  @override
  List<Object> get props => [ereignis];

  @override
  String toString() => 'UpdateEreignis { updateEreignis: $ereignis for parentId: ${ereignis.parentId} }';
}

class RedoEreignis extends EreignisesEvent {
  final Ereignis ereignis;

  const RedoEreignis(this.ereignis);

  @override
  List<Object> get props => [ereignis];

  @override
  String toString() => 'RedoEreignis { redoEreignis: $ereignis for parentId: ${ereignis.parentId} }';
}

class DeleteEreignis extends EreignisesEvent {
  final Ereignis ereignis;

  const DeleteEreignis(this.ereignis);

  @override
  List<Object> get props => [ereignis];

  @override
  String toString() => 'DeleteEreignis { deleteEreignis: $ereignis for parentId: ${ereignis.parentId} }';
}

class EreignisesUpdated extends EreignisesEvent {
  final List<Ereignis> ereignises;
  
  const EreignisesUpdated(this.ereignises);

  @override
  List<Object> get props => [ereignises];
}

class ShiftEreignisesUpdated extends EreignisesEvent {
  final List<Ereignis> ereignises;
  
  const ShiftEreignisesUpdated(this.ereignises);

  @override
  List<Object> get props => [ereignises];
}

