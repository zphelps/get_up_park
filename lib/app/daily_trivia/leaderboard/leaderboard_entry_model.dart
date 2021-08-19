import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class LeaderboardEntry extends Equatable {
  const LeaderboardEntry({required this.id, required this.score,
    required this.firstName, required this.lastName, required this.advisor});
  final String id;
  final int score;
  final String firstName;
  final String lastName;
  final String advisor;

  @override
  List<Object> get props => [id, score, firstName, lastName, advisor];

  @override
  bool get stringify => true;

  factory LeaderboardEntry.fromMap(Map<String, dynamic>? data, String documentId) {
    if (data == null) {
      throw StateError('missing data for leaderboard entry: $documentId');
    }

    final score = data['score'] as int?;
    if (score == null) {
      throw StateError('missing score for leaderboard entry: $documentId');
    }

    final firstName = data['firstName'] as String?;
    if (firstName == null) {
      throw StateError('missing firstName for leaderboard entry: $documentId');
    }

    final lastName = data['lastName'] as String?;
    if (lastName == null) {
      throw StateError('missing lastName for leaderboard entry: $documentId');
    }

    final advisor = data['advisor'] as String?;
    if (advisor == null) {
      throw StateError('missing advisor for leaderboard entry: $documentId');
    }

    return LeaderboardEntry(id: documentId, score: score, firstName: firstName, lastName: lastName, advisor: advisor);
  }

  Map<String, dynamic> toMap() {
    return {
      'score': score,
      'firstName': firstName,
      'lastName': lastName,
      'advisor': advisor,
    };
  }
}