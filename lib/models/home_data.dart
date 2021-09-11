import 'package:learnlab/models/exam.dart';
import 'package:learnlab/models/notification.dart';

class HomeData {
  final List<Exam> exams;
  final List<Notification> notifications;

  const HomeData({this.exams = const [], this.notifications = const []});

  HomeData.fromJson(Map<String, Object> json)
      : this(
          exams: ((json['exams'] as Map<String, Object>) ?? {})
              .values
              .map((e) => Exam.fromJson(e as Map<String, Object>))
              .toList(),
          notifications: ((json['notifications'] as List) ?? [])
              .map(
                (e) => Notification.fromJson(e as Map<String, Object>),
              )
              .toList(),
        );
}
