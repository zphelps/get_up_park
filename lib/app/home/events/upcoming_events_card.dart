import 'package:flutter/material.dart';
import 'package:get_up_park/app/home/events/event_list_widget.dart';
import 'package:get_up_park/routing/app_router.dart';
import 'package:intl/intl.dart';

class UpcomingEventsCard extends StatelessWidget {
  const UpcomingEventsCard({required this.admin});

  final String admin;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15 ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Today's events",
            style: TextStyle(
              fontSize: 24,
              color: Colors.black,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 10),
          EventListWidget(itemCount: 5, date: DateTime.now().toString(), admin: admin),
        ],
      ),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.175), //0.35
              spreadRadius: 0,
              blurRadius: 30,
              offset: const Offset(0, 4),
            )
          ]
      ),
    );
  }
}
