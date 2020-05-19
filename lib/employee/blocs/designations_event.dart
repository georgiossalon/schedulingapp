import 'package:employees_repository/employees_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

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
  final Designations designations;

  const DesignationsUpdated(this.designations);

  @override
  List<Object> get props => [designations];
}

class AddDesignation extends DesignationsEvent {
  final Designations designationsObj;

  const AddDesignation({
    @required this.designationsObj,
  });

  @override
  List<Object> get props => [designationsObj];

  @override
  String toString() =>
      'AddDesignation { adding a designationsObj: $designationsObj }';
}

class DeleteDesignation extends DesignationsEvent {
  final Designations designation;

  const DeleteDesignation(this.designation);

  @override
  List<Object> get props => [designation];

  @override
  String toString() => 'DeleteDesignation { designation: $designation }';
}

class UpdateDesignation extends DesignationsEvent {
  final Designations designationsObj;

  const UpdateDesignation({
    @required this.designationsObj,
  });

  @override
  List<Object> get props => [designationsObj];

  @override
  String toString() => 'UpdateDesignation { designationsObj: $designationsObj }';
}
