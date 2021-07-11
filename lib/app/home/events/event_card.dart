import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get_up_park/app/home/events/event_model.dart';
import 'package:get_up_park/routing/app_router.dart';
import 'package:intl/intl.dart';

class EventCard extends StatelessWidget {
  const EventCard({required this.event});

  final Event event;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 235,
      height: 150,
      margin: const EdgeInsets.fromLTRB(15, 15, 0, 15),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${DateFormat.MMMEd().format(DateTime.parse(event.date)).toUpperCase()} AT ${DateFormat.jm().format(DateTime.parse(event.date))}',
            style: const TextStyle(
              color: Colors.red,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 5),
          AutoSizeText(
            event.title,
            maxLines: 1,
            minFontSize: 16,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              Icon(
                Icons.location_pin,
                color: Colors.grey[800],
                size: 15,
              ),
              const SizedBox(width: 5),
              Text(
                event.location,
                style: TextStyle(
                  color: Colors.grey[800],
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          InkWell(
            onTap: () {
              Navigator.of(context, rootNavigator: true).pushNamed(
                  AppRoutes.eventView,
                  arguments: {
                    'event': event,
                  }
              );
            },
            child: Container(
              width: 205,
              height: 30,
              child: const Center(
                child: Text(
                  'Learn more',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ),
              decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
        ],
      ),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.35),
              spreadRadius: 0,
              blurRadius: 12,
              offset: const Offset(0, 1),
            )
          ]
      ),
    );
  }
}
