import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_up_park/app/home/events/event_list_widget.dart';
import 'package:get_up_park/app/home/groups/group_model.dart';
import 'package:get_up_park/app/home/settings/user_tile.dart';
import 'package:get_up_park/app/user_model.dart';
import 'package:get_up_park/routing/app_router.dart';
import 'package:google_fonts/google_fonts.dart';

class GroupEventsView extends StatefulWidget {
  const GroupEventsView({required this.group, required this.user, required this.past});

  final Group group;
  final PTUser user;
  final bool past;

  @override
  _GroupEventsViewState createState() => _GroupEventsViewState();
}

class _GroupEventsViewState extends State<GroupEventsView> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: widget.past ? 1 : 0,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          brightness: Brightness.light,
          iconTheme: const IconThemeData(
            color: Colors.black,
          ),
          toolbarHeight: 50,
          backgroundColor: Colors.white,
          title: Text(
            '${widget.group.name} Events',
            style: const TextStyle(
              color: Colors.black,
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
          bottom: TabBar(
            labelColor: Colors.red,
            labelStyle: GoogleFonts.inter(
              fontWeight: FontWeight.w700,
            ),
            unselectedLabelColor: Colors.grey[800],
            unselectedLabelStyle: GoogleFonts.inter(
              fontWeight: FontWeight.w400,
            ),
            tabs: [
              const Tab(
                text: 'Upcoming',

              ),
              const Tab(
                text: 'Past',
              ),
            ],
          ),
          actions: [
                () {
              if(widget.user.admin == userTypes[0] || (widget.user.admin == userTypes[1] && widget.user.groupsUserCanAccess.contains(widget.group))) {
                return IconButton(
                  padding: const EdgeInsets.only(right: 16),
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pushNamed(
                      AppRoutes.createEventView,
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
        body: TabBarView(
          children: [
            SingleChildScrollView(physics: const AlwaysScrollableScrollPhysics(), child: Column(
              children: [
                const SizedBox(height: 10),
                EventListWidget(group: widget.group.name, user: widget.user),
                const SizedBox(height: 35),
              ],
            )),
            SingleChildScrollView(physics: const AlwaysScrollableScrollPhysics(), child: Column(
              children: [
                const SizedBox(height: 10),
                EventListWidget(group: widget.group.name, past: true, user: widget.user),
                const SizedBox(height: 35),
              ],
            )),
          ],
        ),
        // body: SingleChildScrollView(
        //   physics: const AlwaysScrollableScrollPhysics(),
        //   child: Column(
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     children: [
        //       const Padding(
        //         padding: EdgeInsets.fromLTRB(10, 15, 0, 0),
        //         child: Text(
        //           'Upcoming Events',
        //           style: TextStyle(
        //             fontWeight: FontWeight.w700,
        //             color: Colors.black,
        //             fontSize: 16,
        //           ),
        //         ),
        //       ),
        //       const SizedBox(height: 8),
        //       EventListWidget(group: widget.group.name, admin: widget.admin),
        //       const Divider(height: 0, thickness: 1),
        //       const SizedBox(height: 15),
        //       const Padding(
        //         padding: EdgeInsets.fromLTRB(10, 15, 0, 0),
        //         child: Text(
        //           'Past Events',
        //           style: TextStyle(
        //             fontWeight: FontWeight.w700,
        //             color: Colors.black,
        //             fontSize: 16,
        //           ),
        //         ),
        //       ),
        //       const SizedBox(height: 8),
        //       EventListWidget(group: widget.group.name, past: true, admin: widget.admin),
        //       const Divider(height: 0, thickness: 1),
        //       const SizedBox(height: 10),
        //       // Center(
        //       //   child: ElevatedButton(
        //       //     style: ButtonStyle(
        //       //       elevation: MaterialStateProperty.all(0),
        //       //       backgroundColor: MaterialStateProperty.all(Colors.grey[300]),
        //       //       padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.375)),
        //       //     ),
        //       //     onPressed: () {
        //       //
        //       //     },
        //       //     child: const Text(
        //       //       'See more',
        //       //       style: TextStyle(
        //       //         color: Colors.black,
        //       //         fontSize: 15,
        //       //         fontWeight: FontWeight.w600,
        //       //       ),
        //       //     ),
        //       //   ),
        //       // ),
        //       const SizedBox(height: 75),
        //     ],
        //   ),
        // ),
      ),
    );
  }
}
