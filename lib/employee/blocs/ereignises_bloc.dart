import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:snapshot_test/employee/blocs/ereignises.dart';
import 'package:employees_repository/employees_repository.dart';

class EreignisesBloc extends Bloc<EreignisesEvent, EreignisesState> {
  final EmployeesRepository _employeesRepository;
  StreamSubscription _ereignisesSubscription;

  EreignisesBloc({@required EmployeesRepository employeesRepository})
      : assert(employeesRepository != null),
        _employeesRepository = employeesRepository;

  @override
  EreignisesState get initialState => EreignisesLoading();

  @override
  Stream<EreignisesState> mapEventToState(EreignisesEvent event) async* {
    if (event is LoadAllEreignisesForEmployeeForXWeeks) {
      yield* _mapLoadEreignisesToState(event);
    } else if (event is AddEreignis) {
      yield* _mapAddEreignisToState(event);
    } else if (event is UpdateEreignis) {
      yield* _mapUpdateEreignis(event);
    } else if (event is DeleteEreignis) {
      yield* _mapDeleteEreignisToState(event);
    } else if (event is RedoEreignis) {
      yield* _mapEreignisesRedoToState(event);
    } else if (event is EreignisesUpdated) {
      yield* _mapEreignisesUpdateToState(event);
    } else if (event is LoadAllShiftsForXWeeks) {
      yield* _mapEreignisesLoadAllShiftsForXWeeksToState(event);
    } else if (event is ShiftEreignisesUpdated) {
      yield* _mapShiftEreignisesUpdateToState(event);
    }
  }

  // ! Load only when I ask. For this case I have to use an employee and the number of weeks
  Stream<EreignisesState> _mapLoadEreignisesToState(LoadAllEreignisesForEmployeeForXWeeks event) async* {
    _ereignisesSubscription?.cancel();
    _ereignisesSubscription = _employeesRepository
        .allEreignisesForGivenEmployee(event.employeeId, event.numOfWeeks, DateTime.now()).listen(
          (ereignises) => add(EreignisesUpdated(ereignises)));
  }

  Stream<EreignisesState> _mapEreignisesLoadAllShiftsForXWeeksToState(LoadAllShiftsForXWeeks event) async* {
    _ereignisesSubscription?.cancel();
    _ereignisesSubscription = _employeesRepository
        .allShiftEreignises(event.numOfWeeks, DateTime.now()).listen(
          (ereignises) => add(ShiftEreignisesUpdated(ereignises))
        );
  }

  // ! This will only add an ereignis to the already started stream for the given employee.
  // ! Use Future or a Stream ?
  //todo: implement a method that pushes for a given employee
  Stream <EreignisesState> _mapAddEreignisToState(AddEreignis event) async* {
    _employeesRepository.addNewEreignis(event.ereignis);
  }

  Stream<EreignisesState> _mapUpdateEreignis(UpdateEreignis event) async* {
    _employeesRepository.updateEreignis(event.ereignis);
  }

  Stream<EreignisesState> _mapDeleteEreignisToState(DeleteEreignis event) async* {
    _employeesRepository.deleteEreignis(event.ereignis);
  }

  Stream<EreignisesState> _mapEreignisesRedoToState (RedoEreignis event) async* {
    _employeesRepository.redoEreignis(event.ereignis);
  }

  Stream<EreignisesState> _mapEreignisesUpdateToState (EreignisesUpdated event) async* {
    yield EreignisesLoaded(event.ereignises);
  }
  
  Stream<EreignisesState> _mapShiftEreignisesUpdateToState (ShiftEreignisesUpdated event) async* {
    yield ShiftEreignisesLoaded(event.ereignises);
  }

  @override
  Future<void> clode() {
    _ereignisesSubscription?.cancel();
    return super.close();
  }
}