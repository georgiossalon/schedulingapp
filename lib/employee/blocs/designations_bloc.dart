import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:employees_repository/employees_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'designations.dart';
import 'package:meta/meta.dart';

class DesignationsBloc extends Bloc<DesignationsEvent, DesignationsState> {
  final EmployeesRepository _employeesRepository;
  StreamSubscription _designationsSubscription;
  // StreamSubscription<String> _designationsToEmployeeSubscription;

  DesignationsBloc({@required EmployeesRepository employeesRepository})
      : assert(employeesRepository != null),
        _employeesRepository = employeesRepository;

  @override
  DesignationsState get initialState => DesignationsState.designationsLoading();

  @override
  Stream<DesignationsState> mapEventToState(
    DesignationsEvent event,
  ) async* {
    if (event is LoadDesignations) {
      yield* _mapLoadDesignationsToState();
    } else if (event is AddDesignation) {
      yield* _mapAddDesignationToState(event);
    } else if (event is DeleteDesignation) {
      yield* _mapDeleteDesignationToState(event);
    } else if (event is DesignationsUpdated) {
      yield* _mapDesignationsUpdatedToState(event);
    } else if (event is DesignationCreated) {
      yield* _mapDesignationCreatedToState(event);
    } else if (event is DesignationUploaded) {
      yield* _mapDesignationUploadedToState(event);
    } else if (event is DesignationChanged) {
      yield* _mapDesignationChangedToState(event);
    }
  }

  Stream<DesignationsState> _mapDesignationUploadedToState(
      DesignationUploaded event) async* {
    _employeesRepository.addNewDesignation(event.designationsObj);
  }

  Stream<DesignationsState> _mapDesignationChangedToState(
      DesignationChanged event) async* {
    yield DesignationsState.editedDesignation(
        designations: state.designationsObj.designations,
        currentDesignation: event.designationChanged,
        id: state.designationsObj.id);
  }

  Stream<DesignationsState> _mapDesignationCreatedToState(
      DesignationCreated event) async* {
    yield DesignationsState.editedDesignation(
      designations: event.designationsObj.designations,
      currentDesignation: event.designationsObj.currentDesignation,
      id: event.designationsObj.id,
    );
  }

  Stream<DesignationsState> _mapLoadDesignationsToState() async* {
    _designationsSubscription?.cancel();
    _designationsSubscription = _employeesRepository.designations().listen(
          // I am Listening a Designations object
          // I am only passing a Designations object
          (designationsObj) => add(DesignationsUpdated(designationsObj)),
        );
  }

  // Stream<DesignationsState> _mapAssignDesignationsToEmployee(
  //     AssignDesignationsToEmployee event) async* {
  //   final currentState = state;
  //   yield DesignationsState.designationsLoadedAndAssignedToShift(
  //       designations: currentState.designationsObj.designations,
  //       designationsChosen: event.designationsString);
  // }

  Stream<DesignationsState> _mapDesignationsUpdatedToState(
      DesignationsUpdated event) async* {
        List<String> hDesignations = List.from(event.designationsObj.designations);
        !hDesignations.contains('open') ? hDesignations.add('open'): null; // always have the 'open' designation in the list
    yield DesignationsState.loadedDesignations(
        designations: hDesignations,
        id: event.designationsObj.id);
  }

  Stream<DesignationsState> _mapAddDesignationToState(
      AddDesignation event) async* {
    _employeesRepository.addNewDesignation(event.designationsObj);
  }

  Stream<DesignationsState> _mapDeleteDesignationToState(
      DeleteDesignation event) async* {
    _employeesRepository.deleteDesignation(event.designationObj);
  }

  @override
  Future<void> close() {
    _designationsSubscription?.cancel();
    return super.close();
  }
}
