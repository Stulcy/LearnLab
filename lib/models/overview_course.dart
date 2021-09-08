import 'package:flutter/foundation.dart';

class OverviewCourse {
  final String uid;
  final String name;
  final double average;

  OverviewCourse({
    @required this.uid,
    @required this.name,
    @required this.average,
  });

  OverviewCourse.fromJson(Map<String, Object> json)
      : this(
            uid: json['uid'] as String,
            name: json['name'] as String,
            average: json['hl'] as double);
}
