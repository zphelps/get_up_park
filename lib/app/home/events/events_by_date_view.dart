import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_up_park/app/home/events/event_list_widget.dart';
import 'package:get_up_park/app/home/groups/group_model.dart';
import 'package:get_up_park/app/top_level_providers.dart';
import 'package:get_up_park/shared_widgets/vertical_list_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


final groupsStreamProvider = StreamProvider.autoDispose<List<Group>>((ref) {
  final database = ref.watch(databaseProvider);
  return database.groupsStream();
});

// watch database
class EventsByDateView extends ConsumerWidget {

  const EventsByDateView({required this.date, required this.groupsFollowing, required this.title});

  final List<dynamic> groupsFollowing;
  final String date;
  final String title;

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        brightness: Brightness.light,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: _buildContents(context, watch),
    );
    //print(user.uid);
  }

  Widget _buildContents(BuildContext context, ScopedReader watch) {
    final groupAsyncValue = watch(groupsStreamProvider);
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 0),
        child: VerticalListBuilder<Group>(
            data: groupAsyncValue,
            itemBuilder: (context, group) {
              if(groupsFollowing.contains(group.name)) {
                return Column(
                  children: [
                    Container(
                      color: Colors.white,
                      padding: const EdgeInsets.only(bottom: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            horizontalTitleGap: 5,
                            minVerticalPadding: 0,
                            visualDensity: const VisualDensity(horizontal: 0, vertical: 0),
                            title: Text(
                              group.name,
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              ),
                            ),
                            leading: CachedNetworkImage(
                              memCacheHeight: 3000,
                              memCacheWidth: 4000,
                              imageUrl: group.logoURL,
                              fit: BoxFit.fitWidth,
                              width: 35,
                              height: 35,
                              placeholder: (context, url) => const Image(image: AssetImage('assets/skeletonImage.gif'), fit: BoxFit.cover),//Lottie.asset('assets/skeleton.json'),//SpinKitCubeGrid(color: Colors.red),
                            ),
                          ),
                          //const SizedBox(height: 10),
                          EventListWidget(group: group.name, date: date, admin: 'false'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Divider(
                    //   thickness: 1,
                    //   color: Colors.grey[300],
                    // ),
                  ],
                );
              }
              return const SizedBox(width: 0);
            }
        ),
      ),
    );
    // return Padding(
    //   padding: const EdgeInsets.symmetric(vertical: 10),
    //   child: ListView.builder(
    //     shrinkWrap: true,
    //     physics: const NeverScrollableScrollPhysics(),
    //     itemCount: groupsFollowing.length,
    //     itemBuilder: (BuildContext context, int index) {
    //       return Column(
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: [
    //           const SizedBox(height: 5),
    //           Padding(
    //             padding: const EdgeInsets.only(left: 10),
    //             child: Text(
    //               groupsFollowing[index],
    //               style: const TextStyle(
    //                 fontSize: 18,
    //                 color: Colors.black,
    //                 fontWeight: FontWeight.w700,
    //               ),
    //             ),
    //           ),
    //           const SizedBox(height: 10),
    //           EventListWidget(group: groupsFollowing[index], date: date),
    //           const SizedBox(height: 5),
    //           const Divider(
    //             thickness: 0.75,
    //           ),
    //         ],
    //       );
    //     },
    //
    //   ),
    // );
  }
}