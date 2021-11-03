import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class Team extends Equatable {
  const Team({required this.id, required this.name, required this.score, required this.advisories});
  final String id;
  final String name;
  final int score;
  final List<dynamic> advisories;

  @override
  List<Object> get props => [id, name, score, advisories];

  @override
  bool get stringify => true;

  factory Team.fromMap(Map<String, dynamic>? data, String documentId) {
    if (data == null) {
      throw StateError('missing data for jobId: $documentId');
    }
    final name = data['name'] as String?;
    final score = data['score'] as int?;
    final advisories = data['advisories'] as List<dynamic>?;

    return Team(
      id: documentId,
      name: name ?? '',
      score: score ?? 0,
      advisories: advisories ?? [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'score': score,
      'advisories': advisories,
    };
  }
}