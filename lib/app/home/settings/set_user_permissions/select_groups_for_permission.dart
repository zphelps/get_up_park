import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_up_park/app/announcements/empty_content.dart';
import 'package:get_up_park/app/announcements/list_items_builder.dart';
import 'package:get_up_park/app/home/groups/group_model.dart';
import 'package:get_up_park/app/home/groups/groups.dart';
import 'package:get_up_park/app/home/news/create_article/select_group_tile.dart';
import 'package:get_up_park/app/top_level_providers.dart';
import 'package:get_up_park/app/user_model.dart';
import 'package:get_up_park/routing/app_router.dart';
import 'package:get_up_park/shared_widgets/loading.dart';
import 'package:google_fonts/google_fonts.dart';


class SelectGroupsForPermission extends StatelessWidget {
  const SelectGroupsForPermission({required this.user});

  final PTUser user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        automaticallyImplyLeading: false,
        title: const Text(
          'Select Groups',
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
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 3, 5, 0),
            child: TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
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
      body: GroupsView(setAccessToGroup: true, user: user),
    );
  }
}

// final groupsStreamProvider = StreamProvider.autoDispose<List<Group>>((ref) {
//   final database = ref.watch(databaseProvider);
//   return database.groupsStream();
// });
//
// final userStreamProvider = StreamProvider.autoDispose<List<PTUser>>((ref) {
//   final database = ref.watch(databaseProvider);
//   return database.usersStream();
// });
//
// // watch database
// class SelectGroupsForPermission extends ConsumerWidget {
//
//   @override
//   Widget build(BuildContext context, ScopedReader watch) {
//     final userAsyncValue = watch(userStreamProvider);
//
//     return userAsyncValue.when(
//         data: (users) {
//           return Scaffold(
//             appBar: AppBar(
//               brightness: Brightness.light,
//               automaticallyImplyLeading: false,
//               title: const Text(
//                 'Select Groups',
//                 style: TextStyle(
//                     color: Colors.black,
//                     fontSize: 16,
//                     fontWeight: FontWeight.w600
//                 ),
//               ),
//               backgroundColor: Colors.white,
//               elevation: 1,
//               iconTheme: const IconThemeData(
//                 color: Colors.black,
//               ),
//               actions: [
//                 Padding(
//                   padding: const EdgeInsets.fromLTRB(0, 3, 5, 0),
//                   child: TextButton(
//                     onPressed: () {
//                       Navigator.of(context).pop();
//                     },
//                     child: Text(
//                       'Done',
//                       style: GoogleFonts.inter(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w700,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             body: GroupsView(setAccessToGroup: true, user: user),
//           );
//         },
//         loading: () {
//           return const LoadingGroupsScroll();
//         },
//         error: (_,__) {
//           return EmptyContent(message: 'Error loading groups',);
//         }
//     );
//
//   }
// }