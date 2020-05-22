import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'date_events_repository.dart';
import 'entities/entities.dart';
import 'models/models.dart';

class FirebaseDateEventsRepository implements DateEventsRepository {
  static final _firestore = Firestore.instance;

  final _shiftCollection = _firestore.collection('Shifts');

  final CollectionReference _dateEventsCollection =
      _firestore.collection('DateEvents');

  @override
  Future<void> addNewShift(Shift shift) {
    return _shiftCollection
        .document(shift.id)
        .setData(shift.toEntity().toDocument());
  }

  @override
  Future<void> deleteShift(Shift shift) async {
    return _shiftCollection.document(shift.id).delete();
  }

  @override
  Stream<List<Shift>> shifts() {
    return _shiftCollection.snapshots().map((snapshot) {
      return snapshot.documents
          .map((doc) => Shift.fromEntity(ShiftEntity.fromSnapshot(doc)))
          .toList();
    });
  }

  @override
  Future<void> redoShift(Shift redo) {
    return _shiftCollection
        .document(redo.id)
        .setData(redo.toEntity().toDocument());
  }

  @override
  Future<void> addOrUpdateDateEvent(DateEvent dateEvent) {
    return _dateEventsCollection
        .document(dateEvent.id)
        .setData(dateEvent.toEntity().toDocument());
  }

  @override
  Future<void> deleteDateEvent(DateEvent dateEvent) {
    return _dateEventsCollection.document(dateEvent.id).delete();
  }

  // @override
  // Future<void> updateDateEvent(DateEvent dateEvent) {
  //   return _dateEventsCollection
  //       .document(dateEvent.id)
  //       .updateData(dateEvent.toEntity().toDocument());

  // }

  @override
  Future<void> redoDateEvent(DateEvent dateEvent) {
    return _dateEventsCollection
        .document(dateEvent.id)
        .setData(dateEvent.toEntity().toDocument());
  }

  @override
  Stream<List<DateEvent>> allDateEventsForGivenEmployee(
      String employeeId, int numOfWeeks, DateTime currentDate) {
    // !at the moment I get events from current week upto the numOfWeeks
    DateTime mondayOfCurrentWeek =
        currentDate.subtract(new Duration(days: currentDate.weekday - 1));
    DateTime dateOfSundayForXthWeek =
        mondayOfCurrentWeek.add(new Duration(days: numOfWeeks * 7 - 1));
    return _dateEventsCollection
        .where('dateEvent_date', isGreaterThanOrEqualTo: mondayOfCurrentWeek)
        .where('dateEvent_date', isLessThanOrEqualTo: dateOfSundayForXthWeek)
        .where('employee_id', isEqualTo: employeeId)
        .snapshots()
        .map((snapshot) {
      return snapshot.documents.map((doc) {
        return DateEvent.fromEntity(DateEventEntity.fromSnapshot(doc));
      }).toList();
    });
  }

  @override
  Stream<List<DateEvent>> allShiftDateEventsForXWeeks(
      int numOfWeeks, DateTime currentDate) {
    DateTime mondayOfCurrentWeek =
        currentDate.subtract(new Duration(days: currentDate.weekday - 1));
    DateTime dateOfSundayForXthWeek =
        mondayOfCurrentWeek.add(new Duration(days: numOfWeeks * 7 - 1));
    return _dateEventsCollection
        .where('reason', isEqualTo: 'shift')
        .where('dateEvent_date', isGreaterThanOrEqualTo: mondayOfCurrentWeek)
        .where('dateEvent_date', isLessThanOrEqualTo: dateOfSundayForXthWeek)
        .snapshots()
        .map((snapshot) {
      return snapshot.documents.map((doc) {
        return DateEvent.fromEntity(DateEventEntity.fromSnapshot(doc));
      }).toList();
    });
  }
}
