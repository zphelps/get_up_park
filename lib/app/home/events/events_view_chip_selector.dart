import 'package:flutter/material.dart';
import 'package:get_up_park/constants/news_categories.dart';
import 'package:get_up_park/routing/app_router.dart';

class EventsViewChipSelector extends StatelessWidget {
  const EventsViewChipSelector({required this.admin, required this.groupsFollowing});

  final String admin;
  final List<dynamic> groupsFollowing;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 35,
      child: ListView.custom(
        scrollDirection: Axis.horizontal,
        childrenDelegate: SliverChildListDelegate.fixed(
          [
            () {
              if(admin == 'true') {
                return Row(
                  children: [
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context, rootNavigator: true).pushNamed(
                          AppRoutes.createEventView,
                        );
                      },
                      child: Chip(
                        backgroundColor: Colors.red[100],
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        labelPadding: const EdgeInsets.only(right: 6),
                        label: const Text(
                          'Create',
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        avatar: const Icon(
                          Icons.add_circle_outline,
                          color: Colors.red,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                );
              }
              return const SizedBox(width: 4);
            }(),
            const SizedBox(width: 6),
            GestureDetector(
              onTap: () {
                print(groupsFollowing);
                Navigator.of(context, rootNavigator: true).pushNamed(
                    AppRoutes.eventsByDateView,
                    arguments: {
                      'date': DateTime.now().toString(),
                      'groupsFollowing': groupsFollowing,
                      'title': 'Today',
                    }
                );
              },
              child: Chip(
                backgroundColor: Colors.grey[300],
                padding: const EdgeInsets.symmetric(horizontal: 6),
                label: const Text(
                  'Today',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 6),
            GestureDetector(
              onTap: () {
                Navigator.of(context, rootNavigator: true).pushNamed(
                    AppRoutes.eventsByDateView,
                    arguments: {
                      'date': DateTime.now().add(const Duration(days: 1)).toString(),
                      'groupsFollowing': groupsFollowing,
                      'title': 'Tomorrow',
                    }
                );
              },
              child: Chip(
                backgroundColor: Colors.grey[300],
                padding: const EdgeInsets.symmetric(horizontal: 6),
                label: const Text(
                  'Tomorrow',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            // const SizedBox(width: 6),
            // GestureDetector(
            //   onTap: () {
            //     Navigator.of(context, rootNavigator: true).pushNamed(
            //         AppRoutes.categoricalNewsView,
            //         arguments: {
            //           'category': 'Administration',
            //         }
            //     );
            //   },
            //   child: Chip(
            //     backgroundColor: Colors.grey[300],
            //     padding: const EdgeInsets.symmetric(horizontal: 6),
            //     label: const Text(
            //       'Past',
            //       style: TextStyle(
            //         fontWeight: FontWeight.w600,
            //         color: Colors.black,
            //       ),
            //     ),
            //   ),
            // ),
            const SizedBox(width: 6),
            GestureDetector(
              onTap: () {
                Navigator.of(context, rootNavigator: true).pushNamed(
                  AppRoutes.selectGroupsToFollowView,
                );
              },
              child: Chip(
                backgroundColor: Colors.grey[300],
                padding: const EdgeInsets.symmetric(horizontal: 6),
                labelPadding: EdgeInsets.zero,
                avatar: const Icon(
                  Icons.settings,
                  color: Colors.black,
                ),
                label: const Text(''),
              ),
            ),
            const SizedBox(width: 10),
          ]
        ),
      )
    );
  }
}
