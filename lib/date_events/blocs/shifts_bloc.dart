import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:employees_repository/employees_repository.dart';
import 'package:meta/meta.dart';
import 'package:snapshot_test/employee/blocs/designations.dart';
import 'package:snapshot_test/date_events/blocs/shifts.dart';
import 'package:employees_repository/employees_repository.dart';
// import 'package:shifts_repository/shifts_repository.dart';

import 'package:rxdart/rxdart.dart';

import 'package:date_events_repository/date_events_repository.dart';

class ShiftsBloc extends Bloc<ShiftsEvent, ShiftsState> {
  // final ShiftsRepository _shiftsRepository;
  // StreamSubscription _shiftsSubscription;
  final DesignationsBloc _designationsBloc; // dependency
  StreamSubscription _designationsSubscription;
  final DateEventsRepository _dateEventsRepository;
  StreamSubscription _dateEventsSubscription;
  final EmployeesRepository _employeeRepository;
  StreamSubscription _employeeSubscription;

  ShiftsBloc(
      {@required DesignationsBloc designationsBloc,
      @required DateEventsRepository dateEventsRepository,
      @required EmployeesRepository employeeRepository})
      : assert(designationsBloc != null && dateEventsRepository != null && employeeRepository != null),
        _designationsBloc = designationsBloc,
        _dateEventsRepository = dateEventsRepository,
        _employeeRepository = employeeRepository;


  @override
  ShiftsState get initialState => ShiftsLoading();

  //! check the debounce
  //todo: implement this for when the user is giving a desciption or reason input
  //todo... so that the bloc does not update constantly after each keystroke
  // @override
  // Stream<Transition<ShiftsEvent, ShiftsState>> transformEvents(Stream<ShiftsEvent> events, transitionFn) {
  //   final deferredEvents = events.where((e) => e is ShiftsDescriptionChanged);
  //   final forwoardEvents = events.where((e) => e is! ShiftsDescriptionChanged);
  //   return forwoardEvents.mergeWith([deferredEvents]);
  //   // return super.transformEvents(events, transitionFn);
  // }

  @override
  Stream<ShiftsState> mapEventToState(ShiftsEvent event) async* {
    if (event is NewShiftCreated) {
      yield* _mapCreateNewShiftToState(event);
    } else if (event is ShiftEdited) {
      yield* _mapEditShiftToState(event);
    } else if (event is ShiftDataPushed) {
      yield* _mapPassShiftDataToState(event);
    } else if (event is ShiftAsDateEventAdded) {
      yield* _mapAddShiftAsDateEventToState(event);
    } else if (event is ShiftsDescriptionChanged) {
      yield* _mapShiftsDescriptionChangedToState(event);
    } else if (event is ShiftsEmployeeChanged) {
      yield* _mapShiftsEmployeeChangedToState(event);
    } else if (event is ShiftsDesignationChanged) {
      yield* _mapShiftsDesignationChangedToState(event);
    } else if (event is ShiftsStartTimeChanged) {
      yield* _mapShiftsShiftStartChangedToState(event);
    } else if (event is ShiftsEndTimeChanged) {
      yield* _mapShiftsShiftEndChangedToState(event);
    }
  }

   Stream<ShiftsState> _mapShiftsShiftStartChangedToState(ShiftsStartTimeChanged event) async* {
    if (state is ShiftCreatedOrEdited) {
      yield (state as ShiftCreatedOrEdited)
          .copyWith(shiftStart: event.shiftStart);
    }
   }

  Stream<ShiftsState> _mapShiftsShiftEndChangedToState(ShiftsEndTimeChanged event) async* {
    if (state is ShiftCreatedOrEdited) {
      yield (state as ShiftCreatedOrEdited)
          .copyWith(shiftEnd: event.shiftEnd);
    }
  }

  //! Rolly: Need Opinion
  Stream<ShiftsState> _mapShiftsDesignationChangedToState(
      ShiftsDesignationChanged event) async* {
    if (state is ShiftCreatedOrEdited) {
      ShiftCreatedOrEdited currentState = (state as ShiftCreatedOrEdited)
          .copyWith(currentDesignation: event.designation);
      // I need to fetch all available employees first
      _employeeSubscription?.cancel();
      _employeeSubscription = _employeeRepository
          .availableEmployeesForGivenDesignation(
              event.designation, currentState.shiftDate)
          .listen((employees) => add(ShiftDataPushed(
                // then I have to update the State
                availableEmployees: employees,
                currentDesignation: event.designation,
                currentEmployee: null, // reset employee on designation change
                shiftDate: currentState.shiftDate,
                description: currentState.description,
                shiftEnd: currentState.shiftEnd,
                shiftStart: currentState.shiftStart,
              )));
    }
  }

  Stream<ShiftsState> _mapShiftsEmployeeChangedToState(
      ShiftsEmployeeChanged event) async* {
    if (state is ShiftCreatedOrEdited) {
      yield (state as ShiftCreatedOrEdited)
          .copyWith(currentEmployee: event.employee);
    }
  }

  Stream<ShiftsState> _mapShiftsDescriptionChangedToState(
      ShiftsDescriptionChanged event) async* {
    if (state is ShiftCreatedOrEdited) {
      yield (state as ShiftCreatedOrEdited)
          .copyWith(description: event.description);
    }
  }

  // todo: move the dateEvents/shifts to their own repository
  Stream<ShiftsState> _mapAddShiftAsDateEventToState(
      ShiftAsDateEventAdded event) async* {
    //! what happens to the state? In this case I do not have Event -> State
    _dateEventsRepository.addOrUpdateDateEvent(event.dateEvent);
  }

  // 1) I CreateNewShift (event) -> ShiftCreatedOrEdited (state)
  // 2) EditShift(event) -> PassShiftData(event) -> ShiftCreatedOrEdited(state)

  Stream<ShiftsState> _mapCreateNewShiftToState(NewShiftCreated event) async* {
    final designations = await _designationsBloc
        .firstWhere((state) => state is DesignationsLoaded);
    yield ShiftCreatedOrEdited(
      designations:
          (designations as DesignationsLoaded).designationsObj.designations,
      currentDesignation: 'open',
      shiftDate: event.shiftDate,
    );
  }

  Stream<ShiftsState> _mapEditShiftToState(ShiftEdited event) async* {
    _employeeSubscription?.cancel();
    // First get available employees for the designation
    _employeeSubscription = _employeeRepository
        .availableEmployeesForGivenDesignation(
            event.currentDesignation, event.shiftDate)
        .listen((employees) => add(ShiftDataPushed(
              availableEmployees: employees,
              currentDesignation: event.currentDesignation,
              currentEmployee: event.currentEmployee,
              shiftDate: event.shiftDate,
              shiftStart: event.shiftStart,
              shiftEnd: event.shiftEnd,
              description: event.description,
            )));
  }

  Stream<ShiftsState> _mapPassShiftDataToState(ShiftDataPushed event) async* {
    final designations = await _designationsBloc
        .firstWhere((state) => state is DesignationsLoaded);

    yield ShiftCreatedOrEdited(
      designations:
          (designations as DesignationsLoaded).designationsObj.designations,
      currentDesignation: event.currentDesignation,
      currentEmployee: event.currentEmployee,
      availableEmployees: event.availableEmployees,
      shiftDate: event.shiftDate,
      description: event.description,
      shiftEnd: event.shiftEnd,
      shiftStart: event.shiftStart,
    );
  }

  @override
  Future<void> close() {
    _employeeSubscription?.cancel();
    _designationsSubscription?.cancel();
    _dateEventsSubscription?.cancel();
    return super.close();
  }


}
