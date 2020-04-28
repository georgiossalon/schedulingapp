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


}