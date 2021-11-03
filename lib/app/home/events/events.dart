import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_up_park/app/announcements/empty_content.dart';
import 'package:get_up_park/app/home/events/calendar_view.dart';
import 'package:get_up_park/app/home/events/event_model.dart';
import 'package:get_up_park/app/home/settings/user_tile.dart';

import 'package:get_up_park/app/top_level_providers.dart';
import 'package:get_up_park/app/user_model.dart';
import 'package:get_up_park/constants/strings.dart';
import 'package:get_up_park/routing/app_router.dart';
import 'package:get_up_park/services/firestore_database.dart';
import 'package:get_up_park/shared_widgets/loading.dart';
import 'package:google_fonts/google_fonts.dart';

// watch database
class Events extends ConsumerWidget {

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final userAsyncValue = watch(userStreamProvider);
    return userAsyncValue.when(
      data: (user) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            brightness: Brightness.light,
            title: Text(
              Strings.events,
              style: GoogleFonts.inter(
                color: Colors.black,
                fontWeight: FontWeight.w700,
                fontSize: 22,
              ),
            ),
            toolbarHeight: 55,
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
            elevation: 0,
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Row(
                  children: [
                        () {
                      if(user.admin == userTypes[0] || user.admin == userTypes[1]) {
                        return InkWell(
                          onTap: () {
                            Navigator.of(context, rootNavigator: true).pushNamed(
                              AppRoutes.createEventView,
                            );
                          },
                          child: CircleAvatar(
                            radius: 19,
                            backgroundColor: const Color(0xffE4E5EA).withOpacity(0.75), //Color(0xffEEEDF0),
                            child: const Icon(
                              Icons.add_circle,
                              color: Colors.black,
                              size: 22,
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
                        radius: 19,
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
          body: _buildContents(context, watch, user, user.groupsFollowing),
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


  Widget _buildContents(BuildContext context, ScopedReader watch, PTUser user, List<dynamic> groupsFollowing) {

    final eventsAsyncValue = watch(followedEventsStreamProvider(groupsFollowing));

    return LoadEventsView(eventsAsyncValue: eventsAsyncValue, user: user, groupsFollowing: groupsFollowing);

  }
}

class LoadEventsView extends StatefulWidget {
  const LoadEventsView({required this.eventsAsyncValue, required this.user, required this.groupsFollowing});

  final AsyncValue<List<Event>> eventsAsyncValue;
  final PTUser user;
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
      if(events.isEmpty || widget.user.groupsFollowing.isEmpty) {
        //fix empty list bugs
        // print('fixing bug(hopefully)');
        // final database = context.read<FirestoreDatabase>(databaseProvider);
        // const event = Event(
        //   id: 'bug fix',
        //   title: '',
        //   description: '',
        //   groupImageURL: '',
        //   location: '',
        //   group: '',
        //   date: '',
        //   gameID: '',
        //   imageURL: '',
        // );
        // await database.setEvent(event);
        // setState(() {});
        // await database.deleteEvent(event);
        // setState(() {});
        // await database.unfollowGroup(database.uid, 'App Development Team');
        // // await Future.delayed(const Duration(milliseconds: 500));
        // setState(() {});
        // await database.followGroup(database.uid, 'App Development Team');
        // setState(() {});
      }
      else {
        if(events.length != allEvents.length || events != allEvents || lastGroupsFollowing.length != widget.groupsFollowing.length) {
          print('rerunning events loop');
          if(events.isNotEmpty) {
            setState(() {
              allEvents.clear();
              filteredEvents.clear();
              lastGroupsFollowing.clear();
            });
          }
          // for(Event event in events) {
          //   if(widget.groupsFollowing.contains(event.group)) {
          //     filteredEvents.add(event);
          //   }
          // }
          setState(() {
            allEvents = events;
            lastGroupsFollowing = widget.groupsFollowing;
          });

          _timer = Timer(const Duration(milliseconds: 150), () {
            setState(() {
              loadingData = false;
            });
            _timer!.cancel();
          });
          // if(loadingData == false) {
          //   _timer!.cancel();
          // }
        }
      }

      //
    });

    if(loadingData) {
      return const LoadingEventsScroll();
    }

    return CalendarView(events:allEvents, user: widget.user);

  }

}
