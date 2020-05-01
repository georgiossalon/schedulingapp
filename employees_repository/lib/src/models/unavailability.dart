import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import '../entities/entities.dart';

@immutable
class Unavailability {
  final DateTime unavailabilityDate;
  final String start_shift;
  final String end_shift;
  final String reason;
  final String description;
  
  Unavailability({
    this.unavailabilityDate,
    this.start_shift,
    this.end_shift,
    this.reason,
    this.description,
  });

  static DateTime convertingFirestoreDateToDateTime(Timestamp timestamp) {
    if (timestamp != null) {
    DateTime dateTimeHiringDate =
        DateTime.fromMillisecondsSinceEpoch(timestamp.millisecondsSinceEpoch);
    return DateTime(dateTimeHiringDate.year, dateTimeHiringDate.month,
        dateTimeHiringDate.day, 12);
    }
  }

  Unavailability copyWith({
    DateTime unavailabilityDate,
    String start_shift,
    String end_shift,
    String reason,
    String description,
  }) {
    return Unavailability(
      unavailabilityDate: unavailabilityDate ?? this.unavailabilityDate,
      start_shift: start_shift ?? this.start_shift,
      end_shift: end_shift ?? this.end_shift,
      reason: reason ?? this.reason,
      description: description ?? this.description,
    );
  }

  @override
  int get hashCode {
    return unavailabilityDate.hashCode ^
      start_shift.hashCode ^
      end_shift.hashCode ^
      reason.hashCode ^
      description.hashCode;
  }
 
  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is Unavailability &&
      o.unavailabilityDate == unavailabilityDate &&
      o.start_shift == start_shift &&
      o.end_shift == end_shift &&
      o.reason == reason &&
      o.description == description;
  }
  
  @override
  String toString() {
    return 'Unavailability(unavailabilityDate: $unavailabilityDate, start_shift: $start_shift, end_shift: $end_shift, reason: $reason, description: $description)';
  }

  UnavailabilityEntity toEntity() {
    return UnavailabilityEntity(
      unavailabilityDate: unavailabilityDate, 
      start_shift: start_shift, 
      end_shift: end_shift,
      reason: reason, 
      description: description
    );
  }

  static Unavailability fromEntity(UnavailabilityEntity entity) {
    return Unavailability(
      unavailabilityDate: entity.unavailabilityDate,
      start_shift: entity.start_shift,
      end_shift: entity.end_shift,
      reason: entity.reason,
      description: entity.description
    );
  }

}
