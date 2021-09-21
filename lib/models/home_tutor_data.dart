import 'package:learnlab/models/exam.dart';

class HomeTutorData {
  final Map<String, Map<String, dynamic>> userExams;

  const HomeTutorData({this.userExams = const {}});

  HomeTutorData.fromJson(Map<String, Object> json)
      : this(
          userExams: ((json['userExams'] as Map<String, Object>) ?? {}).map(
            (key, value) {
              final Map<String, Object> data = value as Map<String, Object>;
              final String first = data['firstName'] as String;
              final String last = data['lastName'] as String;

              final Map<String, Object> exams = data;
              data.removeWhere(
                  (key, _) => key == 'firstName' || key == 'lastName');
              return MapEntry(key, {
                'firstName': first,
                'lastName': last,
                'exams': exams.entries
                    .map((e) => Exam.fromJson(
                          e.value as Map<String, Object>,
                          e.key,
                        ))
                    .toList(),
              });
            },
          ),
        );
}
