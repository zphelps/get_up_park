import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class Event extends Equatable {
  const Event({required this.id, required this.title, required this.description, required this.group, required this.date, required this.location, required this.groupImageURL});
  final String id;
  final String title;
  final String description;
  final String group;
  final String date;
  final String location;
  final String groupImageURL;

  @override
  List<Object> get props => [id, title, description, group, date, location, groupImageURL];

  @override
  bool get stringify => true;

  factory Event.fromMap(Map<String, dynamic>? data, String documentId) {
    if (data == null) {
      throw StateError('missing data for article: $documentId');
    }

    final title = data['title'] as String?;
    if (title == null) {
      throw StateError('missing title for event: $documentId');
    }

    final description = data['description'] as String?;
    if (description == null) {
      throw StateError('missing description for event: $documentId');
    }

    final group = data['group'] as String?;
    if (group == null) {
      throw StateError('missing group for event: $documentId');
    }

    final date = data['date'] as String?;
    if (date == null) {
      throw StateError('missing date for group: $documentId');
    }

    final location = data['location'] as String?;
    if (location == null) {
      throw StateError('missing location for group: $documentId');
    }

    final groupImageURL = data['groupImageURL'] as String?;
    if (groupImageURL == null) {
      throw StateError('missing groupImageURL for group: $documentId');
    }

    return Event(id: documentId, title: title, description: description, group: group, date: date, location: location, groupImageURL: groupImageURL);
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'group': group,
      'date': date,
      'location': location,
      'groupImageURL': groupImageURL,
    };
  }
}