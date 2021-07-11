import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class Group extends Equatable {
  const Group({required this.id, required this.name, required this.category, required this.logoURL, required this.backgroundImageURL, required this.sport});
  final String id;
  final String name;
  final String category;
  final String logoURL;
  final String backgroundImageURL;
  final String sport;

  @override
  List<Object> get props => [id, name, category, logoURL, backgroundImageURL, sport];

  @override
  bool get stringify => true;

  factory Group.fromMap(Map<String, dynamic>? data, String documentId) {
    if (data == null) {
      throw StateError('missing data for article: $documentId');
    }
    final name = data['name'] as String?;
    if (name == null) {
      throw StateError('missing name for group: $documentId');
    }

    final category = data['category'] as String?;
    if (category == null) {
      throw StateError('missing category for group: $documentId');
    }

    final logoURL = data['logoURL'] as String?;
    if (logoURL == null) {
      throw StateError('missing logoURL for group: $documentId');
    }

    final backgroundImageURL = data['backgroundImageURL'] as String?;
    if (backgroundImageURL == null) {
      throw StateError('missing backgroundImageURL for group: $documentId');
    }

    final sport = data['sport'] as String?;
    if (sport == null) {
      throw StateError('missing sport for group: $documentId');
    }

    return Group(id: documentId, name: name, category: category, logoURL: logoURL, backgroundImageURL: backgroundImageURL, sport: sport);
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'category': category,
      'logoURL': logoURL,
      'backgroundImageURL': backgroundImageURL,
      'sport': sport,
    };
  }
}