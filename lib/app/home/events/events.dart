import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_up_park/app/announcements/empty_content.dart';
import 'package:get_up_park/app/home/events/calendar_view.dart';
import 'package:get_up_park/app/home/events/event_model.dart';

import 'package:get_up_park/app/top_level_providers.dart';
import 'package:get_up_park/app/user_model.dart';
import 'package:get_up_park/constants/strings.dart';
import 'package:get_up_park/routing/app_router.dart';
import 'package:get_up_park/shared_widgets/loading.dart';

final userStreamProvider =
StreamProvider.autoDispose<PTUser>((ref) {
  final database = ref.watch(databaseProvider);
  return database.userStream();
});

final eventsStreamProvider = StreamProvider.autoDispose<List<Event>>((ref) {
  final database = ref.watch(databaseProvider);
  return database.eventsStream();
});

// watch database
class Events extends ConsumerWidget {

  // final userStreamProvider =
  // StreamProvider.autoDispose<PTUser>((ref) {
  //   final database = ref.watch(databaseProvider);
  //   return database.userStream();
  // });

  // final eventsStreamProvider = StreamProvider.autoDispose<List<Event>>((ref) {
  //   final database = ref.watch(databaseProvider);
  //   return database.eventsStream();
  // });

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final userAsyncValue = watch(userStreamProvider);
    return userAsyncValue.when(
      data: (user) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            brightness: Brightness.light,
            title: const Text(
              Strings.events,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            toolbarHeight: 65,
            leadingWidth: 60,
            centerTitle: false,
            leading: const Padding(
              padding: EdgeInsets.fromLTRB(16, 0, 0, 0),
              child: Image(
                image: AssetImage('assets/pantherHeadLowRes.png'),
                height: 45,
                width: 45,
              ),
            ),
            backgroundColor: Colors.white,
            elevation: 1,
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: Row(
                  children: [
                        () {
                      if(user.admin == 'Admin' || user.admin == 'Student Admin') {
                        return InkWell(
                          onTap: () {
                            Navigator.of(context, rootNavigator: true).pushNamed(
                              AppRoutes.createEventView,
                            );
                          },
                          child: CircleAvatar(
                            radius: 18,
                            backgroundColor: const Color(0xffE4E5EA).withOpacity(0.75), //Color(0xffEEEDF0),
                            child: const Icon(
                              CupertinoIcons.add_circled_solid,
                              color: Colors.black,
                              size: 20,
                            ),
                          ),
                        );
                      }
                      return const SizedBox(width: 0);
                    }(),
                    const SizedBox(width: 8),
                    InkWell(
                      onTap: () {
                        Navigator.of(context, rootNavigator: true).pushNamed(
                          AppRoutes.settingsView,
                            arguments: {
                              'user': user,
                            }
                        );
                      },
                      child: CircleAvatar(
                        radius: 18,
                        backgroundColor: const Color(0xffE4E5EA).withOpacity(0.75), //Colors.grey[200],
                        child: const Icon(
                          Icons.settings,
                          color: Colors.black,
                          size: 22,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          body: _buildContents(context, watch, user.admin, user.groupsFollowing),
        );
      },
      loading: () {
        return Container(color: Colors.transparent); //const LoadingEventsScroll();
      },
      error: (_, __) {
        return EmptyContent();
      },
    );
  }


  Widget _buildContents(BuildContext context, ScopedReader watch, String admin, List<dynamic> groupsFollowing) {

    final eventsAsyncValue = watch(eventsStreamProvider);

    return LoadEventsView(eventsAsyncValue: eventsAsyncValue, admin: admin, groupsFollowing: groupsFollowing);

    // return eventsAsyncValue.when(
    //   data: (events) {
    //     return CalendarView(events:events);
    //   },
    //   loading: () {
    //
    //     return const LoadingEventsScroll();
    //   },
    //   error: (_,__) {
    //     return Center(
    //       heightFactor: 5,
    //       child: EmptyContent(
    //         title: 'Something went wrong',
    //         // message: 'Can\'t load items right now',
    //         message: context.toString(),
    //       ),
    //     );
    //   },
    // );
    // return SingleChildScrollView(
    //   child: Column(
    //     crossAxisAlignment: CrossAxisAlignment.start,
    //     children: [
    //       const SizedBox(height: 10),
    //       EventsViewChipSelector(admin: admin, groupsFollowing: groupsFollowing),
    //       const Divider(
    //         height: 20,
    //       ),
    //       const Padding(
    //         padding: EdgeInsets.only(left: 15),
    //         child: Text(
    //           'Following',
    //           style: TextStyle(
    //             fontSize: 20,
    //             fontWeight: FontWeight.w800,
    //           ),
    //         ),
    //       ),
    //       const SizedBox(height: 3),
    //       Padding(
    //         padding: const EdgeInsets.only(left: 15),
    //         child: Text(
    //           'To customize your events feed, configure your preferences in event settings.',
    //           style: TextStyle(
    //             fontSize: 14,
    //             fontWeight: FontWeight.w400,
    //             color: Colors.grey[800],
    //           ),
    //         ),
    //       ),
    //       const SizedBox(height: 10),
    //       EventsVerticalScrollWidget(groupsFollowing: groupsFollowing),
    //     ],
    //   ),
    // );
  }
}

class LoadEventsView extends StatefulWidget {
  const LoadEventsView({required this.eventsAsyncValue, required this.admin, required this.groupsFollowing});

  final AsyncValue<List<Event>> eventsAsyncValue;
  final String admin;
  final List<dynamic> groupsFollowing;

  @override
  _LoadEventsViewState createState() => _LoadEventsViewState();
}

class _LoadEventsViewState extends State<LoadEventsView> {

  bool loadingData = true;

  List<Event> allEvents = [];
  List<Event> filteredEvents = [];
  List<dynamic> lastGroupsFollowing = [];

  AsyncValue<List<Event>>? lastAsyncValue;

  Timer? _timer;

  // @override
  // void dispose() {
  //   super.dispose();
  //   _timer!.cancel();
  // }

  @override
  Widget build(BuildContext context) {
    widget.eventsAsyncValue.whenData((events) async {
      if(events.length != allEvents.length || lastGroupsFollowing.length != widget.groupsFollowing.length) {
        // if(widget.groupsFollowing.length > 0) {
        //
        // }

        setState(() {
          allEvents.clear();
          filteredEvents.clear();
          lastGroupsFollowing.clear();
        });
        for(Event event in events) {
          if(widget.groupsFollowing.contains(event.group)) {
            filteredEvents.add(event);
          }
        }
        setState(() {
          allEvents = events;
          lastGroupsFollowing = widget.groupsFollowing;
        });

        _timer = Timer(const Duration(milliseconds: 150), () {
          setState(() {
            loadingData = false;
          });
        });
        // if(loadingData == false) {
        //   _timer!.cancel();
        // }
      }
      //
    });

    if(loadingData) {
      return const LoadingEventsScroll();
    }

    return CalendarView(events:allEvents, admin: widget.admin);

  }

}
