import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_up_park/app/announcements/empty_content.dart';
import 'package:get_up_park/app/home/events/event_list_widget.dart';
import 'package:get_up_park/app/home/events/event_model.dart';
import 'package:get_up_park/app/home/events/events_horizontal_scroll_widget.dart';
import 'package:get_up_park/app/home/groups/group_model.dart';
import 'package:get_up_park/app/home/news/widgets/news_horizontal_scroll_widget.dart';
import 'package:get_up_park/app/top_level_providers.dart';
import 'package:get_up_park/app/user_model.dart';
import 'package:get_up_park/constants/news_categories.dart';
import 'package:get_up_park/routing/app_router.dart';
import 'package:get_up_park/services/firestore_database.dart';
import 'package:get_up_park/shared_widgets/loading.dart';
import 'package:intl/intl.dart';

final userStreamProvider =
StreamProvider.autoDispose<PTUser>((ref) {
  final database = ref.watch(databaseProvider);
  // return database.userStream(userID: userID);
  return database.userStream();

});

final groupsStreamProvider = StreamProvider.autoDispose<List<Group>>((ref) {
  final database = ref.watch(databaseProvider);
  return database.groupsStream();
});

class EventView extends ConsumerWidget {
  const EventView({required this.event});

  final Event event;
  
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final userAsyncValue = watch(userStreamProvider);
    return userAsyncValue.when(
      data: (user) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0.75,
            iconTheme: const IconThemeData(
              color: Colors.black,
            ),
            title: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const SizedBox(height: 3),
                const Text(
                  'Event Details',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
                Text(
                  event.group,
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            actions: [
                  () {
                if(user.admin == 'Admin' || user.admin == 'Student Admin') {
                  return Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      //radius: 20,
                      child: PopupMenuButton(
                        icon: const Icon(
                          Icons.more_horiz_outlined,
                          color: Colors.black,
                        ),
                        //color: Colors.black,
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15.0))
                        ),
                        itemBuilder: (BuildContext bc) => [
                          const PopupMenuItem(child: Text("Delete"), value: "delete"),
                          const PopupMenuItem(
                              child: Text("Edit"), value: "edit"),
                          //const PopupMenuItem(child: Text("Settings"), value: "/settings"),
                        ],
                        onSelected: (value) async {
                          print(value);
                          if(value == 'delete') {
                            showDialog<String>(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                title: const Text('Are you sure?'),
                                content: const Text('Once deleted, you will not be able to recover this event.'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      final database = context.read<FirestoreDatabase>(databaseProvider);
                                      await database.deleteEvent(event);
                                      Navigator.of(context).popUntil((route) => !route.hasActiveRouteBelow);
                                    },
                                    child: const Text(
                                      'Delete',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                          else if(value == 'edit') {
                            Navigator.of(context, rootNavigator: true).pushNamed(
                                AppRoutes.editGroupEventView,
                                arguments: {
                                  'event': event,
                                }
                            );
                          }
                        },
                      ),
                    ),
                  );
                }
                return const SizedBox(width: 0);
              }(),
            ],
            brightness: Brightness.light,
          ),
          body: _buildContents(context, watch, event),
        );
      },
      loading: () => const Loading(loadingMessage: 'Loading'),
      error: (_, __) => EmptyContent(),
    );
  }

  Widget _buildContents(BuildContext context, ScopedReader watch, Event event) {
    final groupAsyncValue = watch(groupsStreamProvider);
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
              () {
            if(event.imageURL != '') {
              return CachedNetworkImage(
                memCacheHeight: 3000,
                memCacheWidth: 3000,
                imageUrl: event.imageURL,
                fit: BoxFit.fitWidth,
                fadeOutDuration: Duration.zero,
                placeholderFadeInDuration: Duration.zero,
                fadeInDuration: Duration.zero,
                width: MediaQuery.of(context).size.width,
                height: 200,
                placeholder: (context, url) => const Image(image: AssetImage('assets/skeletonImage.gif'), fit: BoxFit.cover),//Lottie.asset('assets/skeleton.json'),//SpinKitCubeGrid(color: Colors.red),
              );
            }
            return const SizedBox(height: 0);
          }(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // const SizedBox(height: 3),
                const SizedBox(height: 5),
                Text(
                  event.title,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                // const SizedBox(height: 5),
                // Text(
                //   '${DateFormat.yMMMMEEEEd().format(DateTime.parse(event.date)).toUpperCase()} AT ${DateFormat.jm().format(DateTime.parse(event.date))}',
                //   style: TextStyle(
                //     color: Colors.grey[600],
                //     fontSize: 13,
                //     fontWeight: FontWeight.w600,
                //   ),
                // ),
                const SizedBox(height: 15),
                const Divider(
                  height: 0,
                  thickness: 0.85,
                ),
                ListTile(
                  dense:true,
                  visualDensity: const VisualDensity(vertical: 0),
                  contentPadding: const EdgeInsets.symmetric(vertical: 6),
                  minVerticalPadding: 0,
                  horizontalTitleGap: 0,
                  leading: const Icon(
                    Icons.place_outlined,
                    color: Colors.black,
                  ),
                  title: const Text(
                    'Location',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black
                    ),
                  ),
                  subtitle: Text(
                    event.location,
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: Colors.black
                    ),
                  ),
                ),
                const Divider(
                  height: 0,
                  thickness: 0.75,
                ),
                ListTile(
                  dense:true,
                  visualDensity: const VisualDensity(vertical: 0),
                  contentPadding: const EdgeInsets.symmetric(vertical: 6),
                  minVerticalPadding: 0,
                  horizontalTitleGap: 0,
                  leading: const Icon(
                    Icons.access_time_sharp,
                    color: Colors.black,
                  ),
                  title: const Text(
                    'Date',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black
                    ),
                  ),
                  subtitle: Text(
                    '${DateFormat.yMMMMEEEEd().format(DateTime.parse(event.date))} at ${DateFormat.jm().format(DateTime.parse(event.date))}',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: Colors.black
                    ),
                  ),
                ),
                const Divider(
                  height: 0,
                  thickness: 0.75,
                ),
                const SizedBox(height: 15),
                const Text(
                  'About this event:',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  event.description,
                  style: TextStyle(
                    height: 1.3,
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 15),
                const Divider(
                  height: 0,
                  thickness: 0.85,
                ),
                const SizedBox(height: 15),
                const Text(
                  'Group:',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
                // const SizedBox(height: 5),
                ListTile(
                  onTap: () {
                    Navigator.of(context, rootNavigator: true).pushNamed(
                        AppRoutes.groupView,
                        arguments: {
                          'group':  FirestoreDatabase.getGroupFromString(groupAsyncValue, event.group),
                        }
                    );
                  },
                  minVerticalPadding: 0,
                  horizontalTitleGap: 10,
                  contentPadding: const EdgeInsets.only(right: 5),
                  leading: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: CachedNetworkImage(
                        memCacheHeight: 200,
                        memCacheWidth: 200,
                        imageUrl: event.groupImageURL,
                        fadeInDuration: Duration.zero,
                        placeholderFadeInDuration: Duration.zero,
                        fadeOutDuration: Duration.zero,
                        fit: BoxFit.fitHeight,
                        width: 35,
                        height: 35,
                        placeholder: (context, url) => const Image(image: AssetImage('assets/skeletonImage.gif'), fit: BoxFit.cover),//Lottie.asset('assets/skeleton.json'),//SpinKitCubeGrid(color: Colors.red),
                      ),
                    ),
                  ),
                  title: Text(
                    event.group,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  trailing: Icon(
                    Icons.chevron_right,
                    color: Colors.grey[800],
                  ),
                ),
                const Divider(
                  height: 5,
                  thickness: 0.75,
                ),
                const SizedBox(height: 10),

              ],
            ),
          ),
          // EventsHorizontalScrollWidget(group: event.group, excludedEventID: event.id),
          const SizedBox(height: 45),
        ],
      ),
    );
  }

  // Widget _buildContents(BuildContext context, ScopedReader watch, Event event) {
  //   final groupAsyncValue = watch(groupsStreamProvider);
  //   return SingleChildScrollView(
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Padding(
  //           padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               // const SizedBox(height: 3),
  //               Text(
  //                 event.title,
  //                 style: const TextStyle(
  //                   color: Colors.black,
  //                   fontSize: 28,
  //                   fontWeight: FontWeight.w700,
  //                 ),
  //               ),
  //               const SizedBox(height: 5),
  //               Text(
  //                 '${DateFormat.yMMMMEEEEd().format(DateTime.parse(event.date)).toUpperCase()} AT ${DateFormat.jm().format(DateTime.parse(event.date))}',
  //                 style: TextStyle(
  //                   color: Colors.grey[600],
  //                   fontSize: 13,
  //                   fontWeight: FontWeight.w600,
  //                 ),
  //               ),
  //               const SizedBox(height: 10),
  //               const Divider(
  //                 height: 0,
  //                 thickness: 0.85,
  //               ),
  //               ListTile(
  //                 dense:true,
  //                 visualDensity: const VisualDensity(vertical: 1),
  //                 contentPadding: EdgeInsets.zero,
  //                 minVerticalPadding: 0,
  //                 horizontalTitleGap: 0,
  //                 leading: const Icon(
  //                   Icons.location_pin,
  //                   color: Colors.black,
  //                 ),
  //                 title: const Text(
  //                   'Location',
  //                   style: TextStyle(
  //                     fontSize: 16,
  //                     fontWeight: FontWeight.w600,
  //                     color: Colors.black
  //                   ),
  //                 ),
  //                 subtitle: Text(
  //                   event.location,
  //                   style: TextStyle(
  //                       fontSize: 14,
  //                       fontWeight: FontWeight.w500,
  //                       color: Colors.grey[600]
  //                   ),
  //                 ),
  //               ),
  //               const Divider(
  //                 height: 0,
  //                 thickness: 0.75,
  //               ),
  //               const SizedBox(height: 12),
  //               const Text(
  //                 'Details:',
  //                 style: TextStyle(
  //                   color: Colors.black,
  //                   fontWeight: FontWeight.w700,
  //                   fontSize: 18,
  //                 ),
  //               ),
  //               const SizedBox(height: 5),
  //               Text(
  //                 event.description,
  //                 style: TextStyle(
  //                   height: 1.3,
  //                   color: Colors.grey[600],
  //                   fontWeight: FontWeight.w500,
  //                   fontSize: 15,
  //                 ),
  //               ),
  //               const SizedBox(height: 12),
  //               const Divider(
  //                 height: 0,
  //                 thickness: 0.85,
  //               ),
  //               const SizedBox(height: 12),
  //               const Text(
  //                 'Group:',
  //                 style: TextStyle(
  //                   color: Colors.black,
  //                   fontWeight: FontWeight.w700,
  //                   fontSize: 18,
  //                 ),
  //               ),
  //               const SizedBox(height: 5),
  //               ListTile(
  //                 onTap: () {
  //                   Navigator.of(context, rootNavigator: true).pushNamed(
  //                       AppRoutes.groupView,
  //                       arguments: {
  //                         'group':  FirestoreDatabase.getGroupFromString(groupAsyncValue, event.group),
  //                       }
  //                   );
  //                 },
  //                 minVerticalPadding: 0,
  //                 horizontalTitleGap: 10,
  //                 contentPadding: const EdgeInsets.only(right: 5),
  //                 leading: CircleAvatar(
  //                   backgroundColor: Colors.white,
  //                   child: ClipRRect(
  //                     borderRadius: BorderRadius.circular(30),
  //                     child: CachedNetworkImage(
  //                       memCacheHeight: 200,
  //                       memCacheWidth: 200,
  //                       imageUrl: event.groupImageURL,
  //                       fadeInDuration: Duration.zero,
  //                       placeholderFadeInDuration: Duration.zero,
  //                       fadeOutDuration: Duration.zero,
  //                       fit: BoxFit.fitHeight,
  //                       width: 35,
  //                       height: 35,
  //                       placeholder: (context, url) => const Image(image: AssetImage('assets/skeletonImage.gif'), fit: BoxFit.cover),//Lottie.asset('assets/skeleton.json'),//SpinKitCubeGrid(color: Colors.red),
  //                     ),
  //                   ),
  //                 ),
  //                 title: Text(
  //                   event.group,
  //                   style: const TextStyle(
  //                     color: Colors.black,
  //                     fontSize: 16,
  //                     fontWeight: FontWeight.w600,
  //                   ),
  //                 ),
  //                 trailing: Icon(
  //                   Icons.chevron_right,
  //                   color: Colors.grey[800],
  //                 ),
  //               ),
  //               const Divider(
  //                 height: 5,
  //                 thickness: 0.75,
  //               ),
  //               const SizedBox(height: 10),
  //
  //             ],
  //           ),
  //         ),
  //         // EventsHorizontalScrollWidget(group: event.group, excludedEventID: event.id),
  //         const SizedBox(height: 45),
  //       ],
  //     ),
  //   );
  // }

}

