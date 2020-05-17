import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:employees_repository/employees_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'designations.dart';
import 'package:meta/meta.dart';

class DesignationsBloc extends Bloc<DesignationsEvent, DesignationsState> {
  final EmployeesRepository _employeesRepository;
  StreamSubscription _designationsSubcription;
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
    } else if (event is UpdateDesignation) {
      yield* _mapUpdateDesignationToState(event);
    } else if (event is DeleteDesignation) {
      yield* _mapDeleteDesignationToState(event);
    } else if (event is DesignationsUpdated) {
      yield* _mapDesignationsUpdatedToState(event);
    } else if (event is AssignDesignationsToEmployee) {
      yield* _mapAssignDesignationsToEmployee(event);
    }
  }

  Stream<DesignationsState> _mapLoadDesignationsToState() async* {
    _designationsSubcription?.cancel();
    _designationsSubcription = _employeesRepository.designations().listen(
          (designations) => add(DesignationsUpdated(designations)),
        );
  //  final designations = await _employeesRepository.designations();
  //   yield DesignationsState.designationsLoaded(designations: designations); 
  }
  Stream<DesignationsState> _mapAssignDesignationsToEmployee(AssignDesignationsToEmployee event) async* {
    final currentState = state;
    yield DesignationsState.designationsLoadedAndAssignedToShift(designations: currentState.designations, designationsChosen: event.designationsString);
  }

  Stream<DesignationsState> _mapDesignationsUpdatedToState(
      DesignationsUpdated event) async* {
    yield DesignationsState.designationsLoaded(designations: event.designations);
  }

  Stream<DesignationsState> _mapAddDesignationToState(
      AddDesignation event) async* {
    _employeesRepository.addNewDesignation(event.designation);
  }

  Stream<DesignationsState> _mapUpdateDesignationToState(
      UpdateDesignation event) async* {
    _employeesRepository.updateDesignation(event.designation);
  }

  Stream<DesignationsState> _mapDeleteDesignationToState(
      DeleteDesignation event) async* {
    _employeesRepository.deleteDesignation(event.designation);
  }


  @override
  Future<void> close() {
    _designationsSubcription?.cancel();
    return super.close();
  }
}
