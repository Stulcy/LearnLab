// 🐦 Flutter imports:
import 'package:flutter/foundation.dart';

// 📦 Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';

enum UserType { user, tutor, admin }

class UserData {
  final String uid;
  final String email;
  final DateTime lastActivity;
  final String firstName;
  final String lastName;
  final String description;
  final int year;
  final UserType type;
  final String image;

  UserData({
    @required this.uid,
    this.email,
    this.lastActivity,
    @required this.firstName,
    @required this.lastName,
    this.description = '',
    this.year,
    @required this.type,
    this.image,
  });

  UserData.fromJson(String uid, Map<String, Object> json)
      : this(
          uid: uid,
          email: json['email'] as String,
          lastActivity: (json['lastActivity'] as Timestamp)?.toDate(),
          firstName: json['firstName'] as String,
          lastName: json['lastName'] as String,
          description: json['description'] as String,
          year: json['year'] as int,
          type: ((json['tutor'] ?? false) as bool)
              ? UserType.tutor
              : (((json['admin'] ?? false) as bool)
                  ? UserType.admin
                  : UserType.user),
          image: json['image'] as String,
        );

  Map<String, Object> toJson() {
    return {
      'uid': uid,
      if (email != null) 'email': email,
      if (lastActivity != null)
        'lastActivity': Timestamp.fromDate(lastActivity),
      'firstName': firstName,
      'lastName': lastName,
      if (type == UserType.user) 'year': year,
      if (type == UserType.tutor) 'description': description,
      if (type == UserType.tutor) 'tutor': true,
    };
  }

  @override
  String toString() {
    return '''
    <uid: $uid, email: $email, lastActivity: $lastActivity,
    firstName: $firstName, lastName: $lastName, year: $year,
    description: $description, type: $type''';
  }
}
