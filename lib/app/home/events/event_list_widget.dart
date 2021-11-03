import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_up_park/app/announcements/empty_content.dart';
import 'package:get_up_park/app/home/events/event_card.dart';
import 'package:get_up_park/app/home/events/event_model.dart';
import 'package:get_up_park/app/home/events/upcoming_event_tile.dart';
import 'package:get_up_park/app/home/house_cup/house_cup_event_tile.dart';
import 'package:get_up_park/app/user_model.dart';
import 'package:get_up_park/app/top_level_providers.dart';


// watch database
class EventListWidget extends ConsumerWidget {

  EventListWidget({this.group = 'all', this.past = false, this.date = '', this.itemCount = 0, required this.user, this.emptyTitle = 'No events found.', this.emptyMessage = 'Please check back later.'});

  final String group;
  final bool past;
  final int itemCount;
  final String date;
  final PTUser user;
  final String emptyTitle;
  final String emptyMessage;

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
            if(group != 'all' && event.group == group && DateTime.parse(event.date).isBefore(DateTime.now()) && event.gameID == '') {
              allEvents.add(event);
            }
            else if(group == 'all' && DateTime.parse(event.date).isBefore(DateTime.now()) && event.gameID == '') {
              allEvents.add(event);
            }
          }
          else {
            if(group != 'all' && event.group == group && DateTime.parse(event.date).isAfter(DateTime.now()) && event.gameID == '') {
              allEvents.add(event);
            }
            else if(group == 'all' && DateTime.parse(event.date).isAfter(DateTime.now()) && event.gameID == '') {
              allEvents.add(event);
            }
          }
        }
      }
    });

    if(allEvents.isEmpty) {
      return EmptyContent(title: emptyTitle, message: emptyMessage, center: true);
    }

    return ListView.separated(
      itemCount: itemCount!=0 && itemCount < allEvents.length ? itemCount : allEvents.length,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      separatorBuilder: (context, index) {
        return group == '' ? const Divider(height: 0, thickness: 0.65,) : const SizedBox(height: 0);
      },
      itemBuilder: (context, index) {
        if(date == '') {
          if(past) {
            if(allEvents[index].group == group && DateTime.parse(allEvents[index].date).isBefore(DateTime.now())) {
              return EventCard(event: allEvents[index]);
            }
          }
          else {
            if(group == 'all') {
              return Column(
                children: [
                  UpcomingEventTile(event: allEvents[index], user: user,),
                ],
              );
            }
            else {
              if(allEvents[index].group == group && DateTime.parse(allEvents[index].date).isAfter(DateTime.now())) {
                return EventCard(event: allEvents[index]);
              }
            }
          }
        }
        else {
          if(group == 'all') {
            return Column(
              children: [
                UpcomingEventTile(event: allEvents[index], user: user),
                // const Divider(height: 0, thickness: 0.65),
              ],
            );
          }
          else if(allEvents[index].group == group && DateTime.parse(date).day == DateTime.parse(allEvents[index].date).day) {
            return EventCard(event: allEvents[index]);
          }
        }
        return const SizedBox(width: 0);
      }
    );
  }
}