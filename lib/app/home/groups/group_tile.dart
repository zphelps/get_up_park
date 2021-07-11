import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_up_park/app/home/groups/group_model.dart';
import 'package:get_up_park/app/top_level_providers.dart';
import 'package:get_up_park/constants/news_categories.dart';
import 'package:get_up_park/routing/app_router.dart';
import 'package:get_up_park/services/firestore_database.dart';

class GroupTile extends StatefulWidget {

  final Group group;

  const GroupTile({required this.group});

  @override
  State<GroupTile> createState() => _GroupTileState();
}

class _GroupTileState extends State<GroupTile> {

  bool isFollowing = false;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    // precacheImage(CachedNetworkImageProvider(widget.group.backgroundImageURL, cacheKey: widget.group.backgroundImageURL), context);
    // precacheImage(CachedNetworkImageProvider(widget.group.logoURL, cacheKey: widget.group.logoURL), context);
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: InkWell(onTap: () async {
        HapticFeedback.lightImpact();
        if(widget.group.sport == '') {
          Navigator.of(context, rootNavigator: true).pushNamed(
              AppRoutes.groupView,
              arguments: {
                'group':  widget.group,
              }
          );
        }
        else {
          Navigator.of(context, rootNavigator: true).pushNamed(
              AppRoutes.sportsProfileView,
              arguments: {
                'group':  widget.group,
              }
          );
        }
      },

        child: Row(
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ClipRRect(
            //   borderRadius: BorderRadius.circular(30),
            //   child: Image(
            //     image: NetworkImage(widget.group.logoURL),
            //     fit: BoxFit.fitWidth,
            //     height: 45,
            //     width: 45,
            //   ),
            // ),
            ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: CachedNetworkImage(
                memCacheHeight: 500,
                memCacheWidth: 500,
                imageUrl: widget.group.logoURL,
                fit: BoxFit.fitWidth,
                fadeOutDuration: Duration.zero,
                placeholderFadeInDuration: Duration.zero,
                fadeInDuration: Duration.zero,
                width: 45,
                height: 45,
                placeholder: (context, url) => const Image(image: AssetImage('assets/skeletonImage.gif'), fit: BoxFit.cover),//Lottie.asset('assets/skeleton.json'),//SpinKitCubeGrid(color: Colors.red),
              ),
            ),
            const SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.group.category,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: NewsCategories.getCategoryColor(widget.group.category, false),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  widget.group.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 17,
                  ),
                ),
              ],
            ),
            const Spacer(),
            const Icon(
              Icons.chevron_right,
            ),
          ],
        ),
      ),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.125),
              spreadRadius: 0,
              blurRadius: 5,
              offset: const Offset(0, 1), // changes position of shadow
            ),
          ]
      ),
    );
  }
}
