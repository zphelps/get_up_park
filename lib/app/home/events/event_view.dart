import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_up_park/app/announcements/empty_content.dart';
import 'package:get_up_park/app/home/events/event_model.dart';
import 'package:get_up_park/app/home/events/events_horizontal_scroll_widget.dart';
import 'package:get_up_park/app/home/settings/user_tile.dart';
import 'package:get_up_park/app/top_level_providers.dart';
import 'package:get_up_park/routing/app_router.dart';
import 'package:get_up_park/services/firestore_database.dart';
import 'package:get_up_park/shared_widgets/loading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';


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
            toolbarHeight: 45,
            title: const Text(
              'Event Details',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
            actions: [
                  () {
                if(user.admin == userTypes[0] || (user.admin == userTypes[1] && user.groupsUserCanAccess.contains(event.group))) {
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
                                      Navigator.of(context).pop();
                                      Navigator.of(context).pop();
                                      // Navigator.of(context).popUntil((route) => !route.hasActiveRouteBelow);
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
    final eventAsyncValue = watch(eventsStreamProvider);
    Event? evt;
    return eventAsyncValue.when(
      data: (events) {
        for(Event e in events) {
          print('in loop');
          if(e.id == event.id) {
            evt = e;
          }
        }
        if(evt == null) {
          evt = event;
        }
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                  () {
                if(evt!.imageURL != '') {
                  return CachedNetworkImage(
                    memCacheHeight: 1000,
                    memCacheWidth: 1000,
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
                      evt!.title,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
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
                    const SizedBox(height: 10),
                    const Divider(
                      height: 0,
                      thickness: 0.4,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Location & Date',
                      style: GoogleFonts.inter(
                        color: Colors.black,
                        fontWeight: FontWeight.w800,
                        fontSize: 17,
                      ),
                    ),
                    const SizedBox(height: 2),
                    ListTile(
                      dense:true,
                      visualDensity: const VisualDensity(vertical: -2),
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                      minVerticalPadding: 0,
                      horizontalTitleGap: 0,
                      leading: Icon(
                        Icons.access_time_filled_rounded,
                        color: Colors.grey.withOpacity(0.7),
                      ),
                      // title: const Text(
                      //   'Date',
                      //   style: TextStyle(
                      //       fontSize: 16,
                      //       fontWeight: FontWeight.w600,
                      //       color: Colors.black
                      //   ),
                      // ),
                      title: Text(
                        '${DateFormat.yMMMMEEEEd().format(DateTime.parse(evt!.date))} at ${DateFormat.jm().format(DateTime.parse(evt!.date))}',
                        style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.black
                        ),
                      ),
                    ),
                    // const Divider(
                    //   height: 0,
                    //   thickness: 0.75,
                    // ),
                    ListTile(
                      onTap: () async {
                        if(evt!.location.contains('www') || evt!.location.contains('http')) {
                          HapticFeedback.heavyImpact();
                          String url = evt!.location.contains('http') ? evt!.location : 'https://${evt!.location}';
                          if (await canLaunch(url)) {
                        await launch(url);
                        }
                        else {
                        // can't launch url, there is some error
                        print('error');
                        throw "Could not launch $url";
                        }
                        }
                      },
                      dense:true,
                      visualDensity: const VisualDensity(vertical: -2),
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                      minVerticalPadding: 0,
                      horizontalTitleGap: 0,
                      leading: Icon(
                        Icons.location_pin,
                        color: Colors.grey.withOpacity(0.75),
                      ),
                      // title: const Text(
                      //   'Location',
                      //   style: TextStyle(
                      //       fontSize: 16,
                      //       fontWeight: FontWeight.w600,
                      //       color: Colors.black
                      //   ),
                      // ),
                      title: Text(
                        evt!.location,
                        style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.black
                        ),
                      ),
                      trailing: Icon(
                        Icons.launch,
                        color: evt!.location.contains('www') || evt!.location.contains('http') ? Colors.grey : Colors.white,
                        size: 19,
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Divider(
                      height: 0,
                      thickness: 0.4,
                      color: Colors.grey,
                    ),
                        () {
                      if(evt!.description != '') {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 12),
                            const Text(
                              'About this event',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w800,
                                fontSize: 17,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              evt!.description,
                              style: const TextStyle(
                                height: 1.3,
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 15),
                            const Divider(
                              height: 0,
                              thickness: 0.4,
                              color: Colors.grey,
                            ),
                          ],
                        );
                      }
                      return const SizedBox(height: 0);
                    }(),
                    const SizedBox(height: 15),
                    const Text(
                      'Group:',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w800,
                        fontSize: 17,
                      ),
                    ),
                    // const SizedBox(height: 5),
                    ListTile(
                      onTap: () {
                        Navigator.of(context, rootNavigator: true).pushNamed(
                            AppRoutes.groupView,
                            arguments: {
                              'group':  FirestoreDatabase.getGroupFromString(groupAsyncValue, evt!.group),
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
                            imageUrl: evt!.groupImageURL,
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
                        evt!.group,
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
                      height: 0,
                      thickness: 0.4,
                      color: Colors.grey,
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
      },
      loading: () {
        return const LoadingNewsScroll();
      },
      error: (_,__) {
        return EmptyContent(title: 'Error loading event data.', message: 'Please check back later',);
      }
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

