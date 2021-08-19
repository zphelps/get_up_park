import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get_up_park/app/home/news/article_model.dart';
import 'package:get_up_park/app/user_model.dart';
import 'package:get_up_park/constants/news_categories.dart';
import 'package:get_up_park/routing/app_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

String getReadTime(String text) {
  int time = (text.split(' ').length / 200).floor();
  return time == 0 ? '< 1 min read' : '$time min read';
}

class NewsCard extends StatelessWidget {
  const NewsCard({required this.article, required this.user});

  final Article article;
  final PTUser user;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context, rootNavigator: true).pushNamed(
            AppRoutes.articleView,
            arguments: {
              'article': article,
              'user': user,
            }
        );
      },
      child: Hero(
        tag: article.body,
        child: SizedBox(
          child: Container(
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
                              width: 22,
                              height: 22,
                              placeholder: (context, url) => const Image(image: AssetImage('assets/skeletonImage.gif'), fit: BoxFit.cover),//Lottie.asset('assets/skeleton.json'),//SpinKitCubeGrid(color: Colors.red),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            article.group,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[900],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.55,
                        child: AutoSizeText(
                          article.title,
                          style: GoogleFonts.inter(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                          maxLines: 3,
                          minFontSize: 17,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        '${getReadTime(article.body)} • ${DateFormat.yMMMMd('en_US').format(DateTime.parse(article.date))}',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: Colors.grey[800],
                          fontWeight: FontWeight.w400,
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
                      width: MediaQuery.of(context).size.width * 0.275,//105,
                      height: MediaQuery.of(context).size.width * 0.275,//105,
                      placeholder: (context, url) => const Image(image: AssetImage('assets/skeletonImage.gif'), fit: BoxFit.cover),//Lottie.asset('assets/skeleton.json'),//SpinKitCubeGrid(color: Colors.red),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
