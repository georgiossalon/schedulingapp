import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:snapshot_test/employee/blocs/employees.dart';
import 'package:employees_repository/employees_repository.dart';

class EmployeesBloc extends Bloc<EmployeesEvent, EmployeesState> {
  final EmployeesRepository _employeesRepository;
  StreamSubscription _employeesSubscription;

  EmployeesBloc({@required EmployeesRepository employeesRepository})
      : assert(employeesRepository != null),
        _employeesRepository = employeesRepository;

  @override
  EmployeesState get initialState => EmployeesLoading();

  @override
  Stream<EmployeesState> mapEventToState(EmployeesEvent event) async* {
    if (event is LoadEmployees) {
      yield* _mapLoadEmployeesToState();
    } else if (event is AddEmployee) {
      yield* _mapAddEmployeeToState(event);
    } else if (event is UpdateEmployee) {
      yield* _mapUpdateEmployeeToState(event);
    } else if (event is DeleteEmployee) {
      yield* _mapDeleteEmployeeToState(event);
    } else if (event is RedoEmployee) {
      yield* _mapEmployeesRedoToState(event);
    } else if (event is EmployeesUpdated) {
      yield* _mapEmployeesUpdateToState(event);
    } else if (event is LoadEmployeesWithGivenDesignation) {
      yield* _mapLoadEmployeesWithGivenDesignation(event);
    } else if (event is UpdateEmployeeBusyMap) {
      yield* _mapUpdateEmployeeBusyMapToState(event);
    } else if (event is EmployeesEmpty) {
      yield* _mapEmployeesNotLoadedMapToState();
    } else if (event is EmployeesUpdatedWithGivenDesignation) {
      yield* _mapEmployeesUpdatedWithGivenDesignationMapToState(event);
    }
//    else if (event is EmployeeDateEventRequested) {
//      yield* _mapEmployeeDateEventRequestedToState(event);
//    }
  }

  Stream<EmployeesState> _mapLoadEmployeesToState() async* {
    _employeesSubscription?.cancel();
    _employeesSubscription = _employeesRepository.employees().listen(
          (employees) => add(EmployeesUpdated(employees)),
        );
  }

  // ! do I need a stream for the designations??
  Stream<EmployeesState> _mapLoadEmployeesWithGivenDesignation(
      LoadEmployeesWithGivenDesignation event) async* {
    _employeesSubscription?.cancel();
    _employeesSubscription = _employeesRepository
        .availableEmployeesForGivenDesignation(event.designation, event.date)
        .listen(
          (employees) => add(EmployeesUpdatedWithGivenDesignation(employees)),
        );
  }

  Stream<EmployeesState> _mapEmployeesUpdatedWithGivenDesignationMapToState(
      EmployeesUpdatedWithGivenDesignation event) async* {
    yield EmployeesLoadedWithGivenDesignation(event.employees);
  }

  Stream<EmployeesState> _mapUpdateEmployeeBusyMapToState(
      UpdateEmployeeBusyMap event) async* {
    _employeesRepository.updateEmployeesBusyMap(
        event.employeeId, event.busyMap);
  }

  Stream<EmployeesState> _mapAddEmployeeToState(AddEmployee event) async* {
    _employeesRepository.addNewEmployee(event.employee);
  }

  Stream<EmployeesState> _mapEmployeesRedoToState(RedoEmployee event) async* {
    _employeesRepository.redoEmployee(event.redoneEmployee);
  }

  Stream<EmployeesState> _mapUpdateEmployeeToState(
      UpdateEmployee event) async* {
    _employeesRepository.updateEmployee(event.updatedEmployee);
  }

  Stream<EmployeesState> _mapDeleteEmployeeToState(
      DeleteEmployee event) async* {
    _employeesRepository.deleteEmployee(event.employee);
  }

  Stream<EmployeesState> _mapEmployeesUpdateToState(
      EmployeesUpdated event) async* {
    yield EmployeesLoaded(event.employees);
  }

  Stream<EmployeesState> _mapEmployeesNotLoadedMapToState() async* {
    yield EmployeesNotLoaded();
  }

  @override
  Future<void> close() {
    _employeesSubscription?.cancel();
    return super.close();
  }
}
