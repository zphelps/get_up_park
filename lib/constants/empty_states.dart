import 'package:flutter/material.dart';

class EventListEmptyState extends StatelessWidget {
  const EventListEmptyState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const Image(
            image: AssetImage('assets/noImageSelected.png'),
            height: 250,
            width: 250,
          ),
          const Text(
            'No events on this date',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
