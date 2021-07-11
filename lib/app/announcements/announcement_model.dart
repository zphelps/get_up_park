import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class Announcement extends Equatable {
  const Announcement({required this.id, required this.title, required this.body, required this.url, required this.date});
  final String id;
  final String title;
  final String body;
  final String url;
  final String date;

  @override
  List<Object> get props => [id, title, body, url, date];

  @override
  bool get stringify => true;

  factory Announcement.fromMap(Map<String, dynamic>? data, String documentId) {
    if (data == null) {
      throw StateError('missing data for jobId: $documentId');
    }
    final title = data['title'] as String?;
    if (title == null) {
      throw StateError('missing title for announcement: $documentId');
    }

    final body = data['body'] as String?;
    if (body == null) {
      throw StateError('missing body for announcement: $documentId');
    }

    final url = data['url'] as String?;
    if (url == null) {
      throw StateError('missing url for announcement: $documentId');
    }

    final date = data['date'] as String?;
    if (date == null) {
      throw StateError('missing date for announcement: $documentId');
    }
    return Announcement(id: documentId, title: title, body: body, url: url, date: date);
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'body': body,
      'url': url,
      'date': date,
    };
  }
}