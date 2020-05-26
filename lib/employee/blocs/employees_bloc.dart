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
    } else if (event is EmployeesBusyMapDateEventRemoved) {
      yield* _mapEmployeesBusyMapDateEventRemovedToState(event);
    }
  }

  Stream<EmployeesState> _mapEmployeesBusyMapDateEventRemovedToState(
      EmployeesBusyMapDateEventRemoved event) async* {
    //!Rolly: It this okay to use here if-statement like this?
    // delete from the employees busy_map if not assigned to the open employee
    // the open employee does not have an id
    // also if there is no old employee, then the value is set to null
    // and I nothing gets deleted from the busy_map
    if (event.oldEmployee != null) {
      // if the old employee is not the 'open' employee
      if (event.oldEmployee.id != null) {
      // only if the old and current employees are different, then delete
      // this may occur since the user may edit the shift and still leave it
      // to the same employee
        if (event.oldEmployee.id != event.currentEmployeeId) {
          _employeesRepository.deleteEmployeesDateEventBusyMapElement(
              event.oldEmployee.id, event.dateTime);
        }
      }
    }
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
    //! Rolly: Opinion about the if-statements
    // The 'open' employee does not have a an employeeId and also not a busy_map
    if (event.employeeDateEvent.employeeId != null) {
      // if there is an old employee
      if (event.oldEmployee != null) {
        // add only if it is not the same. This may happen when the user
        // edits an event
        if (event.employeeDateEvent.employeeId != event.oldEmployee.id) {
          _employeesRepository.updateEmployeesBusyMap(event.employeeDateEvent);
        }
      } else {
        // there is no old (same) employee thus add
        _employeesRepository.updateEmployeesBusyMap(event.employeeDateEvent);
      }
    }
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
