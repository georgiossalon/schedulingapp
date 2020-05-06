import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:snapshot_test/blocs/employees/unavailability/unavailabilities.dart';
import 'package:employees_repository/employees_repository.dart';

class UnavailabilitiesBloc extends Bloc<UnavailabilitiesEvent, UnavailabilitiesState> {
  final EmployeesRepository _employeesRepository;
  StreamSubscription _unavailabilitiesSubscription;

  UnavailabilitiesBloc({@required EmployeesRepository employeesRepository})
      : assert(employeesRepository != null),
        _employeesRepository = employeesRepository;

  @override
  UnavailabilitiesState get initialState => UnavailabilitiesLoaded();

  @override
  Stream<UnavailabilitiesState> mapEventToState(UnavailabilitiesEvent event) async* {
    if (event is LoadUnavailabilities) {
      yield* _mapLoadUnavailabilitiesToState(event);
    } else if (event is AddUnavailability) {
      yield* _mapAddUnavailabilityToState(event);
    } else if (event is UpdateUnavailability) {
      yield* _mapUpdateUnavailability(event);
    } else if (event is DeleteUnavailability) {
      yield* _mapDeleteUnavailabilityToState(event);
    } else if (event is RedoUnavailability) {
      yield* _mapUnavailabilitiesRedoToState(event);
    } else if (event is UnavailabilitiesUpdated) {
      yield* _mapUnavailabilitiesUpdateToState(event);
    }
  }

  // ! Load only when I ask. For this case I have to use an employee and the number of weeks
  Stream<UnavailabilitiesState> _mapLoadUnavailabilitiesToState(LoadUnavailabilities event) async* {
    _unavailabilitiesSubscription?.cancel();
    _unavailabilitiesSubscription = _employeesRepository.unavailabilities(event.employee, event.numOfWeeks).listen(
      (unavailabilities) => add(UnavailabilitiesUpdated(unavailabilities)));
  }
  // ! This will only add an unavailability to the already started stream for the given employee.
  // ! Use Future or a Stream ?
  //todo: implement a method that pushes for a given employee
  Stream <UnavailabilitiesState> _mapAddUnavailabilityToState(AddUnavailability event) async* {
    _employeesRepository.addNewUnavailability(event.unavailability, event.employee);
  }

  Stream<UnavailabilitiesState> _mapUpdateUnavailability(UpdateUnavailability event) async* {
    _employeesRepository.updateUnavailability(event.unavailability, event.employee);
  }

  Stream<UnavailabilitiesState> _mapDeleteUnavailabilityToState(DeleteUnavailability event) async* {
    _employeesRepository.deleteUnavailability(event.unavailability, event.employee);
  }

  Stream<UnavailabilitiesState> _mapUnavailabilitiesRedoToState (RedoUnavailability event) async* {
    _employeesRepository.redoUnavailability(event.unavailability, event.employee);
  }

  Stream<UnavailabilitiesState> _mapUnavailabilitiesUpdateToState (UnavailabilitiesUpdated event) async* {
    yield UnavailabilitiesLoaded(event.unavailabilities);
  }

  @override
  Future<void> clode() {
    _unavailabilitiesSubscription?.cancel();
    return super.close();
  }
}