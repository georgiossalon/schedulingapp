import 'package:employees_repository/employees_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:snapshot_test/employee/blocs/designations.dart';

// class DesignationsState {
//   final Designations designationsObj;

//   const DesignationsState({
//     @required this.designationsObj,
//   });

//   factory DesignationsState.designationsLoading() => DesignationsState(
//         designationsObj: Designations(
//           designations: <String>[],
//           currentDesignation: null,
//           id: null,
//         ),
//       );

//   factory DesignationsState.designationsLoaded({
//     @required List<String> designations,
//     @required String id,
//   }) =>
//       DesignationsState(
//         designationsObj: Designations(
//             designations: designations,
//             currentDesignation: null,
//             id: id),
//       );

//   factory DesignationsState.designationsLoadedAndAssignedToShift(
//           {@required List<String> designations,
//           @required String designationsChosen}) =>
//       DesignationsState(
//           designationsObj: Designations(
//         designations: designations,
//         currentDesignation: designationsChosen,
//         id: null,
//       ));
// }

abstract class DesignationsState {
  const DesignationsState();

  @override
  List<Object> get props => [];
}

class DesignationsLoading extends DesignationsState {}

class DesignationsLoaded extends DesignationsState {
  final Designations designationsObj;

  const DesignationsLoaded(this.designationsObj);

  @override
  List<Object> get props => [designationsObj];

  @override
  String toString() => 'Designations { designations $designationsObj }';
}

class DesignationsLoadedAndAssignedToTheEmployee extends DesignationsState {
  final String designationsString;
  final List<Designations> designations;

  const DesignationsLoadedAndAssignedToTheEmployee(this.designationsString, this.designations);

  @override
  List<Object> get props => [designationsString, designations];

  @override
  String toString() => 'Designations Assigned To Employee { designations $designationsString and designations loaded $designations } ';
}

class DesignationsNotLoaded extends DesignationsState {}
