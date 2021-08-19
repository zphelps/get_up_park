import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_up_park/app/home/events/event_card.dart';
import 'package:get_up_park/app/home/events/event_model.dart';
import 'package:get_up_park/shared_widgets/horizontal_list_builder.dart';
import 'package:get_up_park/app/top_level_providers.dart';

// watch database
class EventsHorizontalScrollWidget extends ConsumerWidget {

  EventsHorizontalScrollWidget({this.group = 'none', this.excludedEventID = 'none'});

  final String group;
  final String excludedEventID;

  @override
  Widget build(BuildContext context, ScopedReader watch) {

    return Column(
      children: [
        //const SizedBox(height: 15),
        SizedBox(
          height: 170,
          width: MediaQuery.of(context).size.width,
          child: _buildContents(context, watch)
        ),
      ],
    );
    //print(user.uid);
  }

  Widget _buildContents(BuildContext context, ScopedReader watch) {
    final eventsAsyncValue = watch(eventsStreamProvider);
    return HorizontalListBuilder<Event>(
      data: eventsAsyncValue,
      itemBuilder: (context, event) {
        if(event.group == group && event.id != excludedEventID) {
          return EventCard(event: event);
        }
        return const SizedBox(width: 0);
      }
    );
  }
}