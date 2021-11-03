import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_up_park/app/home/news/article_model.dart';
import 'package:get_up_park/app/home/news/widgets/news_horizontal_scroll_widget.dart';
import 'package:get_up_park/app/home/news/widgets/article_group_tile.dart';
import 'package:get_up_park/app/home/settings/user_tile.dart';
import 'package:get_up_park/app/top_level_providers.dart';
import 'package:get_up_park/app/user_model.dart';
import 'package:get_up_park/constants/news_categories.dart';
import 'package:get_up_park/routing/app_router.dart';
import 'package:get_up_park/services/firestore_database.dart';
import 'package:intl/intl.dart';

class ArticleView extends StatelessWidget {
  const ArticleView({required this.user, required this.article});

  final Article article;
  final PTUser user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: <Widget>[
          // Add the app bar to the CustomScrollView.
          SliverAppBar(
            stretch: true,
            pinned: true,
            toolbarHeight: 45,
            collapsedHeight: 45,
            backgroundColor: Colors.white,
            elevation: 1,
            brightness: Brightness.light,
            iconTheme: const IconThemeData(
              color: Colors.black,
            ),
            leading: Padding(
              padding: const EdgeInsets.only(left: 15),
              child: InkWell(
                onTap: () {
                  Navigator.of(context, rootNavigator: true).pop();
                },
                child: const CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 15,
                  child: Icon(Icons.arrow_back, color: Colors.black),
                ),
              ),
            ),
            actions: [
                  () {
                if(user.admin == userTypes[0] || (user.admin == userTypes[1] && user.groupsUserCanAccess.contains(article.group))) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 16),
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
                                content: const Text('Once deleted, you will not be able to recover this article.'),
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
                                AppRoutes.editArticleView,
                                arguments: {
                                  'article': article,
                                }
                            );
                          }
                          // Note You must create respective pages for navigation
                          //Navigator.pushNamed(context, route);
                        },
                      ),
                    ),
                  );
                }
                return const SizedBox(width: 0);
              }(),
            ],
            // Provide a standard title.
            // Allows the user to reveal the app bar if they begin scrolling
            // back up the list of items.
            floating: false,
            // Display a placeholder widget to visualize the shrinking size.
            flexibleSpace: FlexibleSpaceBar(
              background: DecoratedBox(
                decoration: const BoxDecoration(),
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
                    tag: article.body,
                    child: CachedNetworkImage(
                      memCacheWidth: 3000,
                      memCacheHeight: 3000,
                      imageUrl: article.imageURL,
                      fit: BoxFit.cover,
                      width: 175,
                      placeholder: (context, url) =>
                      const Image(
                          image: AssetImage('assets/skeletonImage.gif'),
                          fit: BoxFit
                              .cover), //Lottie.asset('assets/skeleton.json'),//SpinKitCubeGrid(color: Colors.red),
                    ),
                  ),
                ),
              ),
            ),

            // Make the initial height of the SliverAppBar larger than normal.
            expandedHeight: 300,
          ),
          // Next, create a SliverList
          SliverList(
              delegate: SliverChildListDelegate.fixed(
                  [
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 13),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
                            child: Text(
                              article.category.toUpperCase(),
                              style: TextStyle(
                                color: NewsCategories.getCategoryColor(article.category, false),
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            decoration: BoxDecoration(
                              color: NewsCategories.getCategoryColor(article.category, true),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          const Spacer(),
                          // IconButton(
                          //   icon: const Icon(CupertinoIcons.heart, color: Colors.black),
                          //   onPressed: () {
                          //
                          //   },
                          // ),
                          IconButton(
                            icon: const Icon(Icons.share, color: Colors.white,),
                            iconSize: 20,
                            onPressed: () {

                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 5),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15),
                      child: SizedBox(
                        child: AutoSizeText(
                          article.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 30,
                            color: Colors.black,
                          ),
                          maxLines: 3,
                          maxFontSize: 30,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15),
                      child: Text(
                        '${DateFormat.yMMMMd('en_US')
                            .format(DateTime.parse(article.date))}',
                        // '${DateFormat.yMMMMEEEEd().format(DateTime.parse(article.date))}',
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Divider(height: 5, thickness: 0.85),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15),
                      child: ArticleGroupTile(group: article.group, groupLogoURL: article.groupLogoURL),
                    ),
                    const Divider(height: 5, thickness: 0.85),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15),
                      child: Text(
                        article.body,
                        style: TextStyle(
                          color: Colors.grey[800],
                          fontSize: 16,
                          letterSpacing: -0.1,
                          height: 1.35,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'SanFrancisco',
                        ),
                      ),
                    ),
                    //const SizedBox(height: 15),
                    const Divider(
                      height: 40,
                      thickness: 2,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: Text(
                        'More ${article.category} news',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    NewsHorizontalScrollWidget(user: user, category: article.category, excludedArticleID: article.id),
                    const SizedBox(height: 35),
                  ]
              )
          ),
        ],
      ),
    );
  }
}