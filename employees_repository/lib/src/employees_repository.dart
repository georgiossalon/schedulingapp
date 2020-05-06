import 'dart:async';

import 'package:employees_repository/employees_repository.dart';

abstract class EmployeesRepository {
  Future<void> addNewEmployee(Employee employee);

  Future<void> deleteEmployee(Employee employee);

  Stream<List<Employee>> employees();
  
  Future<void> updateEmployee(Employee employee);

  Future<void> redoEmployee(Employee employee);

  // create a stream for a given employee
  //todo only give id instead of the whole object
  Stream<List<Status>> statuses(Employee employee, int numOfWeeks);

  Future<void> updateStatus(Status status, Employee employee);

  Future<void> deleteStatus(Status status, Employee employee);
  
  Future<void> addNewStatus(Status status, Employee employee);
  
  Future<void> redoStatus(Status status, Employee employee);

}