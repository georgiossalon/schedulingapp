import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:employees_repository/employees_repository.dart';
import 'entities/entities.dart';

class FirebaseEmployeesRepository implements EmployeesRepository {
  final String unavailabilitiesCollectionName = 'unavailabilities';

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
  Future<void> addNewUnavailability(Unavailability unavailability, Employee employee) {
    return employeeCollection
        .document(employee.id)
        .collection(unavailabilitiesCollectionName)
        .add(unavailability.toEntity().toDocument());
  }

  @override
  Future<void> deleteUnavailability(Unavailability unavailability, Employee employee) {
    return employeeCollection
            .document(employee.id)
            .collection(unavailabilitiesCollectionName)
            .document(unavailability.id)
            .delete();
  }

  @override
  Future<void> updateUnavailability(Unavailability unavailability, Employee employee) {
    return employeeCollection
            .document(employee.id)
            .collection(unavailabilitiesCollectionName)
            .document(unavailability.id)
            .updateData(unavailability.toEntity().toDocument());
  }

  @override
  Future<void> redoUnavailability(Unavailability unavailability, Employee employee) {
    return employeeCollection
            .document(employee.id)
            .collection(unavailabilitiesCollectionName)
            .document(unavailability.id)
            .setData(unavailability.toEntity().toDocument());
  }

  @override
  Stream<List<Unavailability>> unavailabilities(Employee employee, int numOfWeeks) {
    // TODO: implement unavailabilities
    return null;
  }


}
