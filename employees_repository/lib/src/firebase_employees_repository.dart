import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:employees_repository/employees_repository.dart';
import 'entities/entities.dart';

class FirebaseEmployeesRepository implements EmployeesRepository {
  final String statusesCollectionName = 'statuses';
// todo --
  static final _firestore = Firestore.instance;

  final CollectionReference _employeeCollection = _firestore.collection('Employees');

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
  Future<void> addNewStatus(Status status, Employee employee) {
    return _employeeCollection
        .document(employee.id)
        .collection(statusesCollectionName)
        .add(status.toEntity().toDocument());
  }

  @override
  Future<void> deleteStatus(Status status, Employee employee) {
    return _employeeCollection
            .document(employee.id)
            .collection(statusesCollectionName)
            .document(status.id)
            .delete();
  }

  @override
  Future<void> updateStatus(Status status, Employee employee) {
    return _employeeCollection
            .document(employee.id)
            .collection(statusesCollectionName)
            .document(status.id)
            .updateData(status.toEntity().toDocument());
  }

  @override
  Future<void> redoStatus(Status status, Employee employee) {
    return _employeeCollection
            .document(employee.id)
            .collection(statusesCollectionName)
            .document(status.id)
            .setData(status.toEntity().toDocument());
  }

  @override
  Stream<List<Status>> statuses(Employee employee, int numOfWeeks) {
    // TODO: implement unavailabilities
//    return _employeeCollection.document('${employee.id}').collection('unavailabilities').snapshots().map((snapshot) => snapshots.map((doc) =>status.fromJson(doc.data)));
  }


}
