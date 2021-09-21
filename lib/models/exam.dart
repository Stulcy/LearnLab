import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Exam extends Comparable<Exam> {
  final String id;
  final String courseFullName;
  final DateTime examDate;

  int get daysRemaining {
    final today = DateTime.now();
    return DateTime(examDate.year, examDate.month, examDate.day)
        .difference(DateTime(today.year, today.month, today.day))
        .inDays;
  }

  Exam({
    @required this.id,
    @required this.courseFullName,
    @required this.examDate,
  });

  Exam.fromJson(Map<String, Object> json, String uid)
      : this(
          id: uid,
          courseFullName: json['courseName'] as String,
          examDate: (json['date'] as Timestamp)?.toDate(),
        );

  @override
  int compareTo(Exam other) {
    return examDate.compareTo(other.examDate);
  }
}
