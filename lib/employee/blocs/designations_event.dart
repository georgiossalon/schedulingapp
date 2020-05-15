import 'package:employees_repository/employees_repository.dart';
import 'package:equatable/equatable.dart';

abstract class DesignationsEvent extends Equatable {
  const DesignationsEvent();

  @override
  List<Object> get props => [];
}

class LoadDesignations extends DesignationsEvent {}

class AssignDesignationsToEmployee extends DesignationsEvent {
  final String designationsString;

  const AssignDesignationsToEmployee(this.designationsString);

  @override
  List<Object> get props => [designationsString];
}

class DesignationsUpdated extends DesignationsEvent {
  final List<Designation> designations;

  const DesignationsUpdated(this.designations);

  @override
  List<Object> get props => [designations];
}

class AddDesignation extends DesignationsEvent {
  final Designation designation;

  const AddDesignation(this.designation);

  @override
  List<Object> get props => [designation];

  @override
  String toString() => 'AddDesignation { designation: $designation }';
}

class DeleteDesignation extends DesignationsEvent {
  final Designation designation;

  const DeleteDesignation(this.designation);

  @override
  List<Object> get props => [designation];

  @override
  String toString() => 'DeleteDesignation { designation: $designation }';
}

class UpdateDesignation extends DesignationsEvent {
  final Designation designation;

  const UpdateDesignation(this.designation);

  @override
  List<Object> get props => [designation];

  @override
  String toString() => 'UpdateDesignation { designation: $designation }';
}
