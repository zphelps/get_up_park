import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_up_park/app/home/events/follow_group_tile.dart';
import 'package:get_up_park/app/home/groups/group_model.dart';
import 'package:get_up_park/app/home/groups/group_post_tile.dart';
import 'package:get_up_park/app/home/groups/group_tile.dart';
import 'package:get_up_park/app/home/groups/large_group_card.dart';
import 'package:get_up_park/app/home/groups/post_modal.dart';
import 'package:get_up_park/app/home/news/article_model.dart';
import 'package:get_up_park/app/home/news/old_files/large_news_card.dart';
import 'package:get_up_park/shared_widgets/horizontal_list_builder.dart';
import 'package:get_up_park/shared_widgets/vertical_list_builder.dart';
import 'package:get_up_park/app/top_level_providers.dart';

final groupsStreamProvider = StreamProvider.autoDispose<List<Group>>((ref) {
  final database = ref.watch(databaseProvider);
  return database.groupsStream();
});

// watch database
class SuggestedGroupsWidget extends ConsumerWidget {

  SuggestedGroupsWidget({required this.groupsFollowing, required this.userID});

  final List<dynamic> groupsFollowing;
  final String userID;

  @override
  Widget build(BuildContext context, ScopedReader watch) {

    return Container(
      //height: 500,
        child: _buildContents(context, watch),
    );
    //print(user.uid);
  }

  Widget _buildContents(BuildContext context, ScopedReader watch) {
    final groupsAsyncValue = watch(groupsStreamProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
          child: Text(
            'Suggested for you',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w800,
              fontSize: 20,
            ),
          ),
        ),
        const SizedBox(height: 3),
        Padding(
          padding: const EdgeInsets.only(left: 15),
          child: Text(
            'To customize your events feed, configure your preferences in event settings.',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.grey[800],
            ),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 215,
          child: HorizontalListBuilder<Group>(
              data: groupsAsyncValue,
              itemCount: 5,
              itemBuilder: (context, group) {
                return LargeGroupCard(group: group);
              }
          ),
        ),
        // Align(
        //   alignment: Alignment.center,
        //   child: Container(
        //     alignment: Alignment.center,
        //     width: MediaQuery.of(context).size.width * 0.925,
        //     padding: const EdgeInsets.symmetric(vertical: 10),
        //     child: const Text(
        //       'view more',
        //       style: TextStyle(
        //         color: Colors.black,
        //         fontWeight: FontWeight.w700,
        //       ),
        //     ),
        //     decoration: BoxDecoration(
        //       color: Colors.grey[200],
        //       borderRadius: BorderRadius.circular(8),
        //     ),
        //   ),
        // ),
      ],
    );
  }
}