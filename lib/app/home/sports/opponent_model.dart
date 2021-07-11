import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class Opponent extends Equatable {
  const Opponent({required this.id, required this.name, required this.logoURL});
  final String id;
  final String name;
  final String logoURL;

  @override
  List<Object> get props => [id, name, logoURL];

  @override
  bool get stringify => true;

  factory Opponent.fromMap(Map<String, dynamic>? data, String documentId) {
    if (data == null) {
      throw StateError('missing data for game: $documentId');
    }

    final name = data['name'] as String?;
    if (name == null) {
      throw StateError('missing name for opponent: $documentId');
    }

    final logoURL = data['logoURL'] as String?;
    if (logoURL == null) {
      throw StateError('missing logoURL for opponent: $documentId');
    }

    return Opponent(id: documentId, name: name, logoURL: logoURL);
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'logoURL': logoURL,
    };
  }
}