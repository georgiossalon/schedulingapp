import 'package:equatable/equatable.dart';
import 'package:employees_repository/employees_repository.dart';
import 'package:snapshot_test/employee/blocs/statuses.dart';

abstract class UnavailabilitiesEvent extends Equatable {
  const UnavailabilitiesEvent();

  @override
  List<Object> get props => [];
}

class LoadUnavailabilities extends UnavailabilitiesEvent {
  final Employee employee;
  final int numOfWeeks;

  const LoadUnavailabilities(this.employee, this.numOfWeeks);

  @override
  List<Object> get props => [employee, numOfWeeks];

  @override
  String toString() => 'LoadUnavailabilities for employee: $employee for numOfWeeks: $numOfWeeks';
}

class AddUnavailability extends UnavailabilitiesEvent {
  final Unavailability unavailability;
  final Employee employee;

  const AddUnavailability(this.unavailability, this.employee);

  @override
  List<Object> get props => [unavailability, employee];

  @override
  String toString() => 'AddUnavailability { unavailability: $unavailability for employee: $employee }';
}

class UpdateUnavailability extends UnavailabilitiesEvent {
  final Unavailability unavailability;
  final Employee employee;

  const UpdateUnavailability(this.unavailability, this.employee);

  @override
  List<Object> get props => [unavailability, employee];

  @override
  String toString() => 'UpdateUnavailability { updateUnavailability: $unavailability for employee: $employee }';
}

class RedoUnavailability extends UnavailabilitiesEvent {
  final Unavailability unavailability;
  final Employee employee;

  const RedoUnavailability(this.unavailability, this.employee);

  @override
  List<Object> get props => [unavailability, employee];

  @override
  String toString() => 'RedoUnavailability { redoUnavailability: $unavailability for employee: $employee }';
}

class DeleteUnavailability extends UnavailabilitiesEvent {
  final Unavailability unavailability;
  final Employee employee;

  const DeleteUnavailability(this.unavailability, this.employee);

  @override
  List<Object> get props => [unavailability, employee];

  @override
  String toString() => 'DeleteUnavailability { deleteUnavailability: $unavailability for employee: $employee }';
}

class UnavailabilitiesUpdated extends UnavailabilitiesEvent {
  final List<Unavailability> unavailabilities;
  
  const UnavailabilitiesUpdated(this.unavailabilities);

  @override
  List<Object> get props => [unavailabilities];
}

