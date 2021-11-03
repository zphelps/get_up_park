import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class Advisor extends Equatable {
  const Advisor({required this.id, required this.name, required this.imageURL});
  final String id;
  final String name;
  final String imageURL;

  @override
  List<Object> get props => [id, name, imageURL];

  @override
  bool get stringify => true;

  factory Advisor.fromMap(Map<String, dynamic>? data, String documentId) {
    if (data == null) {
      throw StateError('missing data for advisor: $documentId');
    }
    final name = data['name'] as String?;
    if (name == null) {
      throw StateError('missing name for advisor: $documentId');
    }

    final imageURL = data['imageURL'] as String?;
    if (imageURL == null) {
      throw StateError('missing imageURL for advisor: $documentId');
    }

    return Advisor(id: documentId, name: name, imageURL: imageURL);
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'imageURL': imageURL,
    };
  }
}