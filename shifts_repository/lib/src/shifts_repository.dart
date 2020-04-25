import 'dart:async';

import 'package:shifts_repository/shifts_repository.dart';


abstract class ShiftsRepository {
  Future<void> addNewShift(Shift shift);

  Future<void> deleteShift(Shift shift);

  Stream<List<Shift>> shifts();

  Future<void> updateShift(Shift shift);

  Future<void> redoShift(Shift shift);
}