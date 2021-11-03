import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_up_park/app/home/groups/group_model.dart';
import 'package:get_up_park/app/top_level_providers.dart';
import 'package:get_up_park/constants/news_categories.dart';
import 'package:get_up_park/routing/app_router.dart';
import 'package:get_up_park/services/firestore_database.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class GroupTile extends StatefulWidget {

  final Group group;
  final List<dynamic> groupsFollowing;

  const GroupTile({required this.group, required this.groupsFollowing});

  @override
  State<GroupTile> createState() => _GroupTileState();
}

class _GroupTileState extends State<GroupTile> {

  bool showCheck = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(CachedNetworkImageProvider(widget.group.backgroundImageURL, cacheKey: widget.group.backgroundImageURL), context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              spreadRadius: 1,
              blurRadius: 12,
              offset: const Offset(0, 1),
              // color: Colors.black.withOpacity(0.15),
              // spreadRadius: 1,
              // blurRadius: 15,
              // offset: const Offset(0, 2),
            ),
          ]
      ),
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), //10, 4
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
                width: 50,
                height: 50,
                placeholder: (context, url) => const Image(image: AssetImage('assets/skeletonImage.gif'), fit: BoxFit.cover),//Lottie.asset('assets/skeleton.json'),//SpinKitCubeGrid(color: Colors.red),
              ),
            ),
            const SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.group.category,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: NewsCategories.getCategoryColor(widget.group.category, false),
                  ),
                  // style: TextStyle(
                  //   fontWeight: FontWeight.w600,
                  //   color: NewsCategories.getCategoryColor(widget.group.category, false),
                  //   fontSize: 12,
                  // ),
                ),
                const SizedBox(height: 1),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.475,
                  child: AutoSizeText(
                    widget.group.name,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    minFontSize: 16,
                  ),
                ),
              ],
            ),
            const Spacer(),
                () {
              if(!widget.groupsFollowing.contains(widget.group.name)) {
                return Column(
                  children: [
                    InkWell(
                      onTap: () async {
                        final database = context.read<FirestoreDatabase>(databaseProvider);
                        await database.followGroup(database.uid, widget.group.name);
                        setState(() {
                          showCheck = true;
                        });
                        await Future.delayed(const Duration(seconds: 2));
                        setState(() {
                          showCheck = false;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        child: Text(
                          'Follow',
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    // const SizedBox(height: 3),
                  ],
                );
              }
              return const SizedBox(height: 0);
            }(),
                () {
              if(showCheck) {
                return Row(
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: Colors.blue,
                      size: 20,
                    ),
                    const SizedBox(width: 15),
                  ],
                );
              }
              return const SizedBox(height: 0);
            }(),
            const SizedBox(width: 2),
            const Icon(
              Icons.chevron_right,
            ),
          ],
        ),
      ),
    );
  }
}
