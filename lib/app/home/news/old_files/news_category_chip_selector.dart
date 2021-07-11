import 'package:flutter/material.dart';
import 'package:get_up_park/constants/news_categories.dart';
import 'package:get_up_park/routing/app_router.dart';

class NewsCategoryChipSelector extends StatelessWidget {
  const NewsCategoryChipSelector({required this.admin});

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
                            AppRoutes.createArticleView,
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
                Navigator.of(context, rootNavigator: true).pushNamed(
                    AppRoutes.categoricalNewsView,
                    arguments: {
                      'category': 'Sports',
                    }
                );
              },
              child: Chip(
                backgroundColor: Colors.grey[300],
                padding: const EdgeInsets.symmetric(horizontal: 6),
                label: const Text(
                  'Sports',
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
                    AppRoutes.categoricalNewsView,
                    arguments: {
                      'category': 'Clubs',
                    }
                );
              },
              child: Chip(
                backgroundColor: Colors.grey[300],
                padding: const EdgeInsets.symmetric(horizontal: 6),
                label: const Text(
                  'Clubs',
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
                    AppRoutes.categoricalNewsView,
                    arguments: {
                      'category': 'Administration',
                    }
                );
              },
              child: Chip(
                backgroundColor: Colors.grey[300],
                padding: const EdgeInsets.symmetric(horizontal: 6),
                label: const Text(
                  'Administration',
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
                    AppRoutes.categoricalNewsView,
                    arguments: {
                      'category': 'Student Council',
                    }
                );
              },
              child: Chip(
                backgroundColor: Colors.grey[300],
                padding: const EdgeInsets.symmetric(horizontal: 6),
                label: const Text(
                  'Student Council',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
          ]
        ),
      )
    );
  }
}
