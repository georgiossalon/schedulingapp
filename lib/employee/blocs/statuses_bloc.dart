import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:snapshot_test/employee/blocs/statuses.dart';
import 'package:employees_repository/employees_repository.dart';

class StatusesBloc extends Bloc<StatusesEvent, StatusesState> {
  final EmployeesRepository _employeesRepository;
  StreamSubscription _statusesSubscription;

  StatusesBloc({@required EmployeesRepository employeesRepository})
      : assert(employeesRepository != null),
        _employeesRepository = employeesRepository;

  @override
  StatusesState get initialState => StatusesLoaded();

  @override
  Stream<StatusesState> mapEventToState(StatusesEvent event) async* {
    if (event is LoadStatuses) {
      yield* _mapLoadStatusesToState(event);
    } else if (event is AddStatus) {
      yield* _mapAddStatusToState(event);
    } else if (event is UpdateStatus) {
      yield* _mapUpdateStatus(event);
    } else if (event is DeleteStatus) {
      yield* _mapDeleteStatusToState(event);
    } else if (event is RedoStatus) {
      yield* _mapStatusesRedoToState(event);
    } else if (event is StatusesesUpdated) {
      yield* _mapStatusesUpdateToState(event);
    }
  }

  // ! Load only when I ask. For this case I have to use an employee and the number of weeks
  Stream<StatusesState> _mapLoadStatusesToState(LoadStatuses event) async* {
    _statusesSubscription?.cancel();
    _statusesSubscription = _employeesRepository
        .statuses(event.employeeId, event.numOfWeeks, DateTime.now()).listen(
          (statuses) => add(StatusesesUpdated(statuses)));
  }
  // ! This will only add an status to the already started stream for the given employee.
  // ! Use Future or a Stream ?
  //todo: implement a method that pushes for a given employee
  Stream <StatusesState> _mapAddStatusToState(AddStatus event) async* {
    _employeesRepository.addNewStatus(event.status, event.employeeId);
  }

  Stream<StatusesState> _mapUpdateStatus(UpdateStatus event) async* {
    _employeesRepository.updateStatus(event.status, event.employeeId);
  }

  Stream<StatusesState> _mapDeleteStatusToState(DeleteStatus event) async* {
    _employeesRepository.deleteStatus(event.status, event.employeeId);
  }

  Stream<StatusesState> _mapStatusesRedoToState (RedoStatus event) async* {
    _employeesRepository.redoStatus(event.status, event.employeeId);
  }

  Stream<StatusesState> _mapStatusesUpdateToState (StatusesesUpdated event) async* {
    yield StatusesLoaded(event.statuses);
  }

  @override
  Future<void> clode() {
    _statusesSubscription?.cancel();
    return super.close();
  }
}