import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:employees_repository/employees_repository.dart';
import 'entities/entities.dart';

class FirebaseEmployeesRepository implements EmployeesRepository {
  final employeeCollection = Firestore.instance.collection('Employees');

  @override
  Future<void> addNewEmployee(Employee employee) {
    return employeeCollection.add(employee.toEntity().toDocument());
  }

  @override
  Future<void> deleteEmployee(Employee employee) {
    return employeeCollection.document(employee.id).delete();
  }

  @override
  Stream<List<Employee>> employees() {
    return employeeCollection.snapshots().map((snapshot) {
      return snapshot.documents
          .map((doc) => Employee.fromEntity(EmployeeEntity.fromSnapshot(doc)))
          .toList();
    });
  }
    
  // @override
  // Stream<List<Employee>> employees() {
  //   return employeeCollection.snapshots().map((snapshot) {
  //     return snapshot.documents
  //         .map((doc) {

  //           Stream<List<Unavailability>> unavailabilities = 
  //               employeeCollection
  //               .document(doc.documentID)
  //               .collection('Unavailabilities')
  //               .snapshots().map((snapshot) {
  //                 return snapshot.documents
  //                     .map((innerDoc) => Unavailability.fromEntity(UnavailabilityEntity.fromSnapshot(innerDoc)));
  //               });

  //           return Employee.fromEntity(EmployeeEntity.fromSnapshot(doc));})
  //         .toList();
  //   });
  // }

  // @override
  // Stream<List<Unavailability>> unavailabilities() {
  //   return employeeCollection.snapshots().map((snapshot) {
  //     return snapshot.documents
  //         .map((doc) {
  //           employeeCollection
  //           .document(doc.documentID)
  //           .collection('unavailabilities')
  //           .snapshots().map((snapshot) {
  //             return snapshot.documents
  //                 .map((innterDoc) => Unavailability.fromEntity(UnavailabilityEntity.fromSnapshot(innterDoc)))
  //                 .toList();
  //           });

  //         }).toList();
  //   });
  // }

  @override
  Future<void> updateEmployee(Employee update) {
    return employeeCollection
        .document(update.id)
        .updateData(update.toEntity().toDocument());
  }

  @override
  Future<void> redoEmployee(Employee redo) {
    return employeeCollection
        .document(redo.id)
        .setData(redo.toEntity().toDocument());
  }

  @override
  Future<void> addNewUnavailability(Unavailability unavailability) {
    // TODO: implement addNewUnavailability
    return null;
  }

  @override
  Future<void> deleteUnavailability(Unavailability unavailability) {
    // TODO: implement deleteUnavailability
    return null;
  }

  @override
  Future<void> redoUnavailability(Unavailability unavailability) {
    // TODO: implement redoUnavailability
    return null;
  }

  @override
  Future<void> updateUnavailability(Unavailability unavailability) {
    // TODO: implement updateUnavailability
    return null;
  }

  @override
  Stream<List<Unavailability>> unavailabilities() {
    // TODO: implement unavailabilities
    return null;
  }

  //todo implement unavailability

}
