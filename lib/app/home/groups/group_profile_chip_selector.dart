import 'package:flutter/material.dart';
import 'package:get_up_park/app/home/groups/group_model.dart';
import 'package:get_up_park/constants/news_categories.dart';
import 'package:get_up_park/routing/app_router.dart';
import 'package:get_up_park/services/firestore_database.dart';

class GroupProfileChipSelector extends StatelessWidget {
  const GroupProfileChipSelector({required this.group, required this.admin});

  final Group group;
  final String admin;

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
                              AppRoutes.createPostView,
                              arguments: {
                                'group': group,
                              }
                            );
                          },
                          child: Chip(
                            backgroundColor: Colors.red[100],
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            labelPadding: const EdgeInsets.only(right: 6),
                            label: const Text(
                              'Post',
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
                // GestureDetector(
                //   onTap: () {
                //     Navigator.of(context, rootNavigator: true).pushNamed(
                //         AppRoutes.groupCategorySelectorView,
                //     );
                //   },
                //   child: Chip(
                //     backgroundColor: Colors.grey[300],
                //     padding: const EdgeInsets.symmetric(horizontal: 6),
                //     labelPadding: const EdgeInsets.symmetric(horizontal: 6),
                //     label: const Text(
                //       'About',
                //       style: TextStyle(
                //         fontWeight: FontWeight.w600,
                //         color: Colors.black,
                //       ),
                //     ),
                //   ),
                // ),
                // const SizedBox(width: 6),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context, rootNavigator: true).pushNamed(
                        AppRoutes.groupNewsView,
                        arguments: {
                          'group': group.name,
                        }
                    );
                  },
                  child: Chip(
                    backgroundColor: Colors.grey[300],
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    labelPadding: const EdgeInsets.symmetric(horizontal: 6),
                    label: const Text(
                      'News',
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
                      AppRoutes.groupEventsView,
                      arguments: {
                        'group': group,
                        'admin': admin,
                      }
                    );
                  },
                  child: Chip(
                    backgroundColor: Colors.grey[300],
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    labelPadding: const EdgeInsets.symmetric(horizontal: 6),

                    label: const Text(
                      'Events',
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
                //       AppRoutes.groupCategorySelectorView,
                //     );
                //   },
                //   child: Chip(
                //     backgroundColor: Colors.grey[300],
                //     padding: const EdgeInsets.symmetric(horizontal: 6),
                //     labelPadding: const EdgeInsets.symmetric(horizontal: 6),
                //
                //     label: const Text(
                //       'Announcements',
                //       style: TextStyle(
                //         fontWeight: FontWeight.w600,
                //         color: Colors.black,
                //       ),
                //     ),
                //   ),
                // ),
                // const SizedBox(width: 6),
                // GestureDetector(
                //   onTap: () {
                //     Navigator.of(context, rootNavigator: true).pushNamed(
                //       AppRoutes.groupCategorySelectorView,
                //     );
                //   },
                //   child: Chip(
                //     backgroundColor: Colors.grey[300],
                //     padding: const EdgeInsets.symmetric(horizontal: 6),
                //     labelPadding: const EdgeInsets.symmetric(horizontal: 6),
                //
                //     label: const Text(
                //       'Scores',
                //       style: TextStyle(
                //         fontWeight: FontWeight.w600,
                //         color: Colors.black,
                //       ),
                //     ),
                //   ),
                // ),
                const SizedBox(width: 15),
              ]
          ),
        )
    );
  }
}
