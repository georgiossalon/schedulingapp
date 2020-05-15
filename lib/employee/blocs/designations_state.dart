import 'package:employees_repository/employees_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:snapshot_test/employee/blocs/designations.dart';

class DesignationsState {
  final List<Designation> designations;
  final String designationsChosen;

  const DesignationsState(
      {@required this.designations, @required this.designationsChosen});

  factory DesignationsState.designationsLoading() => DesignationsState(
        designations: <Designation>[],
        designationsChosen: null,
      );

  factory DesignationsState.designationsLoaded({
    @required List<Designation> designations,
  }) =>
      DesignationsState(
        designations: designations,
        designationsChosen: null,
      );
  
  factory DesignationsState.designationsLoadedAndAssignedToShift({
    @required List<Designation> designations,
    @required String designationsChosen
  }) =>
      DesignationsState(
        designations: designations,
        designationsChosen: designationsChosen,
      );

}

// class DesignationsLoading extends DesignationsState {}

// class DesignationsLoaded extends DesignationsState {
//   final List<Designation> designations;

//   const DesignationsLoaded([this.designations = const[]]);

//   @override
//   List<Object> get props => [designations];

//   @override
//   String toString() => 'Designations { designations $designations }';
// }

// class DesignationsLoadedAndAssignedToTheEmployee extends DesignationsState {
//   final String designationsString;
//   final List<Designation> designations;

//   const DesignationsLoadedAndAssignedToTheEmployee(this.designationsString, this.designations);

//   @override
//   List<Object> get props => [designationsString, designations];

//   @override
//   String toString() => 'Designations Assigned To Employee { designations $designationsString and designations loaded $designations } ';
// }

// class DesignationsNotLoaded extends DesignationsState {}
