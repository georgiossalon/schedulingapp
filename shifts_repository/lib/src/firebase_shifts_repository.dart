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
    return shiftCollection.document(shift.firestore_id).delete();
  }

  @override
  Stream<Map<DateTime, List<Shift>>> shifts() {
    Map<DateTime, List<Shift>> hMap = new Map<DateTime, List<Shift>>();
    return shiftCollection.snapshots().map((snapshot) {
      for (var doc in snapshot.documents) {
        Shift shift = Shift.fromEntity(ShiftEntity.fromSnapshot(doc));
        //when for a given day there is no entry or all entries were deleted
        if (hMap[shift.shift_date] == null || hMap[shift.shift_date].isEmpty) {
          hMap[shift.shift_date] = [shift];
        } else {
          //!!I am searching if the document already exists so I do not add it twice !!
          //!! Since there wont be more than 10-20 shifts within the same day
          //!! the following method should not take that long !!
          List<Shift> hList = updatedList(hMap[shift.shift_date], shift);
          if (hList == null) {
            // this means a document was only updated for a day with documents
            hMap[shift.shift_date].add(shift);
          } 
          // else {
          //   hMap[shift.shift_date] = hList;
          //   // a new document was added for a day with existing documents
          // }
        }
      }
      return hMap;
      // snapshot.documents
      // .map((doc) => Shift.fromEntity(ShiftEntity.fromSnapshot(doc)))
      // .toList()};
    });
  }

  @override
  Future<void> updateShift(Shift update) {
    return shiftCollection
        .document(update.firestore_id)
        .updateData(update.toEntity().toDocument());
  }

  List<Shift> updatedList(List<Shift> hList, Shift newShift) {
    for (var i = 0; i < hList.length; i++) {
      Shift shift = hList[i];
      if (shift.firestore_id == newShift.firestore_id) {
        //update only if necesery
        if (shift != newShift) {
          hList[i] = newShift;
          return hList;
        } else {
          // return without updating
          return hList;
        }
      }
    }
    return null;
  }
}
