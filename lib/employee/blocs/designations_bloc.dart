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
    } else if (event is UpdateDesignation) {
      yield* _mapUpdateDesignationToState(event);
    } else if (event is DeleteDesignation) {
      yield* _mapDeleteDesignationToState(event);
    } else if (event is DesignationsUpdated) {
      yield* _mapDesignationsUpdatedToState(event);
    }
  }

  Stream<DesignationsState> _mapLoadDesignationsToState() async* {
    _designationsSubcription?.cancel();
    _designationsSubcription = _employeesRepository.designations().listen(
          (designations) => add(DesignationsUpdated(designations)),
        );
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

  Stream<DesignationsState> _mapDesignationsUpdatedToState(
      DesignationsUpdated event) async* {
    yield DesignationsLoaded(event.designations);
  }

  @override
  Future<void> close() {
    _designationsSubcription?.cancel();
    return super.close();
  }
}
