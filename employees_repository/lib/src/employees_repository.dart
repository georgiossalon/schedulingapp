import 'dart:async';

import 'package:employees_repository/employees_repository.dart';

abstract class EmployeesRepository {
  Future<void> addNewEmployee(Employee employee);

  Future<void> deleteEmployee(Employee employee);

  Stream<List<Employee>> employees();
  
  Stream<List<Employee>> availableEmployeesForGivenDesignation(String designation, DateTime date);
  
  Future<void> updateEmployee(Employee employee);

  Future<void> redoEmployee(Employee employee);

  // create a stream for a given employee
  //todo only give id instead of the whole object
  Stream<List<Ereignis>> allEreignisesForGivenEmployee(String employeeId, int numOfWeeks, DateTime currentDate);
  
  Stream<List<Ereignis>> allShiftEreignisesForXWeeks(int numOfWeeks, DateTime currentDate);

  Future<void> updateEreignis(Ereignis ereignis);

  Future<void> deleteEreignis(Ereignis ereignis);
  
  Future<void> addNewEreignis(Ereignis ereignis);
  
  Future<void> redoEreignis(Ereignis ereignis);

  //designations 
  //todo I need a page where the user will add designations
  //todo... when creating an employee there will be a dropdown to choose from
  Stream<List<Designation>> designations();

  Future<void> addNewDesignation(Designation designation);

  Future<void> deleteDesignation(Designation designation);

  Future<void> updateDesignation(Designation designation);

}