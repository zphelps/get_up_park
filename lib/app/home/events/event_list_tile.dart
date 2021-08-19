import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get_up_park/app/home/events/event_model.dart';
import 'package:get_up_park/routing/app_router.dart';
import 'package:intl/intl.dart';

class EventListTile extends StatelessWidget {
  const EventListTile({required this.event});

  final Event event;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      child: InkWell(
        onTap: () {
          Navigator.of(context, rootNavigator: true).pushNamed(
              AppRoutes.eventView,
              arguments: {
                'event': event,
              }
          );
        },
        child: ListTile(
          dense: true,
          minVerticalPadding: 0,
          contentPadding: const EdgeInsets.symmetric(horizontal: 18),
          visualDensity: const VisualDensity(vertical: 1, horizontal: 3),
          horizontalTitleGap: 5,
          leading: Container(
            width: MediaQuery.of(context).size.width*0.235,
            margin: const EdgeInsets.only(right: 5),
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(width: 0.25, color: Colors.grey.shade600),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 7),
                Text(
                  '${DateFormat.E('en_US').format(DateTime.parse(event.date))}, ${DateFormat.MMMd('en_US').format(DateTime.parse(event.date))}',
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 7.5),
                Text(
                  DateFormat.jm('en_US').format(DateTime.parse(event.date)),
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          title: Text(
            event.title,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
          subtitle: Text(
            event.location,
            style: TextStyle(
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
              fontSize: 13,
            ),
          ),
        ),
        // child: Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   children: [
        //     Column(
        //       crossAxisAlignment: CrossAxisAlignment.start,
        //       children: [
        //         Text(
        //           DateFormat.yMMMMd('en_US').format(DateTime.parse(event.date)),
        //           style: TextStyle(
        //             color: Colors.grey[600],
        //             fontWeight: FontWeight.w600,
        //             fontSize: 12,
        //           ),
        //         ),
        //         const SizedBox(height: 3),
        //         Text(
        //           event.title,
        //           style: const TextStyle(
        //             color: Colors.black,
        //             fontWeight: FontWeight.w700,
        //             fontSize: 15,
        //           ),
        //         ),
        //         const SizedBox(height: 3),
        //         Text(
        //           event.location,
        //           style: TextStyle(
        //             color: Colors.grey[600],
        //             fontWeight: FontWeight.w600,
        //             fontSize: 12,
        //           ),
        //         ),
        //       ],
        //     ),
        //     const Icon(
        //       Icons.chevron_right,
        //     )
        //   ],
        // ),
      ),
    );
  }
}
