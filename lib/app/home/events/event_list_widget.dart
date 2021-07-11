import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_up_park/app/announcements/empty_content.dart';
import 'package:get_up_park/app/home/events/calendar_event_list_tile.dart';
import 'package:get_up_park/app/home/events/event_list_tile.dart';
import 'package:get_up_park/app/home/events/event_model.dart';
import 'package:get_up_park/app/home/events/group_events_card.dart';
import 'package:get_up_park/app/home/events/upcoming_event_tile.dart';
import 'package:get_up_park/app/home/news/article_model.dart';
import 'package:get_up_park/app/home/news/old_files/large_news_card.dart';
import 'package:get_up_park/shared_widgets/vertical_list_builder.dart';
import 'package:get_up_park/app/top_level_providers.dart';


final eventsStreamProvider = StreamProvider.autoDispose<List<Event>>((ref) {
  final database = ref.watch(databaseProvider);
  return database.eventsStream();
});

// watch database
class EventListWidget extends ConsumerWidget {

  EventListWidget({this.group = 'all', this.past = false, this.date = '', this.itemCount = 0});

  final String group;
  final bool past;
  final int itemCount;
  final String date;

  @override
  Widget build(BuildContext context, ScopedReader watch) {

    return Container(
      child: _buildContents(context, watch)
    );
  }

  Widget _buildContents(BuildContext context, ScopedReader watch) {
    final eventsAsyncValue = watch(eventsStreamProvider);
    List<Event> allEvents = [];
    eventsAsyncValue.whenData((events) {
      for (Event event in events) {
        if(date != '') {
          DateTime eventDate = DateTime.parse(event.date);
          DateTime today = DateTime.now();
          if(eventDate.month == today.month && eventDate.day == today.day && eventDate.weekday == today.weekday && eventDate.year == today.year) {
            allEvents.add(event);
          }
        }
        else {
          if(past) {
            if(group != 'all' && event.group == group && DateTime.parse(event.date).isBefore(DateTime.now())) {
              allEvents.add(event);
            }
            else if(group == 'all' && DateTime.parse(event.date).isBefore(DateTime.now())) {
              allEvents.add(event);
            }
          }
          else {
            if(group != 'all' && event.group == group && DateTime.parse(event.date).isAfter(DateTime.now())) {
              allEvents.add(event);
            }
            else if(group == 'all' && DateTime.parse(event.date).isAfter(DateTime.now())) {
              allEvents.add(event);
            }
          }
        }
      }
    });

    if(allEvents.isEmpty) {
      return EmptyContent(title: 'No events found', message: 'Please check back later.', center: true);
    }

    return ListView.separated(
      itemCount: itemCount!=0 && itemCount < allEvents.length ? itemCount : allEvents.length,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      separatorBuilder: (context, index) {
        return const Divider(height: 0, thickness: 0.65,);
      },
      itemBuilder: (context, index) {
        if(date == '') {
          if(past) {
            if(allEvents[index].group == group && DateTime.parse(allEvents[index].date).isBefore(DateTime.now())) {
              return Column(
                children: [
                  // const Divider(height: 0, thickness: 0.65),
                  EventListTile(event: allEvents[index]),
                ],
              );
            }
          }
          else {
            if(group == 'all') {
              return Column(
                children: [
                  UpcomingEventTile(event: allEvents[index]),
                  // const Divider(height: 0, thickness: 0.65),
                ],
              );
            }
            else {
              if(allEvents[index].group == group && DateTime.parse(allEvents[index].date).isAfter(DateTime.now())) {
                return Column(
                  children: [
                    // const Divider(height: 0, thickness: 0.65),
                    EventListTile(event: allEvents[index]),
                  ],
                );
              }
            }
          }
        }
        else {
          if(group == 'all') {
            return Column(
              children: [
                UpcomingEventTile(event: allEvents[index]),
                // const Divider(height: 0, thickness: 0.65),
              ],
            );
          }
          else if(allEvents[index].group == group && DateTime.parse(date).day == DateTime.parse(allEvents[index].date).day) {
            return Column(
              children: [
                // const Divider(height: 0, thickness: 0.65),
                EventListTile(event: allEvents[index]),
              ],
            );
          }
        }
        return const SizedBox(width: 0);
      }
    );
  }
}