import 'dart:async';

import 'package:employees_repository/employees_repository.dart';
import 'package:employees_repository/src/models/designations.dart';

abstract class EmployeesRepository {
  Future<void> addNewEmployee(Employee employee);

  Future<void> deleteEmployee(Employee employee);

  Stream<List<Employee>> employees();
  
  Stream<List<Employee>> availableEmployeesForGivenDesignation(String designation, DateTime date);
  
  Future<void> updateEmployee(Employee employee);

  Future<void> redoEmployee(Employee employee);

  Future<void> updateEmployeesBusyMap(String employeeId, Map<String,bool> busy_map);

  // create a stream for a given employee
  //todo only give id instead of the whole object
  // Stream<List<DateEvent>> allDateEventsForGivenEmployee(String employeeId, int numOfWeeks, DateTime currentDate);
  
  // Stream<List<DateEvent>> allShiftDateEventsForXWeeks(int numOfWeeks, DateTime currentDate);

  // // Future<void> updateDateEvent(DateEvent dateEvent);

  // Future<void> deleteDateEvent(DateEvent dateEvent);
  
  // Future<void> addOrUpdateDateEvent(DateEvent dateEvent);
  
  // Future<void> redoDateEvent(DateEvent dateEvent);

  //designations 
  //todo I need a page where the user will add designations
  //todo... when creating an employee there will be a dropdown to choose from
  // Future<List<Designation>> designations();
  Stream<Designations> designations();

  Future<void> addNewDesignation(Designations designationsObj);

  Future<void> deleteDesignation(Designations designationObj);

  Future<void> updateDesignation(Designations designationObj);

  // Stream<Employee> fetchTheOpenEmployee();

}