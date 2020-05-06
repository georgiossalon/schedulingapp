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
  Stream<List<Unavailability>> unavailabilities(Employee employee, int numOfWeeks);

  Future<void> updateUnavailability(Unavailability unavailability, Employee employee);

  Future<void> deleteUnavailability(Unavailability unavailability, Employee employee);
  
  Future<void> addNewUnavailability(Unavailability unavailability, Employee employee);
  
  Future<void> redoUnavailability(Unavailability unavailability, Employee employee);

}