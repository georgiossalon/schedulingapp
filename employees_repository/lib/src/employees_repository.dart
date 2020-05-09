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
  Stream<List<Status>> allStatusesForGivenEmployee(String employeeId, int numOfWeeks, DateTime currentDate);
  
  Stream<List<Status>> allShiftStatuses(int numOfWeeks, DateTime currentDate);

  Future<void> updateStatus(Status status, String employeeId);

  Future<void> deleteStatus(Status status, String employeeId);
  
  Future<void> addNewStatus(Status status, String employeeId);
  
  Future<void> redoStatus(Status status, String employeeId);

}