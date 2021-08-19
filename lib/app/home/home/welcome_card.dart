import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_up_park/app/announcements/announcement_model.dart';
import 'package:get_up_park/app/announcements/empty_content.dart';
import 'package:get_up_park/app/home/events/event_list_widget.dart';
import 'package:get_up_park/app/home/home/lunch_list_widget.dart';
import 'package:get_up_park/app/top_level_providers.dart';
import 'package:get_up_park/app/user_model.dart';
import 'package:get_up_park/routing/app_router.dart';
import 'package:get_up_park/services/firebase_analytics.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';


class WelcomeCard extends ConsumerWidget {
  const WelcomeCard({required this.date, required this.user});

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
  Widget build(BuildContext context, ScopedReader watch) {
    final announcementsAsyncValue = watch(announcementsStreamProvider);
    return announcementsAsyncValue.when(
      data: (announcements) {
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
                const Divider(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context, rootNavigator: true).pushNamed(
                          AppRoutes.fullLunchView,
                        );
                      },
                      child: Row(
                        children: [
                          const Icon(
                            Icons.fastfood,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Lunch Menu',
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 0.15,
                      height: 25,
                      color: Colors.grey,
                    ),
                    InkWell(
                      onTap: () async {
                        if(user.advisor == 'Parent/Other') {
                          Navigator.of(context, rootNavigator: true).pushNamed(
                            AppRoutes.leaderboardView,
                          );
                        }
                        else {
                          bool goToTrivia = true;
                          for(String date in user.datesTriviaCompleted) {
                            if(DateTime.parse(date).isSameDate(DateTime.now())) {
                              goToTrivia = false;
                              Navigator.of(context, rootNavigator: true).pushNamed(
                                AppRoutes.leaderboardView,
                              );
                            }
                          }
                          if(goToTrivia) {
                            await analytics.logEvent(name: 'triviaViewed', parameters: {
                              'userFirstName': user.firstName,
                              'userLastName': user.lastName,
                            });
                            Navigator.of(context, rootNavigator: true).pushNamed(
                              AppRoutes.beginTriviaView,
                            );
                          }
                        }
                      },
                      child: Row(
                        children: [
                          const Icon(
                            Icons.quiz,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Daily Trivia',
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 15),
                //   child: Text(
                //     "Today is ${DateFormat.MMMMEEEEd().format(DateTime.now())}, and it's a red week! For lunch today, we have:",
                //     // announcements.first.body,
                //     style: const TextStyle(
                //         fontSize: 15,
                //         fontWeight: FontWeight.w400,
                //         color: Colors.black
                //     ),
                //   ),
                // ),
                // const SizedBox(height: 10),
                // // const SizedBox(height: 5),
                // // LunchListWidget(date: DateTime.now().toString(), itemCount: 5,),
                // const SizedBox(height: 4),
                // const Divider(height: 0, thickness: 0.35),
                // const SizedBox(height: 4),
                // ListTile(
                //   onTap: () {
                //     Navigator.of(context, rootNavigator: true).pushNamed(
                //       AppRoutes.announcements,
                //     );
                //   },
                //   dense: true,
                //   horizontalTitleGap: 5,
                //   minVerticalPadding: 0,
                //   contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                //   visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
                //   title: const Text(
                //     "View more announcements",
                //     style: TextStyle(
                //       color: Colors.black,
                //       fontWeight: FontWeight.w600,
                //       fontSize: 14,
                //     ),
                //   ),
                //   trailing: Icon(
                //     Icons.chevron_right,
                //     color: Colors.grey[800],
                //     size: 20,
                //   ),
                //   // trailing: Text(
                //   //   'view all',
                //   //   style: TextStyle(
                //   //     color: Colors.black,
                //   //     fontWeight: FontWeight.w600,
                //   //     fontSize: 13,
                //   //   ),
                //   // ),
                // ),
                const SizedBox(height: 12),
              ],
            ),
          ),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1), //0.35
                  spreadRadius: 3,
                  blurRadius: 24,
                  offset: const Offset(0, 4),
                )
                // BoxShadow(
                //   color: Colors.black.withOpacity(0.175), //0.35
                //   spreadRadius: 0,
                //   blurRadius: 30,
                //   offset: const Offset(0, 4),
                // )
              ]
          ),
        );
      },
      loading: () {
        return Container();
      },
      error: (_,__) {
        return EmptyContent(title: 'An error has occurred',);
      }
    );

  }
}

// extension DateOnlyCompare on DateTime {
//   bool isSameDate(DateTime other) {
//     return year == other.year && month == other.month
//         && day == other.day;
//   }
// }