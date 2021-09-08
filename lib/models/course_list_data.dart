// 🐦 Flutter imports:
import 'package:flutter/foundation.dart';

// Class holds part of the information for a course,
// that is needed when showing list of all courses to choose from
class CourseListData {
  final String uid;
  final String name;
  final bool sl;
  final bool hl;

  CourseListData({
    @required this.uid,
    @required this.name,
    @required this.hl,
    this.sl = false,
  });

  CourseListData.fromJson(Map<String, Object> json)
      : this(
            uid: json['uid'] as String,
            name: json['name'] as String,
            hl: json['hl'] as bool);

  Map<String, Object> toJson() {
    return {
      'uid': uid,
      'name': name,
      'hl': hl,
    };
  }

  // Used for search implementation
  @override
  String toString() {
    return name;
  }

  String get fullName {
    return '$name ${sl && hl ? "SL/HL" : (hl ? "HL" : "SL")}';
  }
}
