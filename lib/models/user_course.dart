// 🐦 Flutter imports:
import 'package:flutter/foundation.dart';

/// Information that is used to display one user's course
/// and information about it
/// Also used for tutor courses.
class UserCourse {
  final String documentUid;
  final String userUid;
  final String courseUid;
  final String courseName;
  final bool sl;
  final bool hl;
  final List<int> grades;
  final bool tutor;

  UserCourse({
    this.documentUid,
    @required this.userUid,
    @required this.courseUid,
    @required this.courseName,
    @required this.sl,
    @required this.hl,
    this.grades,
    this.tutor = false,
  });

  UserCourse.fromJson(String uid, Map<String, Object> json,
      {bool tutor = false})
      : this(
          documentUid: uid,
          userUid: json['userUid'] as String,
          courseUid: json['courseUid'] as String,
          courseName: json['courseName'] as String,
          sl: json['sl'] as bool,
          hl: json['hl'] as bool,
          grades: tutor ? null : List.from(json['grades'] as List<dynamic>),
          tutor: tutor,
        );

  Map<String, Object> toJson() {
    return {
      'userUid': userUid,
      'courseUid': courseUid,
      'courseName': courseName,
      'sl': sl,
      'hl': hl,
      if (!tutor) 'grades': grades,
    };
  }

  @override
  String toString() {
    return '''
    <userUid: $userUid, courseUid: $courseUid, courseName: $courseName,
    sl: $sl, hl: $hl, grades: $grades>''';
  }

  String get fullName {
    return '$courseName ${sl && hl ? "SL/HL" : (hl ? "HL" : "SL")}';
  }
}
