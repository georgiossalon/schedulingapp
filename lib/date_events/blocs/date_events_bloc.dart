import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:snapshot_test/date_events/blocs/date_events.dart';
import 'package:date_events_repository/date_events_repository.dart';

class DateEventsBloc extends Bloc<DateEventsEvent, DateEventsState> {
  final DateEventsRepository _dateEventsRepository; // dependency
  StreamSubscription _dateEventsSubscription;
  // final DesignationsBloc _designationsBloc; // dependency
  // StreamSubscription _designationsSubscription;

  DateEventsBloc(
      {@required DateEventsRepository dateEventsRepository})
      : assert(dateEventsRepository != null),
        _dateEventsRepository = dateEventsRepository;

  @override
  DateEventsState get initialState => DateEventsLoading();

  @override
  Stream<DateEventsState> mapEventToState(DateEventsEvent event) async* {
    if (event is LoadAllDateEventsForEmployeeForXWeeks) {
      yield* _mapLoadDateEventsToState(event);
    } else if (event is AddDateEvent) {
      yield* _mapAddDateEventToState(event);
    // else if (event is UpdateDateEvent) {
    //   yield* _mapUpdateDateEvent(event);
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
    }
  }


  // ! Load only when I ask. For this case I have to use an employee and the number of weeks
  Stream<DateEventsState> _mapLoadDateEventsToState(
      LoadAllDateEventsForEmployeeForXWeeks event) async* {
    _dateEventsSubscription?.cancel();
    _dateEventsSubscription = _dateEventsRepository
        .allDateEventsForGivenEmployee(
            event.employeeId, event.numOfWeeks, DateTime.now())
        .listen((dateEvents) => add(DateEventsUpdated(dateEvents)));
  }

  Stream<DateEventsState> _mapDateEventsLoadAllShiftsForXWeeksToState(
      LoadAllShiftsForXWeeks event) async* {
    _dateEventsSubscription?.cancel();
    _dateEventsSubscription = _dateEventsRepository
        .allShiftDateEventsForXWeeks(event.numOfWeeks, DateTime.now())
        .listen((dateEvents) => add(ShiftDateEventsUpdated(dateEvents)));
  }

  Stream<DateEventsState> _mapAddDateEventToState(AddDateEvent event) async* {
    _dateEventsRepository.addOrUpdateDateEvent(event.dateEvent);
  }

  // Stream<DateEventsState> _mapUpdateDateEvent(UpdateDateEvent event) async* {
  //   _employeesRepository.updateDateEvent(event.dateEvent);
  // }

  Stream<DateEventsState> _mapDeleteDateEventToState(
      DeleteDateEvent event) async* {
    _dateEventsRepository.deleteDateEvent(event.dateEvent);
  }

  Stream<DateEventsState> _mapDateEventsRedoToState(
      RedoDateEvent event) async* {
    _dateEventsRepository.redoDateEvent(event.dateEvent);
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
