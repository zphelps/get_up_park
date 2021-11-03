import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:get_up_park/app/home/groups/group_model.dart';

@immutable
class Lunch extends Equatable {
  const Lunch({required this.id, required this.items, required this.dates, required this.grillItems, required this.deliItems, required this.grabgoItems, required this.hemisphereItems});
  final String id;
  final List<dynamic> dates;
  final List<dynamic> items;
  final List<dynamic> grillItems;
  final List<dynamic> deliItems;
  final List<dynamic> grabgoItems;
  final List<dynamic> hemisphereItems;

  @override
  List<Object> get props => [id, items, dates, grillItems, deliItems, grabgoItems, hemisphereItems];

  @override
  bool get stringify => true;

  factory Lunch.fromMap(Map<String, dynamic>? data, String documentId) {
    if (data == null) {
      throw StateError('missing data for lunch: $documentId');
    }
    final items = data['items'] ?? [];
    final dates = data['dates'] ?? [];
    final grillItems = data['grillItems'] ?? [];
    final deliItems = data['deliItems']  ?? [];
    final grabgoItems = data['grabgoItems'] ?? [];
    final hemisphereItems = data['hemisphereItems'] ?? [];

    return Lunch(id: documentId, items: items, dates: dates, grillItems: grillItems, deliItems: deliItems, grabgoItems: grabgoItems, hemisphereItems: hemisphereItems);
  }

  Map<String, dynamic> toMap() {
    return {
      'items': items,
      'dates': dates,
      'grillItems': grillItems,
      'deliItems': deliItems,
      'grabgoItems': grabgoItems,
      'hemisphereItems': hemisphereItems,
    };
  }
}