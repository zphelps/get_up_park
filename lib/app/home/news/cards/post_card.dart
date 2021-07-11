import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_up_park/app/home/groups/group_model.dart';
import 'package:get_up_park/app/home/news/article_model.dart';
import 'package:get_up_park/app/top_level_providers.dart';
import 'package:get_up_park/routing/app_router.dart';
import 'package:get_up_park/services/firestore_database.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class PostCard extends StatelessWidget {
  const PostCard({required this.article, required this.admin, required this.group});

  final Article article;
  final Group group;
  final String admin;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            // color: Colors.black.withOpacity(0.15),
            // spreadRadius: 1,
            // blurRadius: 6,
            // offset: const Offset(0, 2),
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 0,
            blurRadius: 3,
            offset: const Offset(0, 1),
          )
        ]
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              onTap: () {
                Navigator.of(context, rootNavigator: true).pushNamed(
                    AppRoutes.groupView,
                    arguments: {
                      'group':  group,
                    }
                );
              },
              dense: true,
              horizontalTitleGap: 6,
              minVerticalPadding: 0,
              contentPadding: EdgeInsets.zero,
              visualDensity: const VisualDensity(vertical: -1),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: CachedNetworkImage(
                  memCacheHeight: 300,
                  memCacheWidth: 300,
                  imageUrl: article.groupLogoURL,
                  fit: BoxFit.fitHeight,
                  fadeOutDuration: Duration.zero,
                  placeholderFadeInDuration: Duration.zero,
                  fadeInDuration: Duration.zero,
                  width: 38,
                  height: 38,
                  placeholder: (context, url) => const Image(image: AssetImage('assets/skeletonImage.gif'), fit: BoxFit.cover),//Lottie.asset('assets/skeleton.json'),//SpinKitCubeGrid(color: Colors.red),
                ),
              ),
              title: Text(
                article.group,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
              subtitle: Text(
                DateFormat.yMMMMd('en_US')
                    .format(DateTime.parse(article.date)),
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: Colors.grey[700],
                  fontSize: 12,
                  fontFamily: 'SanFrancisco',
                ),
              ),
              trailing: PopupMenuButton(
                icon: Icon(
                  Icons.more_vert,
                  size: 20,
                  color: Colors.grey[700],
                ),
                //color: Colors.black,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15.0))
                ),
                itemBuilder: (BuildContext bc) {
                  if(admin == 'true') {
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
                  // Note You must create respective pages for navigation
                  //Navigator.pushNamed(context, route);
                },
              ),
            ),
            const SizedBox(height: 2),
            Padding(
              padding: const EdgeInsets.only(left: 2),
              child: ExpandableText(
                article.body,
                expandText: 'show more',
                collapseText: 'show less',
                maxLines: 3,
                expandOnTextTap: true,
                linkColor: Colors.grey[600],
                linkStyle: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 15,
                ),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                  fontFamily: 'SanFrancisco',
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
