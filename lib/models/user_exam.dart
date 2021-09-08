import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class UserExam {
  final String documentUid;
  final String userUid;
  final String courseUid;
  final String courseName;
  final DateTime date;
  final bool hl;

  UserExam({
    @required this.documentUid,
    @required this.userUid,
    @required this.courseUid,
    @required this.courseName,
    @required this.date,
    @required this.hl,
  });

  UserExam.fromJson(String uid, Map<String, Object> json)
      : this(
            documentUid: uid,
            userUid: json['userUid'] as String,
            courseUid: json['courseUid'] as String,
            courseName: json['courseName'] as String,
            date: (json['date'] as Timestamp)?.toDate(),
            hl: json['hl'] as bool);

  String get fullName {
    return '$courseName ${hl ? "HL" : "SL"}';
  }

  int get daysRemaining {
    final today = DateTime.now();
    return DateTime(date.year, date.month, date.day)
        .difference(DateTime(today.year, today.month, today.day))
        .inDays;
  }

  @override
  String toString() {
    return '<course: $courseName - date: $date>';
  }
}
