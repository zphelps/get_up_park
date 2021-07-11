import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_up_park/app/home/groups/group_post_tile.dart';
import 'package:get_up_park/app/home/groups/post_modal.dart';
import 'package:get_up_park/app/home/news/article_model.dart';
import 'package:get_up_park/app/home/news/old_files/large_news_card.dart';
import 'package:get_up_park/shared_widgets/vertical_list_builder.dart';
import 'package:get_up_park/app/top_level_providers.dart';

final postsStreamProvider = StreamProvider.autoDispose<List<Post>>((ref) {
  final database = ref.watch(databaseProvider);
  return database.postsStream();
});

// watch database
class GroupPostsWidget extends ConsumerWidget {

  GroupPostsWidget({this.groupsFollowing = const [], this.group = 'all', this.onlyFollowing = false});

  final List<dynamic> groupsFollowing;
  final String group;
  final bool onlyFollowing;

  @override
  Widget build(BuildContext context, ScopedReader watch) {

    return Container(
      //height: 500,
      padding: const EdgeInsets.only(bottom: 85),
      child: _buildContents(context, watch)
    );
    //print(user.uid);
  }

  Widget _buildContents(BuildContext context, ScopedReader watch) {
    final postsAsyncValue = watch(postsStreamProvider);
    return VerticalListBuilder<Post>(
        data: postsAsyncValue,
        itemBuilder: (context, post) {
          if(onlyFollowing) {
            if(groupsFollowing.contains(post.group)) {
              return GroupPostTile(post: post);
            }
          }
          else if(post.group == group) {
            return GroupPostTile(post: post);
          }
          else if(group == 'all') {
            return GroupPostTile(post: post);
          }
          return const SizedBox(height: 0);
        }
    );
  }
}