import 'package:flutter/material.dart';

class UserProfileIcon extends StatelessWidget {
  const UserProfileIcon({required this.firstName, required this.lastName, required this.radius});

  final String firstName;
  final String lastName;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          CircleAvatar(
            radius: radius,
            backgroundColor: Colors.grey[600],
            child: Text(
              '${firstName.substring(0, 1)}${lastName.substring(0, 1)}',
              style: const TextStyle(
                fontSize: 60,
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '$firstName $lastName',
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w700,
              fontSize: 24,
            ),
          ),
        ],
      ),
    );
  }
}
