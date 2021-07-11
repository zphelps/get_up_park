import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:get_up_park/app/home/groups/group_model.dart';

@immutable
class Lunch extends Equatable {
  const Lunch({required this.id, required this.items, required this.date});
  final String id;
  final String date;
  final List<dynamic> items;

  @override
  List<Object> get props => [id, items, date];

  @override
  bool get stringify => true;

  factory Lunch.fromMap(Map<String, dynamic>? data, String documentId) {
    if (data == null) {
      throw StateError('missing data for lunch: $documentId');
    }
    final items = data['items'] as List<dynamic>?;
    if (items == null) {
      throw StateError('missing items for lunch: $documentId');
    }

    final date = data['date'] as String?;
    if (date == null) {
      throw StateError('missing date for lunch: $documentId');
    }
    return Lunch(id: documentId, items: items, date: date);
  }

  Map<String, dynamic> toMap() {
    return {
      'items': items,
      'date': date,
    };
  }
}