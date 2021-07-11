import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_up_park/app/home/events/event_list_widget.dart';
import 'package:get_up_park/app/home/groups/group_model.dart';
import 'package:get_up_park/app/user_model.dart';
import 'package:get_up_park/routing/app_router.dart';

class GroupEventsView extends StatefulWidget {
  const GroupEventsView({required this.group, required this.admin});

  final Group group;
  final String admin;

  @override
  _GroupEventsViewState createState() => _GroupEventsViewState();
}

class _GroupEventsViewState extends State<GroupEventsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        brightness: Brightness.light,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
        title: Text(
          '${widget.group.name} Events',
          style: const TextStyle(
            color: Colors.black,
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
              () {
            if(widget.admin == 'true') {
              return IconButton(
                padding: const EdgeInsets.only(right: 16),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pushNamed(
                    AppRoutes.createGroupEventView,
                    arguments: {
                      'group': widget.group,
                    }
                  );
                },
                icon: const Icon(
                  Icons.add_circle_outline
                ),
              );
            }
            return const SizedBox(width: 0);
          }(),
        ],
        elevation: 1,
      ),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(10, 15, 0, 0),
              child: Text(
                'Upcoming Events',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 8),
            EventListWidget(group: widget.group.name),
            const Divider(height: 0, thickness: 1),
            const SizedBox(height: 15),
            const Padding(
              padding: EdgeInsets.fromLTRB(10, 15, 0, 0),
              child: Text(
                'Past Events',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 8),
            EventListWidget(group: widget.group.name, past: true),
            const Divider(height: 0, thickness: 1),
            const SizedBox(height: 10),
            // Center(
            //   child: ElevatedButton(
            //     style: ButtonStyle(
            //       elevation: MaterialStateProperty.all(0),
            //       backgroundColor: MaterialStateProperty.all(Colors.grey[300]),
            //       padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.375)),
            //     ),
            //     onPressed: () {
            //
            //     },
            //     child: const Text(
            //       'See more',
            //       style: TextStyle(
            //         color: Colors.black,
            //         fontSize: 15,
            //         fontWeight: FontWeight.w600,
            //       ),
            //     ),
            //   ),
            // ),
            const SizedBox(height: 75),
          ],
        ),
      ),
    );
  }
}
