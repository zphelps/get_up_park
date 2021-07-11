import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:get_up_park/app/home/groups/group_model.dart';

@immutable
class Article extends Equatable {
  const Article({required this.id, required this.title, required this.body, required this.category, required this.group, required this.groupLogoURL, required this.imageURL, required this.date, required this.gameID});
  final String id;
  final String title;
  final String body;
  final String category;
  final String group;
  final String groupLogoURL;
  final String imageURL;
  final String date;
  final String gameID;

  @override
  List<Object> get props => [id, title, body, category, group, groupLogoURL, imageURL, date, gameID];

  @override
  bool get stringify => true;

  factory Article.fromMap(Map<String, dynamic>? data, String documentId) {
    if (data == null) {
      throw StateError('missing data for article: $documentId');
    }
    final title = data['title'] as String?;
    if (title == null) {
      throw StateError('missing title for article: $documentId');
    }

    final body = data['body'] as String?;
    if (body == null) {
      throw StateError('missing body for article: $documentId');
    }

    final category = data['category'] as String?;
    if (category == null) {
      throw StateError('missing category for article: $documentId');
    }

    final group = data['group'] as String?;
    if (group == null) {
      throw StateError('missing group for article: $documentId');
    }

    final groupLogoURL = data['groupLogoURL'] as String?;
    if (groupLogoURL == null) {
      throw StateError('missing groupLogoURL for article: $documentId');
    }

    final imageURL = data['imageURL'] as String?;
    if (imageURL == null) {
      throw StateError('missing imageURL for article: $documentId');
    }

    final date = data['date'] as String?;
    if (date == null) {
      throw StateError('missing date for article: $documentId');
    }

    final gameID = data['gameID'] as String?;
    if (gameID == null) {
      throw StateError('missing gameID for article: $documentId');
    }

    return Article(id: documentId, title: title, body: body, category: category, group: group, groupLogoURL: groupLogoURL, imageURL: imageURL, date: date, gameID: gameID);
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'body': body,
      'category': category,
      'group': group,
      'groupLogoURL': groupLogoURL,
      'imageURL': imageURL,
      'date': date,
      'gameID': gameID,
    };
  }
}