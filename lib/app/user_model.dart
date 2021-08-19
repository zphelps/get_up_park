import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class PTUser extends Equatable {
  const PTUser({required this.id, required this.admin, required this.firstName, required this.lastName, required this.advisor, required this.groupsFollowing, required this.email, required this.datesTriviaCompleted, required this.groupsUserCanAccess});
  final String id;
  final String admin;
  final String firstName;
  final String lastName;
  final String advisor;
  final String email;
  final List<dynamic> groupsFollowing;
  final List<dynamic> datesTriviaCompleted;
  final List<dynamic> groupsUserCanAccess;

  @override
  List<Object> get props => [id, admin, firstName, lastName, advisor, groupsFollowing, email, datesTriviaCompleted, groupsUserCanAccess];

  @override
  bool get stringify => true;

  factory PTUser.fromMap(Map<String, dynamic>? data, String documentId) {
    if (data == null) {
      throw StateError('missing data for jobId: $documentId');
    }
    final admin = data['admin'] as String?;
    // if (admin == null) {
    //   throw StateError('missing admin for PTUser: $documentId');
    // }
    //
    final firstName = data['firstName'] as String?;
    // if (firstName == null) {
    //   throw StateError('missing firstName for PTUser: $documentId');
    // }
    //
    final lastName = data['lastName'] as String?;
    // if (lastName == null) {
    //   throw StateError('missing lastName for PTUser: $documentId');
    // }
    //
    final advisor = data['advisor'] as String?;
    // if (advisor == null) {
    //   throw StateError('missing advisor for PTUser: $documentId');
    // }
    //
    final groupsFollowing = data['groupsFollowing'] as List<dynamic>?;
    // if (groupsFollowing == null) {
    //   throw StateError('missing groupsFollowing for PTUser: $documentId');
    // }
    //
    final email = data['email'] as String?;
    // if (email == null) {
    //   throw StateError('missing email for PTUser: $documentId');
    // }
    //
    final datesTriviaCompleted = data['datesTriviaCompleted'] as List<dynamic>?;
    // if (datesTriviaCompleted == null) {
    //   throw StateError('missing datesTriviaCompleted for PTUser: $documentId');
    // }
    //
    final groupsUserCanAccess = data['groupsUserCanAccess'] as List<dynamic>?;
    // if (groupsUserCanAccess == null) {
    //   throw StateError('missing groupsUserCanAccess for PTUser: $documentId');
    // }


    return PTUser(
        id: documentId,
        admin: admin ?? '',
        firstName: firstName ?? '',
        lastName: lastName ?? '',
        advisor: advisor ?? '',
        groupsFollowing: groupsFollowing ?? [],
        email: email ?? '',
        datesTriviaCompleted: datesTriviaCompleted ?? [],
        groupsUserCanAccess: groupsUserCanAccess ?? [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'admin': admin,
      'firstName': firstName,
      'lastName': lastName,
      'advisor': advisor,
      'groupsFollowing': groupsFollowing,
      'email': email,
      'datesTriviaCompleted': datesTriviaCompleted,
      'groupsUserCanAccess': groupsUserCanAccess,
    };
  }
}