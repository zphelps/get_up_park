import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get_up_park/app/home/news/article_model.dart';
import 'package:get_up_park/constants/news_categories.dart';
import 'package:get_up_park/routing/app_router.dart';
import 'package:intl/intl.dart';

String getReadTime(String text) {
  int time = (text.split(' ').length / 200).floor();
  return time == 0 ? '< 1 min read' : '$time min read';
}

class NewsCard extends StatelessWidget {
  const NewsCard({required this.article, required this.admin});

  final Article article;
  final String admin;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context, rootNavigator: true).pushNamed(
            AppRoutes.articleView,
            arguments: {
              'article': article,
              'admin': admin,
            }
        );
      },
      child: SizedBox(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 3),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(0), //6
              boxShadow: [
                BoxShadow(
                  // color: Colors.black.withOpacity(0.15),
                  // spreadRadius: 1,
                  // blurRadius: 6,
                  // offset: const Offset(0, 2),
                  // color: Colors.black.withOpacity(0.2),
                  // spreadRadius: 0,
                  // blurRadius: 3,
                  // offset: const Offset(0, 1),
                )
              ]
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: CachedNetworkImage(
                            memCacheHeight: 300,
                            memCacheWidth: 300,
                            imageUrl: article.groupLogoURL,
                            fadeOutDuration: Duration.zero,
                            placeholderFadeInDuration: Duration.zero,
                            fadeInDuration: Duration.zero,
                            fit: BoxFit.fitWidth,
                            width: 20,
                            height: 20,
                            placeholder: (context, url) => const Image(image: AssetImage('assets/skeletonImage.gif'), fit: BoxFit.cover),//Lottie.asset('assets/skeleton.json'),//SpinKitCubeGrid(color: Colors.red),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          article.group,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[900],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: AutoSizeText(
                        article.title,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                        maxLines: 3,
                        minFontSize: 17,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${getReadTime(article.body)} • ${DateFormat.yMMMMd('en_US').format(DateTime.parse(article.date))}',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[900],
                        fontWeight: FontWeight.w500,
                        fontFamily: 'SanFrancisco'
                      ),
                    ),
                  ],
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: CachedNetworkImage(
                    memCacheHeight: 3000,
                    memCacheWidth: 3000,
                    imageUrl: article.imageURL,
                    fadeOutDuration: Duration.zero,
                    placeholderFadeInDuration: Duration.zero,
                    fadeInDuration: Duration.zero,
                    fit: BoxFit.cover,
                    width: 105,
                    height: 105,
                    placeholder: (context, url) => const Image(image: AssetImage('assets/skeletonImage.gif'), fit: BoxFit.cover),//Lottie.asset('assets/skeleton.json'),//SpinKitCubeGrid(color: Colors.red),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
