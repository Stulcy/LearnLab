import 'package:cloud_firestore/cloud_firestore.dart';

class Notification {
  final String id;
  final String title;
  final String content;
  final String imageUrl;
  final DateTime date;

  const Notification({
    this.id,
    this.title,
    this.content,
    this.imageUrl,
    this.date,
  });

  Notification.fromJson(Map<String, Object> json, String uid)
      : this(
            id: uid,
            title: json['title'] as String,
            content: json['content'] as String,
            imageUrl: json['imageUrl'] as String,
            date: (json['date'] as Timestamp)?.toDate());
}
