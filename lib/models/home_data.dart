import 'package:learnlab/models/exam.dart';

class HomeData {
  final List<Exam> exams;

  const HomeData({this.exams = const []});

  HomeData.fromJson(Map<String, Object> json)
      : this(
          exams: ((json['exams'] as Map<String, Object>) ?? {})
              .values
              .map((e) => Exam.fromJson(e as Map<String, Object>))
              .toList(),
        );
}
