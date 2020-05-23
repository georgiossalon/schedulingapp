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
  DesignationsState get initialState => DesignationsLoading();

  @override
  Stream<DesignationsState> mapEventToState(
    DesignationsEvent event,
  ) async* {
    if (event is LoadDesignations) {
      yield* _mapLoadDesignationsToState();
    } else if (event is AddDesignation) {
      yield* _mapAddDesignationToState(event);
    } 
    // else if (event is UpdateDesignation) {
    //   yield* _mapUpdateDesignationToState(event);
    // } 
    else if (event is DeleteDesignation) {
      yield* _mapDeleteDesignationToState(event);
    } else if (event is DesignationsUpdated) {
      yield* _mapDesignationsUpdatedToState(event);
    } 
    // else if (event is AssignDesignationsToEmployee) {
    //   yield* _mapAssignDesignationsToEmployee(event);
    // }
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
    yield DesignationsLoaded(event.designationsObj);
  }

  Stream<DesignationsState> _mapAddDesignationToState(
      AddDesignation event) async* {
       
    // if (event.designationsObj.designations.isEmpty) {
      _employeesRepository.addNewDesignation(event.designationsObj);
    // } else {
    //   _employeesRepository.updateDesignation(event.designationsObj);
    // }
  }

  // Stream<DesignationsState> _mapUpdateDesignationToState(
  //     UpdateDesignation event) async* {
  //   _employeesRepository.updateDesignation(event.designationsObj);
  // }

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
