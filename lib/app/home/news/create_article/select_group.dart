import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_up_park/app/announcements/empty_content.dart';
import 'package:get_up_park/app/announcements/list_items_builder.dart';
import 'package:get_up_park/app/home/groups/group_model.dart';
import 'package:get_up_park/app/home/groups/groups.dart';
import 'package:get_up_park/app/top_level_providers.dart';
import 'package:get_up_park/app/user_model.dart';
import 'package:get_up_park/shared_widgets/loading.dart';

// watch database
class SelectGroup extends ConsumerWidget {

  @override
  Widget build(BuildContext context, ScopedReader watch) {

      final userAsyncValue = watch(userStreamProvider);

      return userAsyncValue.when(
        data: (user) {
          return Scaffold(
            appBar: AppBar(
              brightness: Brightness.light,
              title: const Text(
                'Select Group',
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
            body: GroupsView(selectGroup: true, user: user),
          );
        },
        loading: () => const LoadingGroupsScroll(),
        error: (_,__) => EmptyContent(title: 'Error loading user data', message: 'Please try again',),
      );

  }
}