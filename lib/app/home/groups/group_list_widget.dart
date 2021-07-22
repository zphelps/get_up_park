import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_up_park/app/announcements/empty_content.dart';
import 'package:get_up_park/app/home/groups/group_model.dart';
import 'package:get_up_park/app/home/groups/group_tile.dart';
import 'package:get_up_park/app/home/news/create_article/select_group_tile.dart';
import 'package:get_up_park/app/top_level_providers.dart';
import 'package:get_up_park/shared_widgets/loading.dart';


final groupsStreamProvider = StreamProvider.autoDispose<List<Group>>((ref) {
  final database = ref.watch(databaseProvider);
  return database.groupsStream();
});

// watch database
class GroupListWidget extends ConsumerWidget {

  GroupListWidget({this.category = 'All', this.selectGroup = false});

  final String category;
  final bool selectGroup;

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    return Container(
      child: _buildContents(context, watch),
    );
    //print(user.uid);
  }

  Widget _buildContents(BuildContext context, ScopedReader watch) {
    final groupsAsyncValue = watch(groupsStreamProvider);

    return LoadGroupsView(groupsAsyncValue: groupsAsyncValue, category: category, selectGroup: selectGroup);

  }
}

class LoadGroupsView extends StatefulWidget {
  const LoadGroupsView({required this.groupsAsyncValue, required this.category, required this.selectGroup});

  final AsyncValue<List<Group>> groupsAsyncValue;
  final String category;
  final bool selectGroup;

  @override
  _LoadGroupsViewState createState() => _LoadGroupsViewState();
}

class _LoadGroupsViewState extends State<LoadGroupsView> {

  bool loadingData = true;

  List<Group> allGroups = [];

  @override
  Widget build(BuildContext context) {

    widget.groupsAsyncValue.whenData((groups) async {
      if(allGroups.length != groups.length) {
        allGroups.clear();
        setState(() {
          allGroups = groups;
        });
        // for (Group group in groups) {
        //   print('Adding groups');
        //   allGroups.add(group);
        //   await precacheImage(CachedNetworkImageProvider(group.logoURL), context);
        //   await precacheImage(CachedNetworkImageProvider(group.backgroundImageURL), context);
        // }

        Timer(const Duration(milliseconds: 100), () {
          setState(() {
            loadingData = false;
          });
        });
      }
    });

    if(loadingData) {
      return const LoadingGroupsScroll();
    }

    return ListView.builder(
      itemCount: allGroups.length,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) {
        if(widget.category == 'All') {
          if(widget.selectGroup) {
            return SelectGroupTile(group: allGroups[index]);
          }
          return GroupTile(group: allGroups[index]);
        }
        else if(widget.category == allGroups[index].category) {
          if(widget.selectGroup) {
            return SelectGroupTile(group: allGroups[index]);
          }
          return GroupTile(group: allGroups[index]);
        }
        return const SizedBox(height: 0);
      }
    );
  }
}
