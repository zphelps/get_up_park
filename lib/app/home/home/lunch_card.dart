import 'package:flutter/material.dart';
import 'package:get_up_park/app/home/events/event_list_widget.dart';
import 'package:get_up_park/app/home/home/lunch_list_widget.dart';
import 'package:get_up_park/app/user_model.dart';
import 'package:get_up_park/routing/app_router.dart';
import 'package:intl/intl.dart';

class LunchPreviewCard extends StatelessWidget {
  const LunchPreviewCard({required this.date, required this.user});

  final String date;
  final PTUser user;

  String getGreeting() {
    if(DateTime.now().hour > 0 && DateTime.now().hour < 13) {
      return 'Good morning,';
    }
    else if(DateTime.now().hour > 12 && DateTime.now().hour < 17) {
      return 'Good afternoon,';
    }
    else {
      return 'Good evening,';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 10),
      child: InkWell(
        // onTap: () {
        //   Navigator.of(context, rootNavigator: true).pushNamed(
        //       AppRoutes.groupEventsView,
        //   );
        // },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 15,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                    colors: [Colors.red, Colors.orange]
                ),
                borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                getGreeting(),
                style: TextStyle(
                  color: Colors.grey[800],
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 2),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                '${user.firstName}!',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                "Today is ${DateFormat.MMMMEEEEd().format(DateTime.now())}, and it's a red week! For lunch today, we have:",
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: Colors.black
                ),
              ),
            ),
            const SizedBox(height: 10),
            // const SizedBox(height: 5),
            LunchListWidget(date: DateTime.now().toString(), itemCount: 5,),
            const SizedBox(height: 4),
            const Divider(height: 0, thickness: 0.35),
            const SizedBox(height: 4),
            ListTile(
              onTap: () {
                Navigator.of(context, rootNavigator: true).pushNamed(
                    AppRoutes.fullLunchView,
                );
              },
              dense: true,
              horizontalTitleGap: 5,
              minVerticalPadding: 0,
              contentPadding: const EdgeInsets.symmetric(horizontal: 15),
              visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
              title: const Text(
                "View more lunch items",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              trailing: Icon(
                Icons.chevron_right,
                color: Colors.grey[800],
                size: 20,
              ),
              // trailing: Text(
              //   'view all',
              //   style: TextStyle(
              //     color: Colors.black,
              //     fontWeight: FontWeight.w600,
              //     fontSize: 13,
              //   ),
              // ),
            ),
            const SizedBox(height: 8),
          ],
        ),
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
