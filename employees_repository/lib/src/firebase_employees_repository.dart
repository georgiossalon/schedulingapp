import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:employees_repository/employees_repository.dart';
import 'package:employees_repository/src/models/designations.dart';
import 'package:intl/intl.dart';
import 'entities/entities.dart';

class FirebaseEmployeesRepository implements EmployeesRepository {
// todo --
  static final _firestore = Firestore.instance;
  
  final CollectionReference _dateEventsCollection =
      _firestore.collection('DateEvents');

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
  Future<void> updateEmployeesBusyMap(
      String employeeId, Map<String, bool> busy_map) {
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

  // @override
  // Future<void> addOrUpdateDateEvent(DateEvent dateEvent) {
  //   //todo: check if when dateEvent.id == null a new event is created, otherwise updated
  //   return _dateEventsCollection.document(dateEvent.id).setData(dateEvent.toEntity().toDocument());
  // }

  // @override
  // Future<void> deleteDateEvent(DateEvent dateEvent) {
  //   return _dateEventsCollection
  //       .document(dateEvent.id)
  //       .delete();
     
  // }

  // // @override
  // // Future<void> updateDateEvent(DateEvent dateEvent) {
  // //   return _dateEventsCollection
  // //       .document(dateEvent.id)
  // //       .updateData(dateEvent.toEntity().toDocument());
       
  // // }

  // @override
  // Future<void> redoDateEvent(DateEvent dateEvent) {
  //   return _dateEventsCollection
  //       .document(dateEvent.id)
  //       .setData(dateEvent.toEntity().toDocument());
  // }

  // @override
  // Stream<List<DateEvent>> allDateEventsForGivenEmployee(
  //     String employeeId, int numOfWeeks, DateTime currentDate) {
  //   // !at the moment I get events from current week upto the numOfWeeks
  //   DateTime mondayOfCurrentWeek =
  //       currentDate.subtract(new Duration(days: currentDate.weekday - 1));
  //   DateTime dateOfSundayForXthWeek =
  //       mondayOfCurrentWeek.add(new Duration(days: numOfWeeks * 7 - 1));
  //   return _dateEventsCollection
  //       .where('dateEvent_date', isGreaterThanOrEqualTo: mondayOfCurrentWeek)
  //       .where('dateEvent_date', isLessThanOrEqualTo: dateOfSundayForXthWeek)
  //       .snapshots()
  //       .map((snapshot) {
  //     return snapshot.documents.map((doc) {
  //       return DateEvent.fromEntity(DateEventEntity.fromSnapshot(doc));
  //     }).toList();
  //   });
  // }

  // @override
  // Stream<List<DateEvent>> allShiftDateEventsForXWeeks(
  //     int numOfWeeks, DateTime currentDate) {
  //   DateTime mondayOfCurrentWeek =
  //       currentDate.subtract(new Duration(days: currentDate.weekday - 1));
  //   DateTime dateOfSundayForXthWeek =
  //       mondayOfCurrentWeek.add(new Duration(days: numOfWeeks * 7 - 1));
  //   return _dateEventsCollection
  //       .where('reason', isEqualTo: 'shift')
  //       .where('dateEvent_date', isGreaterThanOrEqualTo: mondayOfCurrentWeek)
  //       .where('dateEvent_date', isLessThanOrEqualTo: dateOfSundayForXthWeek)
  //       .snapshots()
  //       .map((snapshot) {
  //     return snapshot.documents.map((doc) {
  //       return DateEvent.fromEntity(DateEventEntity.fromSnapshot(doc));
  //     }).toList();
  //   });
  // }

  @override
  Stream<List<Employee>> availableEmployeesForGivenDesignation(
      String designation, DateTime date) {
    // in firstore the keys of a map are Strings, thus I have to change DateTime to String
    var formatter = new DateFormat('yyyy-MM-dd');
    String formatedDate = formatter.format(date);
    //todo check why I am getting with null also the false employees
    return _employeeCollection
        .where('designations', arrayContains: designation)
        .where('busy_map.$formatedDate', isEqualTo: null) 
        .snapshots()
        .map((snapshot) {
      return snapshot.documents
          .map((doc) => Employee.fromEntity(EmployeeEntity.fromSnapshot(doc)))
          .toList();
    });
  }

  @override
  Stream<Designations> designations() {
    return _designationCollection.snapshots().map((snapshot) {
      if (snapshot.documents.isNotEmpty) {
        return Designations.fromEntity(
            DesignationEntity.fromSnapshot(snapshot.documents.first));
      } else {
        // create a new object with an empty list
        return Designations(
          designations: const [],
        );
      }
    });
  }

  @override
  Future<void> addNewDesignation(Designations designationsObj) {
    designationsObj.designations.add(designationsObj.currentDesignation);
    // the first designation has to be passed as a List element
    return _designationCollection.add(
        DesignationEntity(designations: designationsObj.designations)
            .toDocument());
  }

  @override
  Future<void> deleteDesignation(Designations designation) {
    return _designationCollection.document(designation.id).delete();
  }


  @override
  Future<void> updateDesignation(Designations designationsObj) {
    designationsObj.designations.add(designationsObj.currentDesignation);
    return _designationCollection
        .document(designationsObj.id)
        .updateData(designationsObj.toEntity().toDocument());
  }

 
}
