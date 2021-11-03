import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_up_park/app/home/groups/follow_group_tile.dart';
import 'package:get_up_park/app/home/groups/group_model.dart';
import 'package:get_up_park/app/home/groups/group_tile.dart';
import 'package:get_up_park/app/home/news/create_article/select_group_tile.dart';
import 'package:get_up_park/app/home/settings/set_user_permissions/select_group_for_permission_tile.dart';
import 'package:get_up_park/app/home/settings/user_tile.dart';
import 'package:get_up_park/app/top_level_providers.dart';
import 'package:get_up_park/app/user_model.dart';
import 'package:get_up_park/shared_widgets/loading.dart';

// watch database
class GroupListWidget extends ConsumerWidget {

  GroupListWidget({this.category = 'All', this.selectGroup = false, this.followGroup = false, this.setAccessToGroup = false, required this.user});

  final String category;
  final bool selectGroup;
  final bool followGroup;
  final bool setAccessToGroup;
  final PTUser user;

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    return Container(
      child: _buildContents(context, watch),
    );
    //print(user.uid);
  }

  Widget _buildContents(BuildContext context, ScopedReader watch) {
    final groupsAsyncValue = watch(groupsStreamProvider);

    return LoadGroupsView(groupsAsyncValue: groupsAsyncValue, category: category, selectGroup: selectGroup, followGroup: followGroup, setAccessToGroup: setAccessToGroup, user: user);

  }
}

class LoadGroupsView extends StatefulWidget {
  const LoadGroupsView({required this.groupsAsyncValue, required this.category, required this.selectGroup, required this.followGroup, required this.setAccessToGroup, required this.user});

  final AsyncValue<List<Group>> groupsAsyncValue;
  final String category;
  final bool selectGroup;
  final bool followGroup;
  final bool setAccessToGroup;
  final PTUser user;

  @override
  _LoadGroupsViewState createState() => _LoadGroupsViewState();
}

class _LoadGroupsViewState extends State<LoadGroupsView> {

  bool loadingData = true;

  List<Group> allGroups = [];
  List<Group> filteredGroups = [];

  @override
  Widget build(BuildContext context) {

    widget.groupsAsyncValue.whenData((groups) async {
      if(allGroups.length != groups.length) {
        allGroups.clear();

        if(widget.selectGroup) {
          for (Group group in groups) {
            // print('filtering groups');
            if(widget.user.groupsUserCanAccess.contains(group.name) || widget.user.admin == userTypes[0]) {
              filteredGroups.add(group);
            }
          }
        }
        setState(() {
          allGroups = groups;
        });


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
      itemCount: widget.selectGroup ? filteredGroups.length : allGroups.length,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) {
        if(allGroups[index].name != 'App Development Team' || widget.selectGroup) {
          if(widget.category == 'All') {
            if(widget.selectGroup) {
              return SelectGroupTile(group: filteredGroups[index]);
            }
            else if(widget.followGroup) {
              return FollowGroupTile(group: allGroups[index], groupsFollowing: widget.user.groupsFollowing);
            }
            else if(widget.setAccessToGroup) {
              return SelectGroupForPermissionTile(group: allGroups[index], user: widget.user);
            }
            return GroupTile(group: allGroups[index], groupsFollowing: widget.user.groupsFollowing);
          }
          else if(widget.selectGroup) {
            if(widget.category == filteredGroups[index].category) {
              return SelectGroupTile(group: filteredGroups[index]);
            }
          }
          else if(widget.category == allGroups[index].category) {
            // if(widget.selectGroup) {
            //   return SelectGroupTile(group: filteredGroups[index]);
            // }
            if(widget.followGroup) {
              return FollowGroupTile(group: allGroups[index], groupsFollowing: widget.user.groupsFollowing);
            }
            else if(widget.setAccessToGroup) {
              return SelectGroupForPermissionTile(group: allGroups[index], user: widget.user);
            }
            return GroupTile(group: allGroups[index], groupsFollowing: widget.user.groupsFollowing);
          }
        }
        return const SizedBox(height: 0);
      }
    );
  }
}
