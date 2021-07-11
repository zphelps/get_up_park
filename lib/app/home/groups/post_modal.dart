import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:get_up_park/app/home/groups/group_model.dart';

@immutable
class Post extends Equatable {
  const Post({required this.id, required this.text, required this.group, required this.groupLogoURL, required this.category, required this.date});
  final String id;
  final String text;
  final String group;
  final String groupLogoURL;
  final String category;
  final String date;

  @override
  List<Object> get props => [id, text, group, groupLogoURL, category, date];

  @override
  bool get stringify => true;

  factory Post.fromMap(Map<String, dynamic>? data, String documentId) {
    if (data == null) {
      throw StateError('missing data for post: $documentId');
    }
    final text = data['text'] as String?;
    if (text == null) {
      throw StateError('missing text for post: $documentId');
    }

    final group = data['group'] as String?;
    if (group == null) {
      throw StateError('missing group for post: $documentId');
    }

    final groupLogoURL = data['groupLogoURL'] as String?;
    if (groupLogoURL == null) {
      throw StateError('missing groupLogoURL for post: $documentId');
    }

    final category = data['category'] as String?;
    if (category == null) {
      throw StateError('missing category for post: $documentId');
    }

    final date = data['date'] as String?;
    if (date == null) {
      throw StateError('missing date for post: $documentId');
    }
    return Post(id: documentId, text: text, group: group, groupLogoURL: groupLogoURL, category: category, date: date);
  }

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'group': group,
      'groupLogoURL': groupLogoURL,
      'category': category,
      'date': date,
    };
  }
}