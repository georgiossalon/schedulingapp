import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:employees_repository/employees_repository.dart';
import 'package:intl/intl.dart';
import 'entities/entities.dart';

class FirebaseEmployeesRepository implements EmployeesRepository {
  final String dateEventsCollectionName = 'DateEvents';
// todo --
  static final _firestore = Firestore.instance;

  final CollectionReference _employeeCollection =
      _firestore.collection('Employees');

  final CollectionReference _designationCollection =
      _firestore.collection('Designations');

  @override
  Future<void> addNewEmployee(Employee employee) {
    return _employeeCollection.add(employee.toEntity().toDocument());
  }

  // todo: Pass only the id as a String insted of the whole object
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
  Future<void> updateEmployeesBusyMap(String employeeId, Map<String,bool> busy_map) {
    return _employeeCollection
        .document(employeeId)
        .updateData({'busy_map': busy_map});
  }

  @override
  Future<void> redoEmployee(Employee redo) {
    return _employeeCollection
        .document(redo.id)
        .setData(redo.toEntity().toDocument());
  }

  @override
  Future<void> addNewDateEvent(DateEvent dateEvent) {
    return _employeeCollection
        .document(dateEvent.parentId)
        .collection(dateEventsCollectionName)
        .add(dateEvent.toEntity().toDocument());
  }

  @override
  Future<void> deleteDateEvent(DateEvent dateEvent) {
    return _employeeCollection
        .document(dateEvent.parentId)
        .collection(dateEventsCollectionName)
        .document(dateEvent.id)
        .delete();
  }

  @override
  Future<void> updateDateEvent(DateEvent dateEvent) {
    return _employeeCollection
        .document(dateEvent.parentId)
        .collection(dateEventsCollectionName)
        .document(dateEvent.id)
        .updateData(dateEvent.toEntity().toDocument());
  }

  @override
  Future<void> redoDateEvent(DateEvent dateEvent) {
    return _employeeCollection
        .document(dateEvent.parentId)
        .collection(dateEventsCollectionName)
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
    return _employeeCollection
        .document(employeeId)
        .collection(dateEventsCollectionName)
        .where('dateEvent_date', isGreaterThanOrEqualTo: mondayOfCurrentWeek)
        .where('dateEvent_date', isLessThanOrEqualTo: dateOfSundayForXthWeek)
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
    return _firestore
        .collectionGroup('DateEvents')
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

  @override
  Stream<List<Employee>> availableEmployeesForGivenDesignation(
      String designation, DateTime date) {
    // in firstore the keys of a map are Strings, thus I have to change DateTime to String
    var formatter = new DateFormat('yyyy-MM-dd');
    String formatedDate = formatter.format(date);
    return _employeeCollection
        .where('designations', arrayContains: designation)
        .where('busy_map.$formatedDate',
            isEqualTo: false) 
        .snapshots()
        .map((snapshot) {
      return snapshot.documents
          .map((doc) => Employee.fromEntity(EmployeeEntity.fromSnapshot(doc)))
          .toList();
    });
  }

  @override
  // Future<List<Designation>> designations() {
  Stream<List<Designation>> designations() {
    // return _designationCollection.getDocuments().then((designations) {
    //   List<Designation> hList = new List();
    //   for (DocumentSnapshot item in designations.documents) {
    //     hList.add(Designation.fromEntity(DesignationEntity.fromSnapshot(item)));
    //   }
    // return hList;
    // }); 
    return _designationCollection.snapshots().map((snapshot) {
      return snapshot.documents
          .map((doc) => Designation.fromEntity(DesignationEntity.fromSnapshot(doc)))
          .toList();
    });
  }

  @override
  Future<void> addNewDesignation(Designation designation) {
    return _designationCollection.add(designation.toEntity().toDocument());
  }

  @override
  Future<void> deleteDesignation(Designation designation) {
    return _designationCollection.document(designation.id).delete();
  }

  @override
  Future<void> updateDesignation(Designation designation) {
    return _designationCollection.document(designation.id)
        .updateData(designation.toEntity().toDocument());
  }

  
}
