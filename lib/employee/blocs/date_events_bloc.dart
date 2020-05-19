import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:snapshot_test/employee/blocs/date_events.dart';
import 'package:employees_repository/employees_repository.dart';
import 'package:snapshot_test/employee/blocs/designations.dart';

class DateEventsBloc extends Bloc<DateEventsEvent, DateEventsState> {
  final EmployeesRepository _employeesRepository; // dependency
  StreamSubscription _dateEventsSubscription;
  StreamSubscription _employeesSubscription;
  final DesignationsBloc _designationsBloc; // dependency
  StreamSubscription _designationsSubscription;

  DateEventsBloc(this._designationsBloc,
      {@required EmployeesRepository employeesRepository})
      : assert(employeesRepository != null),
        _employeesRepository = employeesRepository;

  @override
  DateEventsState get initialState => DateEventsLoading();

  @override
  Stream<DateEventsState> mapEventToState(DateEventsEvent event) async* {
    if (event is LoadAllDateEventsForEmployeeForXWeeks) {
      yield* _mapLoadDateEventsToState(event);
    } else if (event is AddDateEvent) {
      yield* _mapAddDateEventToState(event);
    } else if (event is UpdateDateEvent) {
      yield* _mapUpdateDateEvent(event);
    } else if (event is DeleteDateEvent) {
      yield* _mapDeleteDateEventToState(event);
    } else if (event is RedoDateEvent) {
      yield* _mapDateEventsRedoToState(event);
    } else if (event is DateEventsUpdated) {
      yield* _mapDateEventsUpdateToState(event);
    } else if (event is LoadAllShiftsForXWeeks) {
      yield* _mapDateEventsLoadAllShiftsForXWeeksToState(event);
    } else if (event is ShiftDateEventsUpdated) {
      yield* _mapShiftDateEventsUpdateToState(event);
    } else if (event is CreateNewShift) {
      // yield* _mapCreateNewShiftToState(event);
    } else if (event is FetchOpenEmployeeAndSaveDesignations) {
      yield* _mapFetchOpenEmployeeToState(event);
    } else if (event is OpenEmployeeUpdate) {
      yield* _mapOpenEmployeeUpdateToState(event);
    } else if (event is LoadDesignationsForShift) {
      yield* _mapLoadDesignationsForShiftToState();
    } else if (event is DesignationsUpdatedForShift) {
      yield* _mapDesignationsUpdatedToState(event);
    }
  }

  // Stream<DateEventsState> _mapCreateNewShiftToState(CreateNewShift event) {
  //   //
  //    LoadDesignationsForShift();
  //   // FetchOpenEmployee();
  // }

  Stream<DateEventsState> _mapLoadDesignationsForShiftToState() async* {
    _designationsSubscription?.cancel();
    _designationsBloc.listen((state) {

    });
    // _designationsSubscription = _employeesRepository.designations().listen(
    //       // I am Listening a Designations object
    //       // I am only passing its List<String> of designations
    //       (designations) => add(DesignationsUpdatedForShift(designations)),
    //     );
  }

  Stream<DateEventsState> _mapDesignationsUpdatedToState(
      DesignationsUpdatedForShift event) async* {
    //todo: fetch open employee perhaps here?
    // FetchOpenEmployeeAndSaveDesignations(event.designations.designations);
    _employeesSubscription?.cancel();
    _employeesSubscription = _employeesRepository.fetchTheOpenEmployee().listen(
        (employee) =>
            add(OpenEmployeeUpdate(employee, event.designations.designations)));

    // yield DesignationsForShiftUpdated(event.designations.designations);
  }

  //todo: future RxDart StreamValue
  Stream<DateEventsState> _mapOpenEmployeeUpdateToState(
      OpenEmployeeUpdate event) async* {
        final designations = await _designationsBloc.firstWhere((state) => state is DesignationsLoaded);
    yield NewShiftCreated((designations as DesignationsLoaded).designations, event.openEmployee);
  }

  Stream<DateEventsState> _mapFetchOpenEmployeeToState(
      FetchOpenEmployeeAndSaveDesignations event) async* {
    _employeesSubscription?.cancel();
    _employeesSubscription = _employeesRepository.fetchTheOpenEmployee().listen(
        (employee) => add(OpenEmployeeUpdate(employee, event.designations)));
  }

  // ! Load only when I ask. For this case I have to use an employee and the number of weeks
  Stream<DateEventsState> _mapLoadDateEventsToState(
      LoadAllDateEventsForEmployeeForXWeeks event) async* {
    _dateEventsSubscription?.cancel();
    _dateEventsSubscription = _employeesRepository
        .allDateEventsForGivenEmployee(
            event.employeeId, event.numOfWeeks, DateTime.now())
        .listen((dateEvents) => add(DateEventsUpdated(dateEvents)));
  }

  Stream<DateEventsState> _mapDateEventsLoadAllShiftsForXWeeksToState(
      LoadAllShiftsForXWeeks event) async* {
    _dateEventsSubscription?.cancel();
    _dateEventsSubscription = _employeesRepository
        .allShiftDateEventsForXWeeks(event.numOfWeeks, DateTime.now())
        .listen((dateEvents) => add(ShiftDateEventsUpdated(dateEvents)));
  }

  // ! This will only add an dateEvent to the already started stream for the given employee.
  // ! Use Future or a Stream ?
  //todo: implement a method that pushes for a given employee
  Stream<DateEventsState> _mapAddDateEventToState(AddDateEvent event) async* {
    _employeesRepository.addNewDateEvent(event.dateEvent);
  }

  Stream<DateEventsState> _mapUpdateDateEvent(UpdateDateEvent event) async* {
    _employeesRepository.updateDateEvent(event.dateEvent);
  }

  Stream<DateEventsState> _mapDeleteDateEventToState(
      DeleteDateEvent event) async* {
    _employeesRepository.deleteDateEvent(event.dateEvent);
  }

  Stream<DateEventsState> _mapDateEventsRedoToState(
      RedoDateEvent event) async* {
    _employeesRepository.redoDateEvent(event.dateEvent);
  }

  Stream<DateEventsState> _mapDateEventsUpdateToState(
      DateEventsUpdated event) async* {
    yield DateEventsLoaded(event.dateEvents);
  }

  Stream<DateEventsState> _mapShiftDateEventsUpdateToState(
      ShiftDateEventsUpdated event) async* {
    yield ShiftDateEventsLoaded(event.dateEvents);
  }

  @override
  Future<void> clode() {
    _dateEventsSubscription?.cancel();
    return super.close();
  }
}
