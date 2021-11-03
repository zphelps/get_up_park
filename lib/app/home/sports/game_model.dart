import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class Game extends Equatable {
  const Game({required this.id, required this.sport, required this.opponentName,
    required this.group, required this.date, required this.homeScore, required this.opponentScore,
    required this.opponentLogoURL, required this.gameDone, required this.liveStreamActive, required this.numberOfLiveUsers});
  final String id;
  final String sport;
  final String opponentName;
  final String group;
  final String date;
  final String homeScore;
  final String opponentScore;
  final String opponentLogoURL;
  final String gameDone;
  final String liveStreamActive;
  final int numberOfLiveUsers;

  @override
  List<Object> get props => [id, sport, opponentName, group, date, homeScore, opponentScore, opponentLogoURL, gameDone, liveStreamActive, numberOfLiveUsers];

  @override
  bool get stringify => true;

  factory Game.fromMap(Map<String, dynamic>? data, String documentId) {
    if (data == null) {
      throw StateError('missing data for game: $documentId');
    }

    final sport = data['sport'] as String?;
    if (sport == null) {
      throw StateError('missing sport for game: $documentId');
    }

    final opponentName = data['opponentName'] as String?;
    if (opponentName == null) {
      throw StateError('missing opponentName for game: $documentId');
    }

    final group = data['group'] as String?;
    if (group == null) {
      throw StateError('missing group for game: $documentId');
    }

    final date = data['date'] as String?;
    if (date == null) {
      throw StateError('missing date for game: $documentId');
    }

    final homeScore = data['homeScore'] as String?;
    if (homeScore == null) {
      throw StateError('missing homeScore for game: $documentId');
    }

    final opponentScore = data['opponentScore'] as String?;
    if (opponentScore == null) {
      throw StateError('missing opponentScore for game: $documentId');
    }

    final opponentLogoURL = data['opponentLogoURL'] as String?;
    if (opponentLogoURL == null) {
      throw StateError('missing opponentLogoURL for game: $documentId');
    }

    final gameDone = data['gameDone'] as String?;
    if (gameDone == null) {
      throw StateError('missing gameDone for game: $documentId');
    }

    final liveStreamActive = data['liveStreamActive'] as String?;
    if (liveStreamActive == null) {
      throw StateError('missing liveStreamActive for game: $documentId');
    }

    final numberOfLiveUsers = data['numberOfLiveUsers'] as int?;
    if (numberOfLiveUsers == null) {
      throw StateError('missing numberOfLiveUsers for game: $documentId');
    }

    return Game(id: documentId, sport: sport, opponentName: opponentName, group: group, date: date, homeScore: homeScore, opponentScore: opponentScore, opponentLogoURL: opponentLogoURL, gameDone: gameDone, liveStreamActive: liveStreamActive, numberOfLiveUsers: numberOfLiveUsers);
  }

  Map<String, dynamic> toMap() {
    return {
      'sport': sport,
      'opponentName': opponentName,
      'group': group,
      'date': date,
      'homeScore': homeScore,
      'opponentScore': opponentScore,
      'opponentLogoURL': opponentLogoURL,
      'gameDone': gameDone,
      'liveStreamActive': liveStreamActive,
      'numberOfLiveUsers': numberOfLiveUsers,
    };
  }
}