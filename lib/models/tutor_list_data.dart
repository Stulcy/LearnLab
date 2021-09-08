// 🐦 Flutter imports:
import 'package:flutter/foundation.dart';

// Class holds part of the information for a tutor,
// that is needed when showing list of all tutors to choose from
class TutorListData {
  final String uid;
  final String firstName;
  final String lastName;
  final Map<String, String> courses;

  TutorListData({
    @required this.uid,
    @required this.firstName,
    @required this.lastName,
    this.courses = const {},
  });

  TutorListData.fromJson(Map<String, Object> json)
      : this(
          uid: json['uid'] as String,
          firstName: json['firstName'] as String,
          lastName: json['lastName'] as String,
          courses: (json['courses'] as Map<String, dynamic>)
              .map((key, value) => MapEntry(key, value.toString())),
        );

  Map<String, Object> toJson() {
    return {
      'uid': uid,
      'firstName': firstName,
      'lastName': lastName,
      'courses': courses,
    };
  }

  // Used for search implementation
  @override
  String toString() {
    return '$firstName $lastName ${courses.values.toList().join(' ')}';
  }

  String get coursesString {
    final List<String> coursesNames = courses.values.toList();
    coursesNames.sort();
    return coursesNames.join(', ');
  }

  String get nameString {
    return '$firstName $lastName';
  }
}
