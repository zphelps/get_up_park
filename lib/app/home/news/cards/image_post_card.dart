import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_up_park/app/home/groups/group_model.dart';
import 'package:get_up_park/app/home/news/article_model.dart';
import 'package:get_up_park/app/home/news/time_ago.dart';
import 'package:get_up_park/app/home/settings/user_tile.dart';
import 'package:get_up_park/app/top_level_providers.dart';
import 'package:get_up_park/app/user_model.dart';
import 'package:get_up_park/routing/app_router.dart';
import 'package:get_up_park/services/firestore_database.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class ImagePostCard extends StatelessWidget {
  const ImagePostCard({required this.article, required this.user, required this.group});

  final Article article;
  final Group group;
  final PTUser user;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), //10, 6
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15), //6
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.175),
              spreadRadius: 0,
              blurRadius: 12,
              offset: const Offset(0, 3),
              // color: Colors.black.withOpacity(0.15), //0.35
              // spreadRadius: 0,
              // blurRadius: 15,
              // offset: const Offset(0, 3),
            )
          ]
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 6), //15, 6
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              onTap: () {
                if(group.sport != '') {
                  Navigator.of(context, rootNavigator: true).pushNamed(
                      AppRoutes.sportsProfileView,
                      arguments: {
                        'group':  group,
                      }
                  );
                }
                else {
                  Navigator.of(context, rootNavigator: true).pushNamed(
                      AppRoutes.groupView,
                      arguments: {
                        'group':  group,
                      }
                  );
                }
              },
              dense: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 15),
              horizontalTitleGap: 8,
              minVerticalPadding: 0,
              visualDensity: const VisualDensity(vertical: -1),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: CachedNetworkImage(
                  memCacheHeight: 300,
                  memCacheWidth: 300,
                  imageUrl: article.groupLogoURL,
                  fit: BoxFit.contain,
                  fadeOutDuration: Duration.zero,
                  placeholderFadeInDuration: Duration.zero,
                  fadeInDuration: Duration.zero,
                  width: 40,
                  height: 40,
                  placeholder: (context, url) => const Image(image: AssetImage('assets/skeletonImage.gif'), fit: BoxFit.cover),//Lottie.asset('assets/skeleton.json'),//SpinKitCubeGrid(color: Colors.red),
                ),
              ),
              title: Text(
                article.group,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                  color: Colors.black,
                ),
              ),
              subtitle: Text(
                  // DateFormat.yMMMMd('en_US')
                  //     .format(DateTime.parse(article.date)),
                '${TimeAgo.timeAgoSinceDate(article.date)}',
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w400,
                  color: Colors.grey[700],
                  fontSize: 12,
                ),
              ),
              trailing: PopupMenuButton(
                icon: Icon(
                  Icons.more_vert,
                  size: 20,
                  color: Colors.grey[800],
                ),
                //color: Colors.black,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15.0))
                ),
                itemBuilder: (BuildContext bc) {
                  if(user.admin == userTypes[0] || (user.admin == userTypes[1] && user.groupsUserCanAccess.contains(article.group))) {
                    return [
                      const PopupMenuItem(child: Text("Delete"), value: "delete"),
                      const PopupMenuItem(
                          child: Text("Edit"), value: "edit"),
                    ];
                  }
                  else {
                    return [
                      const PopupMenuItem(child: Text("Report"), value: "report"),
                    ];
                  }
                },
                onSelected: (value) async {
                  if(value == 'delete') {
                    showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: const Text('Are you sure?'),
                        content: const Text('Once deleted, you will not be able to recover this post.'),
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
                              await database.deleteArticle(article);
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
                        AppRoutes.editNewsView,
                        arguments: {
                          'article': article,
                        }
                    );
                  }
                  else if(value == 'report') {
                    HapticFeedback.heavyImpact();
                    String url = 'https://docs.google.com/forms/d/e/1FAIpQLSe09ZLyK3aMOr6LGSWmpGZIz2AQwEmbI_3KrB1DDCki3V8Vjw/viewform?usp=sf_link';
                    if (await canLaunch(url)) {
                      await launch(url);
                    }
                    else {
                      // can't launch url, there is some error
                      throw "Could not launch $url";
                    }
                  }
                },
              ),
            ),
            const SizedBox(height: 2),
            () {
              if(article.body.length > 1) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ExpandableText(
                        article.body,
                        expandText: 'show more',
                        collapseText: 'show less',
                        maxLines: 5,
                        expandOnTextTap: true,
                        linkColor: Colors.grey[600],
                        linkStyle: const TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 15,
                        ),
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                        // style: const TextStyle(
                        //   fontSize: 16,
                        //   fontWeight: FontWeight.w400,
                        //   color: Colors.black,
                        //   fontStyle: GoogleFonts.
                        //   // fontFamily: 'SanFrancisco',
                        // ),
                      ),
                      const SizedBox(height: 15),
                    ],
                  ),
                );
              }
              return const SizedBox(height: 0);
            }(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: InkWell(
                onTap: () {
                  Navigator.of(context, rootNavigator: true).pushNamed(
                      AppRoutes.fullScreenImageView,
                      arguments: {
                        'imageURL': article.imageURL,
                      }
                  );
                },
                child: Hero(
                  tag: article.imageURL,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6), //5
                    child: CachedNetworkImage(
                      memCacheHeight: 9000,
                      memCacheWidth: 9000,
                      imageUrl: article.imageURL,
                      fadeOutDuration: Duration.zero,
                      placeholderFadeInDuration: Duration.zero,
                      fadeInDuration: Duration.zero,
                      fit: BoxFit.fitWidth,
                      // width: 374,
                      width: MediaQuery.of(context).size.width * 0.95,
                      height: CachedNetworkImage(imageUrl: article.imageURL,).height,
                      placeholder: (context, url) => const Image(image: AssetImage('assets/skeletonImage.gif',), fit: BoxFit.cover, height: 200,),//Lottie.asset('assets/skeleton.json'),//SpinKitCubeGrid(color: Colors.red),
                    ),
                  ),
                ),
              ),
            ),
            // const SizedBox(height: 5),
            // const Divider(height: 15),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 20),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       Text(
            //           '${DateFormat.MMMEd('en_US')
            //           .format(DateTime.parse(article.date))}',
            //         style: GoogleFonts.inter(
            //           color: Colors.grey[700],
            //           fontWeight: FontWeight.w400,
            //           fontSize: 13,
            //         ),
            //       ),
            //       Text(
            //         '${DateFormat.jm('en_US')
            //             .format(DateTime.parse(article.date))}',
            //         style: GoogleFonts.inter(
            //           color: Colors.grey[700],
            //           fontWeight: FontWeight.w400,
            //           fontSize: 13,
            //         ),
            //       )
            //     ],
            //   ),
            // ),
            const SizedBox(height: 12), //12
          ],
        ),
      ),
    );
  }
}
