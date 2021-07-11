import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_up_park/app/announcements/list_items_builder.dart';
import 'package:get_up_park/app/home/groups/group_model.dart';
import 'package:get_up_park/app/home/groups/groups.dart';
import 'package:get_up_park/app/home/news/create_article/select_group_tile.dart';
import 'package:get_up_park/app/home/settings/user_tile.dart';
import 'package:get_up_park/app/top_level_providers.dart';
import 'package:get_up_park/app/user_model.dart';


final usersStreamProvider = StreamProvider.autoDispose<List<PTUser>>((ref) {
  final database = ref.watch(databaseProvider);
  return database.usersStream();
});

// watch database
class UserListView extends ConsumerWidget {

  UserListView({required this.currentUser});

  final PTUser currentUser;

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        title: const Text(
          'Select Admins',
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
      body: _buildContents(context, watch),
    );
    //print(user.uid);
  }

  Widget _buildContents(BuildContext context, ScopedReader watch) {
    final usersAsyncValue = watch(usersStreamProvider);
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: ListItemsBuilder<PTUser>(
          data: usersAsyncValue,
          itemBuilder: (context, user) {
            if(currentUser.id != user.id) {
              return UserTile(user: user);
            }
            return const SizedBox(height: 0);
          }
      ),
    );
  }
}