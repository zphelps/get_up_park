import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get_up_park/app/home/groups/group_model.dart';
import 'package:get_up_park/app/home/sports/widgets/game_results_list_widget.dart';
import 'package:get_up_park/routing/app_router.dart';

class RecentScoresCard extends StatelessWidget {
  const RecentScoresCard({required this.group, required this.admin});

  final Group group;
  final String admin;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
      padding: const EdgeInsets.fromLTRB(0, 5, 0, 10),
      child: InkWell(
        onTap: () {
          Navigator.of(context, rootNavigator: true).pushNamed(
              AppRoutes.allGameResultsView,
              arguments: {
                'group':  group,
                'admin': admin,
              }
          );
        },
        child: Column(
          children: [
            const ListTile(
              horizontalTitleGap: 5,
              minVerticalPadding: 0,
              visualDensity: VisualDensity(horizontal: 0, vertical: -3),
              title: Text(
                'Recent Scores',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                ),
              ),
              trailing: Text(
                'view all',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
            GameResultsListWidget(group: group, groupName: group.name, admin: admin),
            // EventListWidget(group: widget.group.name),
          ],
        ),
      ),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 0,
              blurRadius: 18,
              offset: const Offset(0, 4),
            )
          ]
      ),
    );
  }
}
