import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_up_park/app/announcements/empty_content.dart';
import 'package:get_up_park/app/home/groups/groups.dart';
import 'package:get_up_park/app/top_level_providers.dart';
import 'package:get_up_park/routing/app_router.dart';
import 'package:get_up_park/shared_widgets/loading.dart';
import 'package:google_fonts/google_fonts.dart';

// watch database
class FollowGroups extends ConsumerWidget {

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final userAsyncValue = watch(userStreamProvider);

    return userAsyncValue.when(
      data: (user) {
        return WillPopScope(
          onWillPop: () async {
            if (Navigator.of(context).userGestureInProgress) {
              return false;
            } else {
              return true;
            }
          },
          child: Scaffold(
            appBar: AppBar(
              brightness: Brightness.light,
              automaticallyImplyLeading: false,
              title: const Text(
                'Follow Groups',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w800
                ),
              ),
              backgroundColor: Colors.white,
              elevation: 1,
              iconTheme: const IconThemeData(
                color: Colors.black,
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 3, 5, 0),
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).pushNamed(
                        AppRoutes.homePage,
                      );
                    },
                    child: Text(
                      'Done',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            body: GroupsView(followGroup: true, user: user, showDialog: true,),
          ),
        );
      },
      loading: () {
        return const LoadingGroupsScroll();
      },
      error: (_,__) {
        return EmptyContent(message: 'Error loading groups',);
      }
    );

  }
}