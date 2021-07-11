import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_up_park/app/home/events/event_model.dart';
import 'package:get_up_park/routing/app_router.dart';
import 'package:intl/intl.dart';

class UpcomingEventTile extends StatelessWidget {
  const UpcomingEventTile({required this.event});

  final Event event;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        HapticFeedback.lightImpact();
        Navigator.of(context, rootNavigator: true).pushNamed(
            AppRoutes.eventView,
            arguments: {
              'event': event,
            }
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: CachedNetworkImage(
                memCacheHeight: 1000,
                memCacheWidth: 1000,
                fadeInDuration: Duration.zero,
                placeholderFadeInDuration: Duration.zero,
                fadeOutDuration: Duration.zero,
                imageUrl: event.groupImageURL,
                fit: BoxFit.fitWidth,
                width: 40,
                height: 40,
                placeholder: (context, url) => const Image(image: AssetImage('assets/skeletonImage.gif'), fit: BoxFit.cover),//Lottie.asset('assets/skeleton.json'),//SpinKitCubeGrid(color: Colors.red),
              ),
            ),
            const SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text(
                //   '${DateFormat.E('en_US').format(DateTime.parse(event.date))}, ${DateFormat.MMMd('en_US').format(DateTime.parse(event.date))} at ${DateFormat.jm('en_US').format(DateTime.parse(event.date))}',
                //   style: TextStyle(
                //     color: Colors.grey[600],
                //     fontWeight: FontWeight.w500,
                //     fontSize: 12,
                //   ),
                // ),
                // const SizedBox(height: 1),
                Text(
                  event.title,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  event.group,
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w400,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Icon(
              Icons.chevron_right,
              color: Colors.grey[700],
            ),
          ],
        ),
      )
    );
  }
}
