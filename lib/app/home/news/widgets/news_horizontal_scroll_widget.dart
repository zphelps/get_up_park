import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_up_park/app/home/news/article_model.dart';
import 'package:get_up_park/app/home/news/cards/small_news_card.dart';
import 'package:get_up_park/shared_widgets/horizontal_list_builder.dart';
import 'package:get_up_park/app/top_level_providers.dart';

final articleStreamProvider = StreamProvider.autoDispose<List<Article>>((ref) {
  final database = ref.watch(databaseProvider);
  return database.articleStream();
});

// watch database
class NewsHorizontalScrollWidget extends ConsumerWidget {

  NewsHorizontalScrollWidget({required this.admin, this.category = 'all', this.group = 'none', this.excludedArticleID = 'none'});

  final String category;
  final String group;
  final String excludedArticleID;
  final String admin;

  @override
  Widget build(BuildContext context, ScopedReader watch) {

    return Column(
      children: [
        //const SizedBox(height: 15),
        SizedBox(
          height: 260,
          width: MediaQuery.of(context).size.width,
          child: _buildContents(context, watch)
        ),
      ],
    );
    //print(user.uid);
  }

  Widget _buildContents(BuildContext context, ScopedReader watch) {
    final articleAsyncValue = watch(articleStreamProvider);
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: HorizontalListBuilder<Article>(
        data: articleAsyncValue,
        itemBuilder: (context, article) {
          if(category == 'all' && group == 'none' && excludedArticleID != article.id) {
            if(article.imageURL.isNotEmpty && article.title.isNotEmpty) {
              return SmallNewsCard(admin: admin, article: article);
            }
          }
          else if(group != 'none' && excludedArticleID != article.id) {
            if(article.group == group) {
              if(article.imageURL.isNotEmpty && article.title.isNotEmpty) {
                return SmallNewsCard(admin: admin, article: article);
              }
            }
          }
          else if(category != 'all' && excludedArticleID != article.id) {
            if(article.category == category) {
              if(article.imageURL.isNotEmpty && article.title.isNotEmpty) {
                return SmallNewsCard(admin: admin, article: article);
              }
            }
          }
          return const SizedBox(width: 0);
        }
      ),
    );
  }
}