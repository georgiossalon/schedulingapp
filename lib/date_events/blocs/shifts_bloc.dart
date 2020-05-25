import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:employees_repository/employees_repository.dart';
import 'package:meta/meta.dart';
import 'package:snapshot_test/employee/blocs/designations.dart';
import 'package:snapshot_test/date_events/blocs/shifts.dart';
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
      : assert(designationsBloc != null &&
            dateEventsRepository != null &&
            employeeRepository != null),
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
    } else if (event is UploadDateEventAdded) {
      yield* _mapUploadDateEventToState(event);
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
    } else if (event is NewShiftEmployeeSpecificCreated) {
      yield* _mapNewShiftEmployeeSpecificCreatedToState(event);
    } else if (event is NewDayOffCreated) {
      yield* _mapNewDayOffCreatedToState(event);
    } else if (event is DayOffDescriptionChanged) {
      yield* _mapDayOffDescriptionChangedToState(event);
    }
  }

  Stream<ShiftsState> _mapDayOffDescriptionChangedToState(
      DayOffDescriptionChanged event) async* {
    if (state is CreatedOrEditedDayOff) {
      yield (state as CreatedOrEditedDayOff)
          .copyWith(description: event.description);
    }
  }

  Stream<ShiftsState> _mapShiftsShiftStartChangedToState(
      ShiftsStartTimeChanged event) async* {
    if (state is ShiftCreatedOrEdited) {
      yield (state as ShiftCreatedOrEdited)
          .copyWith(shiftStart: event.shiftStart);
    }
  }

  Stream<ShiftsState> _mapShiftsShiftEndChangedToState(
      ShiftsEndTimeChanged event) async* {
    if (state is ShiftCreatedOrEdited) {
      yield (state as ShiftCreatedOrEdited).copyWith(shiftEnd: event.shiftEnd);
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
                currentEmployee: Employee(
                    name: 'open'), // reset employee on designation change
                shiftDate: currentState.shiftDate,
                description: currentState.description,
                shiftEnd: currentState.shiftEnd,
                shiftStart: currentState.shiftStart,
                id: currentState.id,
              )));
    }
  }

  static List<Employee> addOldEmployeeToTheAvailableEmployees(
      {List<Employee> availableEmployees, Employee oldEmployee}) {
    bool openNotInList = true;
    // if the list is not empty
    // check if the 'open' employee is included
    if (availableEmployees != null) {
      for (Employee employee in availableEmployees) {
        if (employee.name == 'open') {
          openNotInList = false;
          break;
        }
      }
      // if open employee not included, then add him
      if (openNotInList) {
        availableEmployees.add(Employee(name: 'open'));
      }
      // if old employee is not empty
      if (oldEmployee != null) {
        // and he is not the 'open' employee then
        if (oldEmployee.name != 'open') {
          // then check if the oldEmployee is already in the list
          bool hOldIsNotInTheList = true;
          for (Employee employee in availableEmployees) {
            if (employee.name == oldEmployee.name) {
              hOldIsNotInTheList = false;
              break;
            }
          }
          // the old employee is not in the availableEmployees List thus add
          if (hOldIsNotInTheList) {
            availableEmployees.add(oldEmployee);
            return availableEmployees;
          } else {
            // else return the list without the old employee
            return availableEmployees;
          }
        }
      } else {
        // since there is no old employee return the list
        return availableEmployees;
      }
    } else {
      // in case there are no available employees then
      // add the 'open' employee
      List<Employee> hAvailableEmployees = new List<Employee>();
      hAvailableEmployees.add(Employee(name: 'open'));
      // check if an old employee exists
      if (oldEmployee != null) {
        // and he is not the 'open' employee then add him
        if (oldEmployee.name != 'open') {
          hAvailableEmployees.add(oldEmployee);
          return hAvailableEmployees;
        }
      } else {
        return hAvailableEmployees;
      }
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
  Stream<ShiftsState> _mapUploadDateEventToState(
      UploadDateEventAdded event) async* {
    //! what happens to the state? In this case I do not have Event -> State
    //! Rolly
    //! discuss in this case why does the initial event with
    //! unchanged values get called. It depends on the subscription.
    _employeeSubscription?.cancel();
    _dateEventsRepository.addOrUpdateDateEvent(event.dateEvent);
    // yield ShiftCreatedOrEdited(
    //     designations: event.designationsList,
    //     currentDesignation: event.dateEvent.designation,
    //     currentEmployee: event.currentEmployee,
    //     availableEmployees: event.availableEmployees, // these are pre-calculated including open and old
    //     shiftDate: event.dateEvent.dateEvent_date,
    //     description: event.dateEvent.description,
    //     shiftEnd: event.dateEvent.end_shift,
    //     shiftStart: event.dateEvent.start_shift,
    //     id: event.dateEvent.id,
    //     oldEmployee: event.oldEmployee);
  }

  // 1) I CreateNewShift (event) -> ShiftCreatedOrEdited (state)
  // 2) EditShift(event) -> PassShiftData(event) -> ShiftCreatedOrEdited(state)

  Stream<ShiftsState> _mapCreateNewShiftToState(NewShiftCreated event) async* {
    final designationsState = await _designationsBloc
        .firstWhere((state) => state.designationsObj.designations.isNotEmpty);
    yield ShiftCreatedOrEdited(
      designations: designationsState.designationsObj.designations,
      currentDesignation: 'open',
      shiftDate: event.shiftDate,
      employeeSpecific: false,
      currentEmployee: Employee(name: 'open'),
      availableEmployees: addOldEmployeeToTheAvailableEmployees(
        availableEmployees: null, oldEmployee: null),
    );
  }

  Stream<ShiftsState> _mapNewShiftEmployeeSpecificCreatedToState(
      NewShiftEmployeeSpecificCreated event) async* {
    yield ShiftCreatedOrEdited(
      //! in this case I only have one designation per employee
      //! and I show the first designation
      currentDesignation: event.employee.designations[0],
      designations: event.employee.designations,
      shiftDate: event.shiftDate,
      currentEmployee: event.employee,
      availableEmployees: [event.employee],
      employeeSpecific: true,
    );
  }

  Stream<ShiftsState> _mapNewDayOffCreatedToState(
      NewDayOffCreated event) async* {
    yield CreatedOrEditedDayOff(
      dayOffDate: event.dayOffDate,
      employeeId: event.employeeId,
      employeeName: event.employeeName,
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
            id: event.id,
            oldEmployee: event.oldEmployee)));
  }

  Stream<ShiftsState> _mapPassShiftDataToState(ShiftDataPushed event) async* {
    final designationsState = await _designationsBloc
        .firstWhere((state) => state.designationsObj.designations.isNotEmpty);

    //  List<Employee> allAvailableEmployees =  [Employee.open()];//event.availableEmployees..addAll([Employee.open(), if state.]);
    //  if (state is ShiftCreatedOrEdited) {
    //    if ((state as ShiftCreatedOrEdited).oldEmployee != )
    //  }
    yield ShiftCreatedOrEdited(
        designations: designationsState.designationsObj.designations,
        currentDesignation: event.currentDesignation,
        currentEmployee: event.currentEmployee,
        availableEmployees: addOldEmployeeToTheAvailableEmployees(
            availableEmployees: event.availableEmployees,
            oldEmployee: event.oldEmployee), //event.availableEmployees,
        shiftDate: event.shiftDate,
        description: event.description,
        shiftEnd: event.shiftEnd,
        shiftStart: event.shiftStart,
        id: event.id,
        oldEmployee: event.oldEmployee);
  }

  @override
  Future<void> close() {
    _employeeSubscription?.cancel();
    _designationsSubscription?.cancel();
    _dateEventsSubscription?.cancel();
    return super.close();
  }
}
