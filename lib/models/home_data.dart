import 'package:learnlab/models/exam.dart';
import 'package:learnlab/models/notification.dart';

class HomeData {
  final List<Exam> exams;
  final List<Notification> notifications;

  const HomeData({this.exams = const [], this.notifications = const []});

  HomeData.fromJson(Map<String, Object> json)
      : this(
          exams: ((json['exams'] as Map<String, Object>) ?? {})
              .entries
              .map((e) => Exam.fromJson(e.value as Map<String, Object>, e.key))
              .toList(),
          notifications: ((json['notifications'] as Map<String, Object>) ?? {})
              .entries
              .map(
                (e) => Notification.fromJson(
                    e.value as Map<String, Object>, e.key),
              )
              .toList(),
        );
}
