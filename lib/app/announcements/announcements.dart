import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_up_park/app/announcements/add_announcement.dart';
import 'package:get_up_park/app/announcements/announcement_model.dart';
import 'package:get_up_park/app/announcements/announcement_tile.dart';
import 'package:get_up_park/app/announcements/empty_content.dart';
import 'package:get_up_park/app/announcements/list_items_builder.dart';
import 'package:get_up_park/app/top_level_providers.dart';
import 'package:get_up_park/app/user_model.dart';
import 'package:get_up_park/constants/strings.dart';


final announcementsStreamProvider = StreamProvider.autoDispose<List<Announcement>>((ref) {
  final database = ref.watch(databaseProvider);
  return database.announcementsStream();
});

final userStreamProvider =
StreamProvider.autoDispose.family<PTUser, String>((ref, userID) {
  print(userID);
  final database = ref.watch(databaseProvider);
  // return database.userStream(userID: userID);
  return database.userStream();

});

// watch database
class Announcements extends ConsumerWidget {
  // Future<void> _delete(BuildContext context, Job job) async {
  //   try {
  //     final database = context.read<FirestoreDatabase>(databaseProvider);
  //     await database.deleteJob(job);
  //   } catch (e) {
  //     unawaited(showExceptionAlertDialog(
  //       context: context,
  //       title: 'Operation failed',
  //       exception: e,
  //     ));
  //   }
  // }

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final firebaseAuth = context.read(firebaseAuthProvider);
    final user = firebaseAuth.currentUser!;
    final userAsyncValue = watch(userStreamProvider(user.uid));
    return userAsyncValue.when(
      data: (user) {
        return Scaffold(
          appBar: AppBar(
            brightness: Brightness.light,
            title: const Text(
              Strings.announcements,
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
            actions: <Widget>[
                  () {
                print(user.admin);
                if(user.admin == 'true') {
                  return IconButton(
                    padding: const EdgeInsets.only(right: 18),
                    icon: const Icon(Icons.add),
                    onPressed: () => AddAnnouncement.show(context),
                  );
                }
                return const SizedBox(width: 0);
              }()
              // IconButton(
              //   icon: const Icon(Icons.add, color: Colors.white),
              //   onPressed: () => EditJobPage.show(context),
              // ),
            ],
          ),
          body: _buildContents(context, watch),
        );
      },
      loading: () => Container(
        color: Colors.transparent,
      ),
      error: (_, __) => EmptyContent(),
    );
    //print(user.uid);
  }

  Widget _buildContents(BuildContext context, ScopedReader watch) {
    final announcementsAsyncValue = watch(announcementsStreamProvider);
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: ListItemsBuilder<Announcement>(
        data: announcementsAsyncValue,
        itemBuilder: (context, announcement) => AnnouncementTile(
          title: announcement.title, body: announcement.body, url: announcement.url, date: announcement.date,
        ),
      ),
    );
  }
}