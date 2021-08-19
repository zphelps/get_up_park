import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:get_up_park/app/home/groups/group_model.dart';

@immutable
class CoverScreen extends Equatable {
  const CoverScreen({required this.id, required this.countdownDate, required this.title, required this.message, required this.live, required this.usersExcluded});
  final String id;
  final String countdownDate;
  final String title;
  final String message;
  final bool live;
  final List<dynamic> usersExcluded;

  @override
  List<Object> get props => [id, countdownDate, title, message, live];

  @override
  bool get stringify => true;

  factory CoverScreen.fromMap(Map<String, dynamic>? data, String documentId) {
    if (data == null) {
      throw StateError('missing data for cover screen: $documentId');
    }
    final countdownDate = data['countdownDate'] ?? '';

    final title = data['title'] ?? '';

    final message = data['message'] ?? '';

    final live = data['live'] ?? false;

    final usersExcluded = data['usersExcluded'] ?? [];

    return CoverScreen(id: documentId, countdownDate: countdownDate, title: title, message: message, live: live, usersExcluded: usersExcluded);
  }

  Map<String, dynamic> toMap() {
    return {
      'countdownDate': countdownDate,
      'title': title,
      'message': message,
      'live': live,
      'usersExcluded': usersExcluded,
    };
  }
}