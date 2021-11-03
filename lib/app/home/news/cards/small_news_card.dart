import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get_up_park/app/home/news/article_model.dart';
import 'package:get_up_park/app/user_model.dart';
import 'package:get_up_park/constants/news_categories.dart';
import 'package:get_up_park/routing/app_router.dart';
import 'package:intl/intl.dart';

class SmallNewsCard extends StatelessWidget {
  const SmallNewsCard({required this.user, required this.article});

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
      child: Container(
        margin: const EdgeInsets.fromLTRB(12, 5, 0, 25),
        child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                    child: CachedNetworkImage(
                      memCacheHeight: 3000,
                      memCacheWidth: 3000,
                      fadeOutDuration: Duration.zero,
                      placeholderFadeInDuration: Duration.zero,
                      fadeInDuration: Duration.zero,
                      imageUrl: article.imageURL,
                      fit: BoxFit.cover,
                      width: 225,
                      height: 112,
                      placeholder: (context, url) => const Image(image: AssetImage('assets/skeletonImage.gif'), fit: BoxFit.cover),//Lottie.asset('assets/skeleton.json'),//SpinKitCubeGrid(color: Colors.red),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 190,
                          child: AutoSizeText(
                            article.title,
                            minFontSize: 16,
                            maxFontSize: 16,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          DateFormat.yMMMMd('en_US').format(DateTime.parse(article.date)),
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[800],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(14, 98, 0, 0),
                padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 14),
                child: Text(
                  article.category,
                  style: TextStyle(
                    color: NewsCategories.getCategoryColor(article.category, false),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                decoration: BoxDecoration(
                  color: NewsCategories.getCategoryColor(article.category, true),
                  borderRadius: BorderRadius.circular(8),
                ),
              )
            ]
        ),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 0,
                blurRadius: 16,
                offset: const Offset(0, 2),
              )
            ]
        ),
      ),
    );
  }
}

