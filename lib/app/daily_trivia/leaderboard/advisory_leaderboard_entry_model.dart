import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class AdvisoryLeaderboardEntry extends Equatable {
  const AdvisoryLeaderboardEntry({required this.id, required this.score, required this.advisor});
  final String id;
  final int score;
  final String advisor;

  @override
  List<Object> get props => [id, score, advisor];

  @override
  bool get stringify => true;

  factory AdvisoryLeaderboardEntry.fromMap(Map<String, dynamic>? data, String documentId) {
    if (data == null) {
      throw StateError('missing data for leaderboard entry: $documentId');
    }

    final score = data['score'] as int?;
    if (score == null) {
      throw StateError('missing score for leaderboard entry: $documentId');
    }

    final advisor = data['advisor'] as String?;
    if (advisor == null) {
      throw StateError('missing advisor for leaderboard entry: $documentId');
    }

    return AdvisoryLeaderboardEntry(id: documentId, score: score, advisor: advisor);
  }

  Map<String, dynamic> toMap() {
    return {
      'score': score,
      'advisor': advisor,
    };
  }
}