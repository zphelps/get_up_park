import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get_up_park/app/home/groups/post_modal.dart';
import 'package:get_up_park/constants/news_categories.dart';
import 'package:intl/intl.dart';

class GroupPostTile extends StatelessWidget {
  const GroupPostTile({required this.post});

  final Post post;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 12, 15, 0),
      padding: const EdgeInsets.fromLTRB(15, 6, 15, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            horizontalTitleGap: 8,
            visualDensity: const VisualDensity(vertical: -1),
            leading: CachedNetworkImage(
              memCacheHeight: 300,
              memCacheWidth: 300,
              imageUrl: post.groupLogoURL,
              fit: BoxFit.contain,
              fadeOutDuration: Duration.zero,
              placeholderFadeInDuration: Duration.zero,
              width: 35,
              height: 35,
              placeholder: (context, url) => const Image(image: AssetImage('assets/skeletonImage.gif'), fit: BoxFit.cover),//Lottie.asset('assets/skeleton.json'),//SpinKitCubeGrid(color: Colors.red),
            ),
            title: Text(
              post.group,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 15,
              ),
            ),
            subtitle: Text(
                DateFormat.yMMMMd('en_US')
                    .format(DateTime.parse(post.date))
            ),
          ),
          const SizedBox(height: 4),
          Text(
            post.text,
            style: const TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 17,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 6,
          ),
        ],
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.125),
              spreadRadius: 0,
              blurRadius: 18,
              offset: const Offset(0, 1), // changes position of shadow
            ),
          ],
      ),
    );
  }
}
