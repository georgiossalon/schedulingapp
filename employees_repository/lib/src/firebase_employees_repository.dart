import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:employees_repository/employees_repository.dart';
import 'package:employees_repository/src/models/designations.dart';
import 'package:intl/intl.dart';
import 'entities/entities.dart';

class FirebaseEmployeesRepository implements EmployeesRepository {
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
      EmployeeDateEvent employeeDateEvent) {
        // I do not need the busy map of the employee, since I only get the
        // available employees for the given date. Also I can only update an
        // entity of the busy_map in firestore, thus I do not need to update the
        // whole busy_map
         var formatter = new DateFormat('yyyy-MM-dd');
    String formatedDate = formatter.format(employeeDateEvent.dateEvent_date);
        
    return _employeeCollection
        .document(employeeDateEvent.employeeId)
        .updateData({'busy_map.${formatedDate}': employeeDateEvent.reason});
  }

  //! Rolly
  // todo can I complete delete the key (entry) from the map? 
  Future<void> deleteEmployeesDateEventBusyMapElement(String oldEmployeeId, DateTime dateTime) {
    var formatter = new DateFormat('yyyy-MM-dd');
    String formatedDate = formatter.format(dateTime);
    return _employeeCollection
        .document(oldEmployeeId)
        .updateData({'busy_map.${formatedDate}': null});
  }

  @override
  Future<void> redoEmployee(Employee redo) {
    return _employeeCollection
        .document(redo.id)
        .setData(redo.toEntity().toDocument());
  }

  // @override
  // Future<void> addOrUpdateDateEvent(DateEvent dateEvent) {
  
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
    return _employeeCollection
        .where('designations', arrayContains: designation)
        //todo: the following line does not work for when the map does not
        //todo... have the following date entry
        .where('busy_map.$formatedDate', isNull: true) 
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
    // the currentDesignation has to get added to the designations List first
    // designationsObj.designations.add(designationsObj.currentDesignation);
    //todo: 
    List<String> h = List.from(designationsObj.designations)..add(designationsObj.currentDesignation);
    // h.add(designationsObj.currentDesignation);
    //todo: instead of uploading the whole new list just upload the new designation
    return _designationCollection.document(designationsObj.id).setData(
        DesignationEntity(designations: h)
            .toDocument());
  }

  @override
  Future<void> deleteDesignation(Designations designation) {
    return _designationCollection.document(designation.id).delete();
  }


  // @override
  // Future<void> updateDesignation(Designations designationsObj) {
  //   designationsObj.designations.add(designationsObj.currentDesignation);
  //   return _designationCollection
  //       .document(designationsObj.id)
  //       .updateData(designationsObj.toEntity().toDocument());
  // }

 
}
