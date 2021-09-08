// 🐦 Flutter imports:
import 'package:flutter/foundation.dart';

/// Information that is used to display one user's tutor
/// and information about it
class UserTutor {
  final String documentUid;
  final String userUid;
  final String tutorUid;
  final String userFirstName;
  final String userLastName;
  final String tutorFirstName;
  final String tutorLastName;
  final String userImageUrl;
  final String tutorImageUrl;
  final Map<String, String> userCourses;
  final Map<String, String> tutorCourses;

  UserTutor({
    @required this.documentUid,
    @required this.userUid,
    @required this.tutorUid,
    @required this.userFirstName,
    @required this.userLastName,
    @required this.tutorFirstName,
    @required this.tutorLastName,
    this.userImageUrl,
    this.tutorImageUrl,
    this.userCourses = const {},
    this.tutorCourses = const {},
  });

  UserTutor.fromJson(String docUid, Map<String, Object> json)
      : this(
          documentUid: docUid,
          userUid: json['userUid'] as String,
          tutorUid: json['tutorUid'] as String,
          userFirstName: json['userFirstName'] as String,
          userLastName: json['userLastName'] as String,
          tutorFirstName: json['tutorFirstName'] as String,
          tutorLastName: json['tutorLastName'] as String,
          userImageUrl: json['userImageUrl'] as String,
          tutorImageUrl: json['tutorImageUrl'] as String,
          userCourses: (json['userCourses'] as Map<String, dynamic>)
              .map((key, value) => MapEntry(key, value.toString())),
          tutorCourses: (json['tutorCourses'] as Map<String, dynamic>)
              .map((key, value) => MapEntry(key, value.toString())),
        );

  String get commonCourses {
    return Set.from(userCourses.keys)
        .intersection(Set.from(tutorCourses.keys))
        .map((e) => userCourses[e])
        .join(' • ');
  }

  String get tutorCoursesString {
    return tutorCourses.values.join(' • ');
  }

  String get userCoursesString {
    return userCourses.values.join(' • ');
  }
}
