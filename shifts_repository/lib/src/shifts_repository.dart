import 'dart:async';

import 'package:shifts_repository/shifts_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class ShiftsRepository {
  Future<void> addNewShift(Shift shift);

  Future<void> deleteShift(Shift shift);

  Stream<Map<DateTime,List<Shift>>> shifts();

  Future<void> updateShift(Shift shift);
}