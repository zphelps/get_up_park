import 'package:flutter/material.dart';
import 'package:get_up_park/app/home/events/event_list_widget.dart';
import 'package:get_up_park/routing/app_router.dart';
import 'package:intl/intl.dart';

class UpcomingEventsWidget extends StatelessWidget {
  const UpcomingEventsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15 ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Text(
          //   DateFormat.MMMMEEEEd().format(DateTime.now()).toUpperCase(),
          //   style: TextStyle(
          //     color: Colors.grey[600],
          //     fontWeight: FontWeight.w700,
          //     fontSize: 14,
          //   ),
          // ),
          // const SizedBox(height: 5),
          const Text(
            "Today's events",
            style: TextStyle(
              fontSize: 24,
              color: Colors.black,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 10),
          EventListWidget(itemCount: 5),
          // const SizedBox(height: 10),
          // Center(
          //   child: ElevatedButton(
          //     style: ButtonStyle(
          //       elevation: MaterialStateProperty.all(0),
          //       backgroundColor: MaterialStateProperty.all(Colors.grey[300]!.withOpacity(0.8)),
          //       padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.375)),
          //     ),
          //     onPressed: () {
          //       Navigator.of(context, rootNavigator: true).pushNamed(
          //           AppRoutes.allUpcomingEventsView,
          //
          //       );
          //     },
          //     child: const Text(
          //       'See more',
          //       style: TextStyle(
          //         color: Colors.black,
          //         fontSize: 15,
          //         fontWeight: FontWeight.w700,
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.35),
              spreadRadius: 0,
              blurRadius: 18,
              offset: const Offset(0, 2),
            )
          ]
      ),
    );
  }
}
