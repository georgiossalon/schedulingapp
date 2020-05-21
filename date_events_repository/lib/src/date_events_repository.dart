import 'dart:async';

import 'models/models.dart';

abstract class DateEventsRepository {
  Future<void> addNewShift(Shift shift);

  Future<void> deleteShift(Shift shift);

  Stream<List<Shift>> shifts();

  Future<void> redoShift(Shift shift);

  Future<void> addOrUpdateDateEvent(DateEvent dateEvent);

  Future<void> deleteDateEvent(DateEvent dateEvent);

  Future<void> redoDateEvent(DateEvent dateEvent);

  Stream<List<DateEvent>> allDateEventsForGivenEmployee(
      String employeeId, int numOfWeeks, DateTime currentDate);

  Stream<List<DateEvent>> allShiftDateEventsForXWeeks(
      int numOfWeeks, DateTime currentDate);
}
