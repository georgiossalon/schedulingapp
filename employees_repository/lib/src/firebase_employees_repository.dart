import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:employees_repository/employees_repository.dart';
import 'entities/entities.dart';

class FirebaseEmployeesRepository implements EmployeesRepository {
  final String statusesCollectionName = 'Statuses';
// todo --
  static final _firestore = Firestore.instance;

  final CollectionReference _employeeCollection =
      _firestore.collection('Employees');

  @override
  Future<void> addNewEmployee(Employee employee) {
    return _employeeCollection.add(employee.toEntity().toDocument());
  }

  @override
  Future<void> deleteEmployee(Employee employee) {
    return _employeeCollection.document(employee.id).delete();
  }

  @override
  Stream<List<Employee>> employees() {
    return _employeeCollection.snapshots().map((snapshot) {
      return snapshot.documents
          .map((doc) => Employee.fromEntity(EmployeeEntity.fromSnapshot(doc)))
          .toList();
    });
  }

  @override
  Future<void> updateEmployee(Employee update) {
    return _employeeCollection
        .document(update.id)
        .updateData(update.toEntity().toDocument());
  }

  @override
  Future<void> redoEmployee(Employee redo) {
    return _employeeCollection
        .document(redo.id)
        .setData(redo.toEntity().toDocument());
  }

  @override
  Future<void> addNewStatus(Status status, String employeeId) {
    return _employeeCollection
        .document(employeeId)
        .collection(statusesCollectionName)
        .add(status.toEntity().toDocument());
  }

  @override
  Future<void> deleteStatus(Status status, String employeeId) {
    return _employeeCollection
        .document(employeeId)
        .collection(statusesCollectionName)
        .document(status.id)
        .delete();
  }

  @override
  Future<void> updateStatus(Status status, String employeeId) {
    return _employeeCollection
        .document(employeeId)
        .collection(statusesCollectionName)
        .document(status.id)
        .updateData(status.toEntity().toDocument());
  }

  @override
  Future<void> redoStatus(Status status, String employeeId) {
    return _employeeCollection
        .document(employeeId)
        .collection(statusesCollectionName)
        .document(status.id)
        .setData(status.toEntity().toDocument());
  }

  @override
  Stream<List<Status>> allStatusesForGivenEmployee(
      String employeeId, int numOfWeeks, DateTime currentDate) {
    // !at the moment I get events from current week upto the numOfWeeks
    DateTime mondayOfCurrentWeek =
        currentDate.subtract(new Duration(days: currentDate.weekday - 1));
    DateTime dateOfSundayForXthWeek =
        mondayOfCurrentWeek.add(new Duration(days: numOfWeeks * 7 - 1));
    return _employeeCollection
        .document(employeeId)
        .collection(statusesCollectionName)
        .where('status_date', isGreaterThanOrEqualTo: mondayOfCurrentWeek)
        .where('status_date', isLessThanOrEqualTo: dateOfSundayForXthWeek)
        .snapshots()
        .map((snapshot) {
      return snapshot.documents.map((doc) {
        return Status.fromEntity(StatusEntity.fromSnapshot(doc));
      }).toList();
    });
  }

  // todo check if this is working properly!
  @override
  Stream<List<Status>> allShiftStatuses(int numOfWeeks, DateTime currentDate) {
    DateTime mondayOfCurrentWeek =
        currentDate.subtract(new Duration(days: currentDate.weekday - 1));
    DateTime dateOfSundayForXthWeek =
        mondayOfCurrentWeek.add(new Duration(days: numOfWeeks * 7 - 1));
    return _firestore
        .collectionGroup('Statuses')
        .where('reason', isEqualTo: 'shift')
        .where('status_date', isGreaterThanOrEqualTo: mondayOfCurrentWeek)
        .where('status_date', isLessThanOrEqualTo: dateOfSundayForXthWeek)
        .snapshots()
        .map((snapshot) {
      return snapshot.documents.map((doc) {
        return Status.fromEntity(StatusEntity.fromSnapshot(doc));
      }).toList();
    });
  }
}
