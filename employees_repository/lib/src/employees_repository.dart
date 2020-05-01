import 'dart:async';

import 'package:employees_repository/employees_repository.dart';

abstract class EmployeesRepository {
  Future<void> addNewEmployee(Employee employee);
  
  Future<void> addNewUnavailability(Unavailability unavailability);

  Future<void> deleteEmployee(Employee employee);
  
  Future<void> deleteUnavailability(Unavailability unavailability);

  Stream<List<Employee>> employees();
  
  Stream<List<Unavailability>> unavailabilities();

  Future<void> updateEmployee(Employee employee);
  
  Future<void> updateUnavailability(Unavailability unavailability);

  Future<void> redoEmployee(Employee employee);
  
  Future<void> redoUnavailability(Unavailability unavailability);
}