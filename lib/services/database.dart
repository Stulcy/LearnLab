// 📦 Package imports:
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';

// 🌎 Project imports:
import 'package:learnlab/models/course_list_data.dart';
import 'package:learnlab/models/exam.dart';
import 'package:learnlab/models/tutor_list_data.dart';
import 'package:learnlab/models/user_exam.dart';
import 'package:learnlab/models/user.dart';
import 'package:learnlab/models/user_course.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ---------------------------------------------------------------------------
  // --- User   ----------------------------------------------------------------
  // ---------------------------------------------------------------------------

  /* Get user with given uid */
  // Meant for getting currently signed in user's information
  Future<UserData> getUser(String uid, String email,
      {bool updateActivity = false}) async {
    final DocumentReference user = _db.collection('users').doc(uid);
    final DocumentSnapshot userData = await user.get();
    if (userData.exists) {
      // Update lastActivity if <updateActivity> is set
      if (updateActivity) {
        await user.update({'lastActivity': DateTime.now()}).catchError(
            (error) => print('Failed to update lastActivity: $error'));
        final String token = await FirebaseMessaging.instance.getToken();
        if (token != null) {
          await user.update({'token': token});
        }
      }

      // Get the avatar
      final String url = await _getUserAvatar(uid);

      final Map<String, Object> data = userData.data() as Map<String, Object>;
      data['image'] = url;

      // Check if we need to update email
      if (email != data['email']) {
        await changeUserEmail(uid, email);
        data['email'] = email;
      }

      return UserData.fromJson(uid, data);
    } else {
      return null;
    }
  }

  /* Create new user */
  Future<void> createUser(
      User user, String firstName, String lastName, int year) async {
    final UserData newUser = UserData(
        uid: user.uid,
        email: user.email,
        lastActivity: DateTime.now(),
        firstName: firstName,
        lastName: lastName,
        year: year,
        type: UserType.user);
    await _db.collection('users').doc(user.uid).set(newUser.toJson());
    // Add user to user_overview
    await _db.collection('user_overview').doc(user.uid).set({'courses': {}});
    // Add user document in collection home
    await _db.collection('home').doc(user.uid).set({'exams': {}});
  }

  // Update user information with new data
  Future<bool> updateUser(
      String uid, String firstName, String lastName, int year) async {
    try {
      final UserData newUserData = UserData(
        uid: uid,
        firstName: firstName,
        lastName: lastName,
        year: year,
        type: UserType.user,
      );
      await _db.collection('users').doc(uid).update(newUserData.toJson());
      // update user_tutors information
      await _db
          .collection('user_tutors')
          .where('userUid', isEqualTo: uid)
          .get()
          .then((snapshot) {
        for (final doc in snapshot.docs) {
          doc.reference
              .update({'userFirstName': firstName, 'userLastName': lastName});
        }
      });

      // Change user's name in each tutor's home document
      final snapshot = await _db
          .collection('user_tutors')
          .where('userUid', isEqualTo: uid)
          .get();

      for (final doc in snapshot.docs) {
        final String tutorUid = (doc.data())['tutorUid'] as String;
        _db.collection('home').doc(tutorUid).set(
          {
            'userExams': {
              uid: {
                'firstName': firstName,
                'lastName': lastName,
              },
            },
          },
          SetOptions(merge: true),
        );
      }

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<void> deleteUser(String uid) async {
    try {
      await _db.collection('users').doc(uid).delete();
      // remove user exams
      await _db
          .collection('exams')
          .where('userUid', isEqualTo: uid)
          .get()
          .then((snapshot) {
        for (final doc in snapshot.docs) {
          doc.reference.delete();
        }
      });

      // Remove user courses
      await _db
          .collection('user_courses')
          .where('userUid', isEqualTo: uid)
          .get()
          .then((snapshot) {
        for (final doc in snapshot.docs) {
          doc.reference.delete();
        }
      });

      // Remove user overview
      await _db.collection('user_overview').doc(uid).delete();

      // Remove user avatar if present
      try {
        await FirebaseStorage.instance.ref('userFiles/$uid/image.jpg').delete();
      } catch (e) {
        print('no picture in database');
      }

      // Remove user home
      await _db.collection('home').doc(uid).delete();

      // Delete user_tutors and edit tutors' home
      await _db
          .collection('user_tutors')
          .where('userUid', isEqualTo: uid)
          .get()
          .then((snapshot) async {
        for (final doc in snapshot.docs) {
          print(doc.id);
          await removeUserTutor(doc.id);
        }
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> changeUserEmail(String uid, String email) async {
    try {
      await _db
          .collection('users')
          .doc(uid)
          .set({'email': email}, SetOptions(merge: true));
    } catch (e) {
      print(e);
    }
  }

  // ---------------------------------------------------------------------------
  // --- Tutor  ----------------------------------------------------------------
  // ---------------------------------------------------------------------------

  /* Create new tutor */
  Future<void> createTutor(String uid, String email) async {
    await _db
        .collection('users')
        .doc(uid)
        .set({'uid': uid, 'tutor': true, 'email': email}).catchError((error) {
      print(error);
    });
    // Add tutor document to collection home
    await _db.collection('home').doc(uid).set({'userExams': {}});
  }

  /* Update tutor information */
  // fullChange -> change tutor information in all collections
  Future<bool> updateTutor(
      String uid, String firstName, String lastName, String description,
      {bool fullChange = false}) async {
    try {
      final UserData newUserData = UserData(
        uid: uid,
        firstName: firstName,
        lastName: lastName,
        description: description,
        type: UserType.tutor,
      );
      await _db.collection('users').doc(uid).update(newUserData.toJson());
      if (fullChange) {
        // Also update tutor info in data collections
        await _db.collection('data').doc('tutors-data').set({
          'tutors': {
            uid: {
              'uid': uid,
              'firstName': firstName,
              'lastName': lastName,
            },
          }
        }, SetOptions(merge: true));
      }
      // update user_tutors information
      await _db
          .collection('user_tutors')
          .where('tutorUid', isEqualTo: uid)
          .get()
          .then((snapshot) {
        for (final doc in snapshot.docs) {
          doc.reference
              .update({'tutorFirstName': firstName, 'tutorLastName': lastName});
        }
      });
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  /* Return data for tutor list */
  Future<List<String>> getTutorsEmails() async {
    final DocumentSnapshot tutorsList =
        await _db.collection('data').doc('tutors-list').get();
    if (tutorsList.exists) {
      return List.from((tutorsList.data() as Map<String, Object>)['emails']
          as List<dynamic>);
    } else {
      return null;
    }
  }

  Future<void> addTutorEmail(String email) async {
    await _db.collection('data').doc('tutors-list').update({
      'emails': FieldValue.arrayUnion([email])
    });
  }

  Future<void> removeTutor(String email) async {
    // Remove email
    await _db.collection('data').doc('tutors-list').update({
      'emails': FieldValue.arrayRemove([email])
    });
    await removeTutorInformation(email);
  }

  /* Remove tutor from users collection */
  Future<void> removeTutorInformation(String email) async {
    await _db
        .collection('users')
        .where('email', isEqualTo: email)
        .get()
        .then((snapshot) async {
      if (snapshot.docs.isNotEmpty) {
        final String uid = snapshot.docs[0].id;

        await _removeTutorData(uid);
        await _removeTutorCourses(uid);
        await _removeSavedTutor(uid);

        await _db.collection('home').doc(uid).delete();

        try {
          await FirebaseStorage.instance
              .ref('userFiles/$uid/image.jpg')
              .delete();
        } catch (e) {
          print('no picture in database');
        }

        // Delete tutor from user collection
        for (final doc in snapshot.docs) {
          doc.reference.delete();
        }
      }
    }).catchError((error) {
      print(error);
    });
  }

  /* Remove tutor from user_tutors collection */
  Future<void> _removeSavedTutor(String uid) async {
    await _db
        .collection('user_tutors')
        .where('tutorUid', isEqualTo: uid)
        .get()
        .then((snapshot) {
      for (final doc in snapshot.docs) {
        removeUserTutor(doc.id, tutor: true);
      }
    });
  }

  /* Remove tutor from tutors-list doc in data collection */
  Future<void> _removeTutorData(String uid) async {
    await _db.collection('data').doc('tutors-data').update({
      'tutors.$uid': FieldValue.delete(),
    });
  }

  Future<void> _removeTutorCourses(String uid) async {
    await _db
        .collection('tutor_courses')
        .where('userUid', isEqualTo: uid)
        .get()
        .then((snapshot) {
      for (final doc in snapshot.docs) {
        doc.reference.delete();
      }
    });
  }

  /* Get list of all tutors that are shown when student adds a new one */
  Future<List<TutorListData>> getTutorsList() async {
    final DocumentSnapshot tutorsDocSnapshot =
        await _db.collection('data').doc('tutors-data').get();
    final Map<String, Object> tutorsDoc =
        tutorsDocSnapshot.data() as Map<String, Object>;

    // Create an object for each tutors
    final List<TutorListData> result = [];
    final Map<String, Object> tutorsData =
        tutorsDoc['tutors'] as Map<String, Object>;
    for (final Object tutor in tutorsData.values) {
      result.add(TutorListData.fromJson(tutor as Map<String, Object>));
    }
    return result;
  }

  Future<UserData> getTutorData(String uid) async {
    try {
      final DocumentSnapshot doc = await _db.collection('users').doc(uid).get();
      final Map<String, Object> data = doc.data() as Map<String, Object>;
      return UserData.fromJson(uid, data);
    } catch (e) {
      print(e);
      return null;
    }
  }

  // ---------------------------------------------------------------------------
  // --- Admin   ---------------------------------------------------------------
  // ---------------------------------------------------------------------------

  // Update admin information with new data
  Future<bool> updateAdmin(
      String uid, String firstName, String lastName) async {
    try {
      final UserData newUserData = UserData(
        uid: uid,
        firstName: firstName,
        lastName: lastName,
        type: UserType.admin,
      );
      await _db.collection('users').doc(uid).update(newUserData.toJson());
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  // ---------------------------------------------------------------------------
  // --- Image   ---------------------------------------------------------------
  // ---------------------------------------------------------------------------

  Future<String> _getUserAvatar(String uid) async {
    try {
      final String url = await FirebaseStorage.instance
          .ref('userFiles/$uid/image.jpg')
          .getDownloadURL();
      return url;
    } catch (e) {
      print(e);
      return null;
    }
  }

  // On success download URL is returned
  Future<String> uploadUserAvatar(UserData user, File image) async {
    try {
      final String uid = user.uid;
      final Reference reference =
          FirebaseStorage.instance.ref('userFiles/$uid/image.jpg');
      await reference.putFile(image);
      final String url = await reference.getDownloadURL();
      final String userType =
          user.type == UserType.user ? 'userUid' : 'tutorUid';
      final String imageUrlType =
          user.type == UserType.user ? 'userImageUrl' : 'tutorImageUrl';
      await _db
          .collection('user_tutors')
          .where(userType, isEqualTo: uid)
          .get()
          .then((snapshot) {
        for (final doc in snapshot.docs) {
          doc.reference.update({imageUrlType: url});
        }
      });

      return url;
    } catch (e) {
      print(e);
      return null;
    }
  }

  // ---------------------------------------------------------------------------
  // --- Course   --------------------------------------------------------------
  // ---------------------------------------------------------------------------

  Future<List<CourseListData>> getCoursesList() async {
    final DocumentSnapshot coursesDocSnapshot =
        await _db.collection('data').doc('courses-data').get();
    final Map<String, Object> coursesDoc =
        coursesDocSnapshot.data() as Map<String, Object>;

    // Create an object for each corse
    final List<CourseListData> result = [];
    final Map<String, Object> coursesData =
        coursesDoc['data'] as Map<String, Object>;
    for (final Object course in coursesData.values) {
      result.add(CourseListData.fromJson(course as Map<String, Object>));
    }
    return result;
  }

  /* Add new user course to user_courses and map entry to overview */
  Future<void> addCourse(String userUid, CourseListData course,
      {bool sl, bool hl, bool tutor}) async {
    final String coursesCollection = tutor ? 'tutor_courses' : 'user_courses';

    // Add new course to user_courses
    await _db
        .collection(coursesCollection)
        .add(UserCourse(
          userUid: userUid,
          courseUid: course.uid,
          courseName: course.name,
          sl: sl,
          hl: hl,
          grades: const [],
          tutor: tutor,
        ).toJson())
        .catchError((error) {
      print(error);
      print('error adding new user course!');
    });

    final String fullName =
        '${course.name} ${sl && hl ? "SL/HL" : (hl ? "HL" : "SL")}';

    // Average na zacetku 0 in se ne uposteva pri racunanju v overview
    if (!tutor) {
      await _db.collection('user_overview').doc(userUid).set({
        'courses': {
          course.uid: {'courseName': fullName, 'average': 0}
        },
      }, SetOptions(merge: true));
    } else {
      // Add tutor course to data colletion
      await _db.collection('data').doc('tutors-data').set({
        'tutors': {
          userUid: {
            'courses': {
              course.uid: fullName,
            },
          },
        },
      }, SetOptions(merge: true));
    }

    // add course to user-tutors
    final String courses = tutor ? 'tutorCourses' : 'userCourses';
    final String uidType = tutor ? 'tutorUid' : 'userUid';

    await _db
        .collection('user_tutors')
        .where(uidType, isEqualTo: userUid)
        .get()
        .then((snapshot) {
      for (final doc in snapshot.docs) {
        doc.reference.set({
          courses: {course.uid: fullName}
        }, SetOptions(merge: true));
      }
    });
  }

  Future<void> removeUserCourse(UserCourse course, {bool tutor = false}) async {
    final String collection = tutor ? 'tutor_courses' : 'user_courses';
    await _db.collection(collection).doc(course.documentUid).delete();
    // remove courses from user_overview
    if (!tutor) {
      await _db
          .collection('user_overview')
          .doc(course.userUid)
          .update({'courses.${course.courseUid}': FieldValue.delete()});
    } else {
      // Remove tutor course from data collection
      await _db.collection('data').doc('tutors-data').update({
        'tutors.${course.userUid}.courses.${course.courseUid}':
            FieldValue.delete()
      });
    }
    //remove course from user_tutors
    final String courses = tutor ? 'tutorCourses' : 'userCourses';
    final String uidType = tutor ? 'tutorUid' : 'userUid';

    await _db
        .collection('user_tutors')
        .where(uidType, isEqualTo: course.userUid)
        .get()
        .then((snapshot) {
      for (final doc in snapshot.docs) {
        doc.reference.set({
          courses: {course.courseUid: FieldValue.delete()}
        }, SetOptions(merge: true));
      }
    });
  }

  // dodajanje coursou v courses-data
  Future<void> _addCourse(CourseListData _courseData) async {
    await _db.collection('data').doc('courses-data').set({
      'data': {_courseData.uid: _courseData.toJson()}
    }, SetOptions(merge: true));
  }

  // add course v courses (+ category name pa uid )
  Future<void> addCourseFull(
      String courseName, String categoryName, String categoryUid,
      {bool hl}) async {
    await _db.collection('courses').add({
      'categoryName': categoryName,
      'categoryUid': categoryUid,
      'hl': hl,
      'name': courseName
    }).then((value) async {
      // vzameš auto-generated uid pa ga dodaš v courses
      await _db.collection('courses').doc(value.id).update({'uid': value.id});
      // dodaš še v data
      _addCourse(CourseListData(uid: value.id, name: courseName, hl: hl));
    });
  }

  // remove course iz courses
  Future<void> removeCourseFull(CourseListData course) async {
    // remove from 'courses'
    await _db.collection('courses').doc(course.uid).delete();
    // remove from 'data' -> 'courses_data'
    await _db
        .collection('data')
        .doc('courses-data')
        .update({'data.${course.uid}': FieldValue.delete()});
    // Userju zbrisan course ostane
  }

  // ---------------------------------------------------------------------------
  // --- Grades  ---------------------------------------------------------------
  // ---------------------------------------------------------------------------

// Add new map entry to overview
  Future<void> addGrade(UserCourse course, int grade, double average) async {
    final double sum = average * course.grades.length + grade;
    final double newAverage = sum / (course.grades.length + 1);
    await _db
        .collection('user_overview')
        .doc(course.userUid)
        .update({'courses.${course.courseUid}.average': newAverage});
    await _db
        .collection('user_courses')
        .doc(course.documentUid)
        .get()
        .then((snapshot) {
      final List<int> grades = course.grades;
      // Add new grade
      grades.add(grade);

      // Update array in the database
      snapshot.reference.set({'grades': grades}, SetOptions(merge: true));
    });
  }

  // Change selected grade with a different one
  Future<void> editGrade(
      UserCourse course, int newGrade, double average, int index) async {
    final double sum = average * course.grades.length;
    final double newAverage =
        (sum + newGrade - course.grades[index]) / course.grades.length;

    // Change average in the overview
    await _db
        .collection('user_overview')
        .doc(course.userUid)
        .update({'courses.${course.courseUid}.average': newAverage});

    // Change grade in the array of grades
    await _db
        .collection('user_courses')
        .doc(course.documentUid)
        .get()
        .then((snapshot) {
      final List<int> grades = course.grades;
      // Change grade
      grades[index] = newGrade;

      // Update array in the database
      snapshot.reference.set({'grades': grades}, SetOptions(merge: true));
    });
  }

  // Delete selected grade from the database
  Future<void> deleteGrade(UserCourse course, double average, int index) async {
    final double sum = average * course.grades.length;
    final double newAverage = (sum - course.grades[index]) /
        (course.grades.length == 1 ? 1 : course.grades.length - 1);

    // Change average in the overview
    await _db
        .collection('user_overview')
        .doc(course.userUid)
        .update({'courses.${course.courseUid}.average': newAverage});

    // Remove grade in the array of grades
    await _db
        .collection('user_courses')
        .doc(course.documentUid)
        .get()
        .then((snapshot) {
      final List<int> grades = course.grades;
      // Remove grade
      grades.removeAt(index);

      // Update array in the database
      snapshot.reference.set({'grades': grades}, SetOptions(merge: true));
    });
  }

  // ---------------------------------------------------------------------------
  // --- Exams  ----------------------------------------------------------------
  // ---------------------------------------------------------------------------

  Future<void> addExam(UserCourse course, DateTime date) async {
    final newDoc = await _db.collection('exams').add({
      'userUid': course.userUid,
      'courseUid': course.courseUid,
      'courseName': course.courseName,
      'hl': course.hl,
      'date': date
    });

    // Add exam to each user's tutor
    final snapshot = await _db
        .collection('user_tutors')
        .where('userUid', isEqualTo: course.userUid)
        .get();

    for (final doc in snapshot.docs) {
      final String tutorUid = (doc.data())['tutorUid'] as String;

      // Add exam to tutor with uid [tutorUid]
      await _db.collection('home').doc(tutorUid).set(
        {
          'userExams': {
            course.userUid: {
              newDoc.id: {
                'courseName': course.fullName,
                'date': date,
              },
            },
          },
        },
        SetOptions(merge: true),
      );
    }

    // Add exam to home collection
    await _db.collection('home').doc(course.userUid).set(
      {
        'exams': {
          newDoc.id: {
            'courseName': course.fullName,
            'date': date,
          },
        },
      },
      SetOptions(merge: true),
    );
  }

  Future<void> removeExam(UserExam exam) async {
    await _db.collection('exams').doc(exam.documentUid).delete();
    // Remove exam from user's home document
    await _db
        .collection('home')
        .doc(exam.userUid)
        .update({'exams.${exam.documentUid}': FieldValue.delete()});

    // Remove exam from each user's tutor's document
    final snapshot = await _db
        .collection('user_tutors')
        .where('userUid', isEqualTo: exam.userUid)
        .get();

    for (final doc in snapshot.docs) {
      final String tutorUid = (doc.data())['tutorUid'] as String;
      await _db.collection('home').doc(tutorUid).update(
        {'userExams.${exam.userUid}.${exam.documentUid}': FieldValue.delete()},
      );
    }
  }

  // ---------------------------------------------------------------------------
  // --- User tutors   ---------------------------------------------------------
  // ---------------------------------------------------------------------------

  /// Add a new document to colletion user_tutors that represents new tutor with
  /// uid [tutor.uid], first name [tutor.firstName], last name [tutor.lastName]
  /// and courses [tutor.courses] that has been added by user with uid
  /// [user.uid], first name [user.firstName], last name [user.lastName] and
  /// courses [userCourses]. User's avatar URL is [user.image] and tutor's
  /// avatar URL is read from the database.
  Future<void> addUserTutor(UserData user, TutorListData tutor,
      List<UserCourse> userCourses, List<UserExam> userExams) async {
    final String tutorImage = await _getUserAvatar(tutor.uid);
    await _db.collection('user_tutors').add({
      'userUid': user.uid,
      'tutorUid': tutor.uid,
      'userFirstName': user.firstName,
      'userLastName': user.lastName,
      'tutorFirstName': tutor.firstName,
      'tutorLastName': tutor.lastName,
      'userCourses': {for (var e in userCourses) e.courseUid: e.courseName},
      'tutorCourses': tutor.courses,
      if (user.image != null) 'userImageUrl': user.image,
      if (tutorImage != null) 'tutorImageUrl': tutorImage,
    });

    // Add user entry to tutor's userExams in home
    Map<String, Map<String, Map<String, Object>>> newData = {
      'userExams': {
        user.uid: {
          'firstName': user.firstName,
          'lastName': user.lastName,
        },
      },
    };

    // Add existing exams to tutor home data
    for (final UserExam e in userExams) {
      newData['userExams'][user.uid][e.documentUid] = {
        'courseName': e.fullName,
        'date': e.date,
      };
    }

    await _db
        .collection('home')
        .doc(tutor.uid)
        .set(newData, SetOptions(merge: true));
  }

  /// Remove document with uid [documentUid] which represent a user saved tutor
  /// from collection user_tutors.
  Future<void> removeUserTutor(String documentUid, {bool tutor = false}) async {
    final docRef = _db.collection('user_tutors').doc(documentUid);
    if (!tutor) {
      final data = (await docRef.get()).data();
      final userUid = data['userUid'] as String;
      final tutorUid = data['tutorUid'] as String;

      await _db.collection('home').doc(tutorUid).update({
        'userExams.$userUid': FieldValue.delete(),
      });
    }
    await docRef.delete();
  }

  // ---------------------------------------------------------------------------
  // --- Notifications  --------------------------------------------------------
  // ---------------------------------------------------------------------------

  Future<void> removeUserNotification(
      String userUid, String notificationUid) async {
    await _db.collection('home').doc(userUid).update(
      {'notifications.$notificationUid': FieldValue.delete()},
    );
  }
}
