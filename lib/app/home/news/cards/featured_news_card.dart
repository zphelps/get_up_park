import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_up_park/app/announcements/empty_content.dart';
import 'package:get_up_park/app/home/news/article_model.dart';
import 'package:get_up_park/app/top_level_providers.dart';
import 'package:get_up_park/constants/news_categories.dart';
import 'package:get_up_park/routing/app_router.dart';
import 'package:intl/intl.dart';

final newsStreamProvider = StreamProvider.autoDispose<List<Article>>((ref) {
  final database = ref.watch(databaseProvider);
  return database.articleStream();
});


class FeaturedNewsCard extends ConsumerWidget {

  FeaturedNewsCard({required this.admin, required this.category});

  final String admin;
  final String category;

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final articleAsyncValue = watch(newsStreamProvider);

    Article? article;

    articleAsyncValue.whenData((articles) {
      articles.sort((a, b) => DateTime.parse(a.date).compareTo(DateTime.parse(b.date)));
      for(Article a in articles) {
        if(a.category == category && a.title != '') {
          article = a;
        }
      }
    });

    if(article == null) {
      return EmptyContent(title: 'No events found', message: 'Please check back later.', center: true);
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: InkWell(
        onTap: () {
          Navigator.of(context, rootNavigator: true).pushNamed(
              AppRoutes.articleView,
              arguments: {
                'article': article,
                'admin': admin,
              }
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
              child: CachedNetworkImage(
                memCacheHeight: 3000,
                memCacheWidth: 3000,
                fadeOutDuration: Duration.zero,
                placeholderFadeInDuration: Duration.zero,
                fadeInDuration: Duration.zero,
                imageUrl: article!.imageURL,
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width * 0.99,
                height: 260,
                placeholder: (context, url) => const Image(image: AssetImage('assets/skeletonImage.gif'), fit: BoxFit.cover),//Lottie.asset('assets/skeleton.json'),//SpinKitCubeGrid(color: Colors.red),
              ),
            ),
            // const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'FEATURED ${category.toUpperCase()} NEWS',
                    style: TextStyle(
                      color: NewsCategories.getCategoryColor(category, false),
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.85,
                    child: AutoSizeText(
                      article!.title,
                      minFontSize: 22,
                      maxFontSize: 22,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    DateFormat.yMMMMd('en_US').format(DateTime.parse(article!.date)),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ],
        ),
      ),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.175), //0.35
              spreadRadius: 0,
              blurRadius: 30,
              offset: const Offset(0, 4),
            )
          ]
      ),
    );
  }
}
