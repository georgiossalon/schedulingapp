import 'package:employees_repository/employees_repository.dart';
import 'package:meta/meta.dart';

class DesignationsState {
  final Designations designationsObj;

  const DesignationsState({
    @required this.designationsObj,
  });

  //!Rolly: why don't I need props override for the one class implementation?

  factory DesignationsState.designationsLoading() => DesignationsState(
        designationsObj: Designations(
          designations: const <String>[],//['open'], //should always contain the open designation
          currentDesignation: null,
          id: null,
        ),
      );

  factory DesignationsState.loadedDesignations({
    @required List<String> designations,
    @required String id,
  }) =>
      DesignationsState(
        designationsObj: Designations(
            designations: designations,
            currentDesignation: null,
            id: id),
      );

  // factory DesignationsState.createdDesignation({
  //   @required List<String> designations,
  //   String id
  // }) => 
  //   DesignationsState(designationsObj: Designations(
  //     designations: designations,
  //     currentDesignation: null,
  //     id: id,
  //   ));

    factory DesignationsState.editedDesignation({
      @required List<String> designations,
      @required String currentDesignation,
      String id,
    }) =>
      DesignationsState(designationsObj: Designations(
        designations: designations,
        currentDesignation: currentDesignation,
        id: id,
      ));

  factory DesignationsState.designationsLoadedAndAssignedToShift(
          {@required List<String> designations,
          }) =>
      DesignationsState(
          designationsObj: Designations(
        designations: designations,
        id: null,
      ));

  DesignationsState copyWith({
    Designations designationsObj,
  }) {
    return DesignationsState(
      designationsObj: designationsObj ?? this.designationsObj,
    );
  }
}

// abstract class DesignationsState {
//   const DesignationsState();

//   @override
//   List<Object> get props => [];
// }

// class DesignationsLoading extends DesignationsState {}

// class DesignationsLoaded extends DesignationsState {
//   final Designations designationsObj;

//   const DesignationsLoaded(this.designationsObj);

//   @override
//   List<Object> get props => [designationsObj];

//   @override
//   String toString() => 'Designations { designations $designationsObj }';
// }

// class DesignationsLoadedAndAssignedToTheEmployee extends DesignationsState {
//   final String designationsString;
//   final List<Designations> designations;

//   const DesignationsLoadedAndAssignedToTheEmployee(this.designationsString, this.designations);

//   @override
//   List<Object> get props => [designationsString, designations];

//   @override
//   String toString() => 'Designations Assigned To Employee { designations $designationsString and designations loaded $designations } ';
// }

// class DesignationsNotLoaded extends DesignationsState {}
