import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_up_park/app/announcements/add_announcement.dart';
import 'package:get_up_park/app/announcements/announcement_model.dart';
import 'package:get_up_park/app/announcements/announcement_tile.dart';
import 'package:get_up_park/app/announcements/empty_content.dart';
import 'package:get_up_park/app/announcements/list_items_builder.dart';
import 'package:get_up_park/app/home/groups/group_model.dart';
import 'package:get_up_park/app/home/events/follow_group_tile.dart';
import 'package:get_up_park/app/home/news/create_article/select_group_tile.dart';
import 'package:get_up_park/app/top_level_providers.dart';
import 'package:get_up_park/app/user_model.dart';
import 'package:get_up_park/constants/strings.dart';
import 'package:get_up_park/shared_widgets/loading.dart';


final groupsStreamProvider = StreamProvider.autoDispose<List<Group>>((ref) {
  final database = ref.watch(databaseProvider);
  return database.groupsStream();
});

final userStreamProvider =
StreamProvider.autoDispose.family<PTUser, String>((ref, userID) {
  print(userID);
  final database = ref.watch(databaseProvider);
  // return database.userStream(userID: userID);
  return database.userStream();

});

// watch database
class FollowGroupsView extends ConsumerWidget {

  bool isFollowing(PTUser user, Group group) {
    if(user.groupsFollowing.contains(group.name)) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final firebaseAuth = context.read(firebaseAuthProvider);
    final user = firebaseAuth.currentUser!;
    final userAsyncValue = watch(userStreamProvider(user.uid));
    return userAsyncValue.when(
      data: (user) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Follow Groups',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w600
              ),
            ),
            backgroundColor: Colors.white,
            elevation: 1,
            iconTheme: const IconThemeData(
              color: Colors.black,
            ),
          ),
          body: _buildContents(context, watch, user),
        );
      },
      loading: () => const Loading(loadingMessage: 'Loading'),
      error: (_, __) => EmptyContent(),
    );
    //print(user.uid);
  }

  Widget _buildContents(BuildContext context, ScopedReader watch, PTUser user) {
    final groupsAsyncValue = watch(groupsStreamProvider);
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: ListItemsBuilder<Group>(
        data: groupsAsyncValue,
        itemBuilder: (context, group) {
          return FollowGroupTile(group: group, userID: user.id, isFollowing: isFollowing(user, group));
        },
      ),
    );
  }
}