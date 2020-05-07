import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DateInfo {

  static DateTime utcTo12oclock(DateTime dateTimeToChange) {
    if (dateTimeToChange != null) {
      DateTime dateOfEvent = dateTimeToChange.toLocal();
      /*each device has a different utc. The table_calendar gives back
    everything as utc. Thus I have to find a way to edit everything to 12 o'clock*/
      return new DateTime(
          dateOfEvent.year, dateOfEvent.month, dateOfEvent.day, 12);
    }
  }

  static DateTime convertingFirestoreDateToDateTime(Timestamp timestamp) {
    DateTime dateTimeHiringDate =
        DateTime.fromMillisecondsSinceEpoch(timestamp.millisecondsSinceEpoch);
    return DateTime(dateTimeHiringDate.year, dateTimeHiringDate.month,
        dateTimeHiringDate.day, 12);
  }
}