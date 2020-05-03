import 'dart:async';

import 'package:employees_repository/employees_repository.dart';

abstract class EmployeesRepository {
  Future<void> addNewEmployee(Employee employee);

  Future<void> deleteEmployee(Employee employee);

  Stream<List<Employee>> employees();
  
  Future<void> updateEmployee(Employee employee);

  Future<void> redoEmployee(Employee employee);

  // create a stream for a given employee
  Stream<List<Unavailability>> unavailabilities(Employee employee, int numOfWeeks);

  Future<void> updateUnavailability(Unavailability unavailability);

  Future<void> deleteUnavailability(Unavailability unavailability);
  
  Future<void> addNewUnavailability(Unavailability unavailability);
  
  Future<void> redoUnavailability(Unavailability unavailability);

}