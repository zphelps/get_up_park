import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_up_park/app/home/groups/group_model.dart';
import 'package:get_up_park/app/top_level_providers.dart';
import 'package:get_up_park/services/firestore_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class FollowGroupTile extends StatefulWidget {

  final Group group;
  final String userID;
  final bool isFollowing;

  const FollowGroupTile({required this.group, required this.userID, required this.isFollowing});

  @override
  State<FollowGroupTile> createState() => _FollowGroupTileState();
}

class _FollowGroupTileState extends State<FollowGroupTile> {

  bool isFollowing = false;

  @override
  Widget build(BuildContext context) {
    isFollowing = widget.isFollowing;
    return InkWell(
      onTap: () async {
        HapticFeedback.heavyImpact();
        final database = context.read<FirestoreDatabase>(databaseProvider);
        isFollowing ? await database.unfollowGroup(widget.userID, widget.group.name) : await database.followGroup(widget.userID, widget.group.name);
        setState(() {
          isFollowing = !isFollowing;
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        child: ListTile(
          minVerticalPadding: 0,
          contentPadding: EdgeInsets.zero,
          visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
          leading: CachedNetworkImage(
            memCacheHeight: 300,
            memCacheWidth: 300,
            imageUrl: widget.group.logoURL,
            fit: BoxFit.fitHeight,
            width: 30,
            height: 30,
            placeholder: (context, url) => const Image(image: AssetImage('assets/skeletonImage.gif'), fit: BoxFit.cover),//Lottie.asset('assets/skeleton.json'),//SpinKitCubeGrid(color: Colors.red),
          ),
          title: Text(
            widget.group.name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          trailing: InkWell(
            onTap: () async {
              HapticFeedback.heavyImpact();
              final database = context.read<FirestoreDatabase>(databaseProvider);
              isFollowing ? await database.unfollowGroup(widget.userID, widget.group.name) : await database.followGroup(widget.userID, widget.group.name);
              setState(() {
                isFollowing = !isFollowing;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
              child: Text(
                isFollowing ? 'Unfollow' : 'Follow',
                style: TextStyle(
                  color: isFollowing ? Colors.white : Colors.black,
                  fontWeight: FontWeight.w700,
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          // trailing: CircleAvatar(
          //   radius: 16,
          //   backgroundColor: Colors.white,
          //   child: Icon(
          //     isFollowing ? Icons.check_circle : Icons.check_circle_outline,
          //     color: isFollowing ? Colors.blue : Colors.grey,
          //   ),
          // ),
        ),
        // child: Row(
        //   //crossAxisAlignment: CrossAxisAlignment.start,
        //   children: [
        //     CachedNetworkImage(
        //       memCacheHeight: 300,
        //       memCacheWidth: 300,
        //       imageUrl: group.logoURL,
        //       fit: BoxFit.fitHeight,
        //       width: 30,
        //       height: 30,
        //       placeholder: (context, url) => const Image(image: AssetImage('assets/skeletonImage.gif'), fit: BoxFit.cover),//Lottie.asset('assets/skeleton.json'),//SpinKitCubeGrid(color: Colors.red),
        //     ),
        //     const SizedBox(width: 15),
        //     Text(
        //       group.name,
        //       style: const TextStyle(
        //         fontWeight: FontWeight.bold,
        //         fontSize: 16,
        //       ),
        //     ),
        //     const SizedBox(height: 4),
        //   ],
        // ),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 24,
                offset: const Offset(0, 2), // changes position of shadow
              ),
            ]
        ),
      ),
    );
  }
}
