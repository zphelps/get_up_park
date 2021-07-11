import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_up_park/app/announcements/empty_content.dart';
import 'package:get_up_park/app/home/events/event_model.dart';
import 'package:get_up_park/app/home/events/group_events_card.dart';
import 'package:get_up_park/app/home/groups/group_model.dart';
import 'package:get_up_park/shared_widgets/loading.dart';
import 'package:get_up_park/shared_widgets/vertical_list_builder.dart';
import 'package:get_up_park/app/top_level_providers.dart';

final groupsStreamProvider = StreamProvider.autoDispose.family<List<Group>, List<dynamic>>((ref, groupsFollowing) {
  final database = ref.watch(databaseProvider);
  return database.groupsStream();
});

// watch database
class EventsVerticalScrollWidget extends ConsumerWidget {

  const EventsVerticalScrollWidget({this.groupsFollowing = const []});

  final List<dynamic> groupsFollowing;

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    return Container(
      //height: 500,
      child: _buildContents(context, watch)
    );
    //print(user.uid);
  }

  Widget _buildContents(BuildContext context, ScopedReader watch) {
    final groupAsyncValue = watch(groupsStreamProvider(groupsFollowing));
    return groupAsyncValue.when(
      data: (items) {
        final filteredGroups = items.where((group) => groupsFollowing.contains(group.name)).toList();
        return filteredGroups.isEmpty ? const LoadingEventsScroll() : ListView.builder(
          padding: EdgeInsets.zero,
          scrollDirection: Axis.vertical,
          itemCount: filteredGroups.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          //separatorBuilder: (context, index) => const Divider(height: 0.5),
          itemBuilder: (BuildContext context, int index) {
            // if (index == 0 || index == items.length + 1) {
            //   return Container(); // zero height: not visible
            // }
            // return GroupEventsCard(group: filteredGroups[index]);
            return const SizedBox(height: 0);
          },
        );
      },
      loading: () {
        return const LoadingEventsScroll();
      },
      error: (_, __) {
        return Center(
          heightFactor: 5,
          child: EmptyContent(
            title: 'Something went wrong',
            // message: 'Can\'t load items right now',
            message: context.toString(),
          ),
        );
      },
    );
    // print(groupAsyncValue.data);
    // return VerticalListBuilder<Group>(
    //     data: groupAsyncValue,
    //     itemBuilder: (context, group) {
    //       print(group);
    //       if(groupsFollowing.contains(group.name)) {
    //         return GroupEventsCard(group: group);
    //       }
    //       return const SizedBox(width: 0);
    //     }
    // );

  }
}