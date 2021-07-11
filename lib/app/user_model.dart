import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class PTUser extends Equatable {
  const PTUser({required this.id, required this.admin, required this.firstName, required this.lastName, required this.groupsFollowing, required this.email});
  final String id;
  final String admin;
  final String firstName;
  final String lastName;
  final String email;
  final List<dynamic> groupsFollowing;

  @override
  List<Object> get props => [id, admin, firstName, lastName, groupsFollowing, email];

  @override
  bool get stringify => true;

  factory PTUser.fromMap(Map<String, dynamic>? data, String documentId) {
    if (data == null) {
      throw StateError('missing data for jobId: $documentId');
    }
    final admin = data['admin'] as String?;
    if (admin == null) {
      throw StateError('missing admin for PTUser: $documentId');
    }

    final firstName = data['firstName'] as String?;
    if (firstName == null) {
      throw StateError('missing firstName for PTUser: $documentId');
    }

    final lastName = data['lastName'] as String?;
    if (lastName == null) {
      throw StateError('missing lastName for PTUser: $documentId');
    }

    final groupsFollowing = data['groupsFollowing'] as List<dynamic>?;
    if (groupsFollowing == null) {
      throw StateError('missing groupsFollowing for PTUser: $documentId');
    }

    final email = data['email'] as String?;
    if (email == null) {
      throw StateError('missing email for PTUser: $documentId');
    }

    return PTUser(id: documentId, admin: admin, firstName: firstName, lastName: lastName, groupsFollowing: groupsFollowing, email: email);
  }

  Map<String, dynamic> toMap() {
    return {
      'admin': admin,
      'firstName': firstName,
      'lastName': lastName,
      'groupsFollowing': groupsFollowing,
      'email': email,
    };
  }
}