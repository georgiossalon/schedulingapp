import 'package:equatable/equatable.dart';
import 'package:shifts_repository/shifts_repository.dart';

abstract class ShiftsEvent extends Equatable {
  const ShiftsEvent();

  @override
  List<Object> get props => [];
}

class LoadShifts extends ShiftsEvent {}

class AddShift extends ShiftsEvent {
  final Shift shift;

  const AddShift(this.shift);

  @override
  List<Object> get props => [shift];

  @override
  String toString() => 'AddShift(shift: $shift)';
}

class UpdateShift extends ShiftsEvent {
  final Shift updatedShift;

  const UpdateShift(this.updatedShift);

  @override
  List<Object> get props => [updatedShift];

  @override
  String toString() => 'UpdateShift { updatedShift: $updatedShift }';
}

class DeleteShift extends ShiftsEvent {
  final Shift shift;

  const DeleteShift(this.shift);

  @override
  List<Object> get props => [shift];

  @override
  String toString() => 'DeleteShift { shift: $shift }';
}

class ShiftsUpdated extends ShiftsEvent {
  final List<Shift> shifts;

  const ShiftsUpdated(this.shifts);

  @override
  List<Object> get props => [shifts];
}
