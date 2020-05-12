import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:employees_repository/employees_repository.dart';
import 'package:intl/intl.dart';
import 'entities/entities.dart';

class FirebaseEmployeesRepository implements EmployeesRepository {
  final String ereignisesCollectionName = 'Ereignises';
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
  Future<void> redoEmployee(Employee redo) {
    return _employeeCollection
        .document(redo.id)
        .setData(redo.toEntity().toDocument());
  }

  @override
  Future<void> addNewEreignis(Ereignis ereignis) {
    return _employeeCollection
        .document(ereignis.parentId)
        .collection(ereignisesCollectionName)
        .add(ereignis.toEntity().toDocument());
  }

  @override
  Future<void> deleteEreignis(Ereignis ereignis) {
    return _employeeCollection
        .document(ereignis.parentId)
        .collection(ereignisesCollectionName)
        .document(ereignis.id)
        .delete();
  }

  @override
  Future<void> updateEreignis(Ereignis ereignis) {
    return _employeeCollection
        .document(ereignis.parentId)
        .collection(ereignisesCollectionName)
        .document(ereignis.id)
        .updateData(ereignis.toEntity().toDocument());
  }

  @override
  Future<void> redoEreignis(Ereignis ereignis) {
    return _employeeCollection
        .document(ereignis.parentId)
        .collection(ereignisesCollectionName)
        .document(ereignis.id)
        .setData(ereignis.toEntity().toDocument());
  }

  @override
  Stream<List<Ereignis>> allEreignisesForGivenEmployee(
      String employeeId, int numOfWeeks, DateTime currentDate) {
    // !at the moment I get events from current week upto the numOfWeeks
    DateTime mondayOfCurrentWeek =
        currentDate.subtract(new Duration(days: currentDate.weekday - 1));
    DateTime dateOfSundayForXthWeek =
        mondayOfCurrentWeek.add(new Duration(days: numOfWeeks * 7 - 1));
    return _employeeCollection
        .document(employeeId)
        .collection(ereignisesCollectionName)
        .where('ereignis_date', isGreaterThanOrEqualTo: mondayOfCurrentWeek)
        .where('ereignis_date', isLessThanOrEqualTo: dateOfSundayForXthWeek)
        .snapshots()
        .map((snapshot) {
      return snapshot.documents.map((doc) {
        return Ereignis.fromEntity(EreignisEntity.fromSnapshot(doc));
      }).toList();
    });
  }

  @override
  Stream<List<Ereignis>> allShiftEreignisesForXWeeks(
      int numOfWeeks, DateTime currentDate) {
    DateTime mondayOfCurrentWeek =
        currentDate.subtract(new Duration(days: currentDate.weekday - 1));
    DateTime dateOfSundayForXthWeek =
        mondayOfCurrentWeek.add(new Duration(days: numOfWeeks * 7 - 1));
    return _firestore
        .collectionGroup('Ereignises')
        .where('reason', isEqualTo: 'shift')
        .where('ereignis_date', isGreaterThanOrEqualTo: mondayOfCurrentWeek)
        .where('ereignis_date', isLessThanOrEqualTo: dateOfSundayForXthWeek)
        .snapshots()
        .map((snapshot) {
      return snapshot.documents.map((doc) {
        return Ereignis.fromEntity(EreignisEntity.fromSnapshot(doc));
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
        .where('designation', isEqualTo: designation)
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
  Stream<List<Designation>> designations() {
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
