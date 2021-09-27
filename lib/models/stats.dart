import 'package:cloud_firestore/cloud_firestore.dart';

class Stats {
  final int students;
  final int tutors;
  final int sentNotificationsCount;
  final DateTime notificationsLastSent;

  const Stats({
    this.students,
    this.tutors,
    this.sentNotificationsCount,
    this.notificationsLastSent,
  });

  Stats.fromJson(Map<String, Object> json)
      : this(
          students: json['students'],
          tutors: json['tutors'],
          sentNotificationsCount: json['sentNotificationsCount'],
          notificationsLastSent:
              (json['notificationsLastSent'] as Timestamp)?.toDate(),
        );
}
