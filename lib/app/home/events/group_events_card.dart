import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get_up_park/app/home/events/event_list_tile.dart';
import 'package:get_up_park/app/home/events/event_list_widget.dart';
import 'package:get_up_park/app/home/groups/group_model.dart';
import 'package:get_up_park/routing/app_router.dart';

class GroupEventsCard extends StatefulWidget {
  const GroupEventsCard({required this.group, required this.admin});

  final Group group;
  final String admin;

  @override
  _GroupEventsCardState createState() => _GroupEventsCardState();
}

class _GroupEventsCardState extends State<GroupEventsCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(15, 0, 15, 10),
      padding: const EdgeInsets.fromLTRB(0, 5, 0, 10),
      child: InkWell(
        onTap: () {
          Navigator.of(context, rootNavigator: true).pushNamed(
              AppRoutes.groupEventsView,
              arguments: {
                'group': widget.group,
                'admin': widget.admin,
              }
          );
        },
        child: Column(
          children: [
            ListTile(
              horizontalTitleGap: 5,
              minVerticalPadding: 0,
              visualDensity: const VisualDensity(horizontal: 0, vertical: -3),
              title: Text(
                widget.group.name,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                ),
              ),
              trailing: const Text(
                'view all',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
            EventListWidget(group: widget.group.name),
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
