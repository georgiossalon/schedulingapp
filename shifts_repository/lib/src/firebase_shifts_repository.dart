import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
// import '../shifts_repository.dart';
import 'package:shifts_repository/shifts_repository.dart';
import 'entities/entities.dart';

class FirebaseShiftsRepository implements ShiftsRepository {
  final shiftCollection = Firestore.instance.collection('Shifts');

  @override
  Future<void> addNewShift(Shift shift) {
    return shiftCollection.add(shift.toEntity().toDocument());
  }

  @override
  Future<void> deleteShift(Shift shift) async {
    return shiftCollection.document(shift.id).delete();
  }

  @override
  Stream<List<Shift>> shifts() {
    return shiftCollection.snapshots().map((snapshot) {
      return snapshot.documents
        .map((doc) => Shift.fromEntity(ShiftEntity.fromSnapshot(doc)))
        .toList();
    });
  }

  @override
  Future<void> updateShift(Shift update) {
    return shiftCollection
        .document(update.id)
        .updateData(update.toEntity().toDocument());
  }

  

}