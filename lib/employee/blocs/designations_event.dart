import 'package:employees_repository/employees_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class DesignationsEvent extends Equatable {
  const DesignationsEvent();

  @override
  List<Object> get props => [];
}

class LoadDesignations extends DesignationsEvent {}

// class AssignDesignationsToEmployee extends DesignationsEvent {
//   final String designationsString;

//   const AssignDesignationsToEmployee(this.designationsString);

//   @override
//   List<Object> get props => [designationsString];
// }

class DesignationCreated extends DesignationsEvent {
  final Designations designationsObj;

  DesignationCreated({this.designationsObj});

  @override
  List<Object> get props => [designationsObj];

  @override
  String toString() => 'DesignationCreated(designationsObj: $designationsObj)';
}

class DesignationUploaded extends DesignationsEvent {
  final Designations designationsObj;

  DesignationUploaded({this.designationsObj});

  @override
  List<Object> get props => [designationsObj];

  @override
  String toString() => 'DesignationUploaded(designationsObj: $designationsObj)';
}

class DesignationChanged extends DesignationsEvent {
  final String designationChanged;

  DesignationChanged({this.designationChanged});

  @override
  List<Object> get props => [designationChanged];

  @override
  String toString() => 'DesignationChanged(designationChanged: $designationChanged)';
}



class DesignationsUpdated extends DesignationsEvent {
  final Designations designationsObj;

  const DesignationsUpdated(this.designationsObj);

  @override
  List<Object> get props => [designationsObj];
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
  final Designations designationObj;

  const DeleteDesignation(this.designationObj);

  @override
  List<Object> get props => [designationObj];

  @override
  String toString() => 'DeleteDesignation { designation: $designationObj }';
}

// class UpdateDesignation extends DesignationsEvent {
//   final Designations designationsObj;

//   const UpdateDesignation({
//     @required this.designationsObj,
//   });

//   @override
//   List<Object> get props => [designationsObj];

//   @override
//   String toString() => 'UpdateDesignation { designationsObj: $designationsObj }';
// }
