// 📦 Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:learnlab/models/home_data.dart';
import 'package:learnlab/models/home_tutor_data.dart';
import 'package:learnlab/models/overview_course.dart';

// 🌎 Project imports:
import 'package:learnlab/models/user_course.dart';
import 'package:learnlab/models/user_exam.dart';
import 'package:learnlab/models/user_tutor.dart';

class SnapshotService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String uid;

  SnapshotService({this.uid});

  Stream<List<UserCourse>> get userCourses {
    return _db
        .collection('user_courses')
        .where('userUid', isEqualTo: uid)
        .snapshots()
        .map(_userCoursesFromSnapshot);
  }

  /* Create list of user's courses from snapshot */
  List<UserCourse> _userCoursesFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs
        .map((doc) =>
            UserCourse.fromJson(doc.id, doc.data() as Map<String, Object>))
        .toList();
  }

  Stream<List<UserCourse>> get tutorCourses {
    return _db
        .collection('tutor_courses')
        .where('userUid', isEqualTo: uid)
        .snapshots()
        .map(_tutorCoursesFromSnapshot);
  }

  List<UserCourse> _tutorCoursesFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs
        .map((doc) => UserCourse.fromJson(
              doc.id,
              doc.data() as Map<String, Object>,
              tutor: true,
            ))
        .toList();
  }

  Stream<List<UserTutor>> get userTutors {
    return _db
        .collection('user_tutors')
        .where('userUid', isEqualTo: uid)
        .snapshots()
        .map(_userTutorsFromSnapshot);
  }

  Stream<List<UserTutor>> get tutorStudents {
    return _db
        .collection('user_tutors')
        .where('tutorUid', isEqualTo: uid)
        .snapshots()
        .map(_userTutorsFromSnapshot);
  }

  List<UserTutor> _userTutorsFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs
        .map((doc) =>
            UserTutor.fromJson(doc.id, doc.data() as Map<String, Object>))
        .toList();
  }

  Stream<List<OverviewCourse>> get userOverview {
    return _db
        .collection('user_overview')
        .doc(uid)
        .snapshots()
        .map(_userOverviewFromSnapshot);
  }

  List<OverviewCourse> _userOverviewFromSnapshot(DocumentSnapshot snapshot) {
    return ((snapshot.data() as Map<String, Object>)['courses']
            as Map<String, Object>)
        .entries
        .map((MapEntry<String, Object> e) {
      final Map<String, Object> data = e.value as Map<String, Object>;
      return OverviewCourse(
          uid: e.key,
          name: data['courseName'] as String,
          average: (data['average'] as num).toDouble());
    }).toList();
  }

  Stream<List<UserExam>> get userExams {
    return _db
        .collection('exams')
        .where('userUid', isEqualTo: uid)
        .snapshots()
        .map(_userExamsFromSnapshot);
  }

  List<UserExam> _userExamsFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs
        .map((doc) =>
            UserExam.fromJson(doc.id, doc.data() as Map<String, Object>))
        .toList();
  }

  Stream<HomeData> get homeData {
    return _db
        .collection('home')
        .doc(uid)
        .snapshots()
        .map(_homeDataFromSnapshot);
  }

  HomeData _homeDataFromSnapshot(DocumentSnapshot snapshot) {
    return HomeData.fromJson(snapshot.data() as Map<String, Object>);
  }

  Stream<HomeTutorData> get homeTutorData {
    return _db
        .collection('home')
        .doc(uid)
        .snapshots()
        .map(_homeTutorDataFromSnapshot);
  }

  HomeTutorData _homeTutorDataFromSnapshot(DocumentSnapshot snapshot) {
    return HomeTutorData.fromJson(snapshot.data() as Map<String, Object>);
  }
}
