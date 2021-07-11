import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_up_park/app/announcements/empty_content.dart';
import 'package:get_up_park/app/home/groups/group_model.dart';
import 'package:get_up_park/app/home/news/article_model.dart';
import 'package:get_up_park/app/home/news/cards/image_post_card.dart';
import 'package:get_up_park/app/home/news/cards/news_card.dart';
import 'package:get_up_park/app/home/news/cards/post_card.dart';
import 'package:get_up_park/shared_widgets/loading.dart';
import 'package:get_up_park/app/top_level_providers.dart';


final articleStreamProvider = StreamProvider.autoDispose<List<Article>>((ref) {
  final database = ref.watch(databaseProvider);
  return database.articleStream();
});

final groupsStreamProvider = StreamProvider.autoDispose<List<Group>>((ref) {
  final database = ref.watch(databaseProvider);
  return database.groupsStream();
});

// watch database
class NewsVerticalScrollWidget extends ConsumerWidget {

  const NewsVerticalScrollWidget({this.category = 'all', this.group = 'none', required this.admin, this.gameID = ''});

  final String category;
  final String group;
  final String admin;
  final String gameID;

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final articleAsyncValue = watch(articleStreamProvider);
    final groupAsyncValue = watch(groupsStreamProvider);
    return Container(color: Colors.white,child: SortNews(articleAsyncValue: articleAsyncValue, groupAsyncValue: groupAsyncValue, group: group, category: category, admin: admin, gameID: gameID));
  }

}

class SortNews extends StatefulWidget {
  const SortNews({required this.articleAsyncValue, required this.groupAsyncValue, required this.group, required this.category, required this.admin, required this.gameID});

  final AsyncValue<List<Article>> articleAsyncValue;
  final AsyncValue<List<Group>> groupAsyncValue;
  final String group;
  final String category;
  final String admin;
  final String gameID;

  @override
  _SortNewsState createState() => _SortNewsState();
}

class _SortNewsState extends State<SortNews> {

  bool sortingData = true;

  Timer? _timer;

  List<Article> filteredNews = [];

  List<Article> lastNews = [];

  String lastCategory = '';

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _timer!.cancel();
  }

  @override
  Widget build(BuildContext context) {
    widget.articleAsyncValue.whenData((articles) async {
      if((filteredNews.length != articles.length && widget.category == 'all' && widget.group == 'none' && widget.gameID == '') || lastCategory != widget.category) {
        filteredNews.clear();
        setState(() {
          lastNews = articles;
        });
        for (Article article in articles) {
          print('Loading News Articles');
          if(widget.gameID != '') {
            if(article.gameID == widget.gameID) {
              filteredNews.add(article);
            }
          }
          else {
            if(widget.group != 'none' && article.group == widget.group) {
              filteredNews.add(article);
            }
            else if(widget.category != 'all' && article.category == widget.category) {
              filteredNews.add(article);
            }
            else if(widget.group == 'none' && widget.category == 'all') {
              filteredNews.add(article);
            }
          }
        }

        lastCategory = widget.category;

        _timer = Timer(const Duration(milliseconds: 200),
                () {
              setState(() {
                sortingData = false;
              });
              _timer!.cancel();
            });
      }
    });


    if(sortingData) {
      return const LoadingGroupsScroll();
    }
    else if(filteredNews.isEmpty) {
      return EmptyContent(title: 'No news found', message: 'Check back later.',center: true,);
    }

    return widget.groupAsyncValue.when(
      data: (groups) {
        return ListView.builder(
            padding: const EdgeInsets.fromLTRB(0, 8, 0, 10),
            itemCount: filteredNews.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              for(Group g in groups) {
                if(g.name == filteredNews[index].group) {
                  if(filteredNews[index].imageURL.isEmpty && filteredNews[index].title.isEmpty) {
                    return PostCard(article: filteredNews[index], admin: widget.admin, group: g);
                  }
                  else if(filteredNews[index].title.isEmpty) {
                    return ImagePostCard(article: filteredNews[index], admin: widget.admin, group: g);
                  }
                  return NewsCard(article: filteredNews[index], admin: widget.admin);
                }
              }
              return const SizedBox(width: 0);
            }
        );
      },
      loading: () {
        return const LoadingEventsScroll();
      },
      error: (_, __) => Center(
        heightFactor: 5,
        child: EmptyContent(
          title: 'Something went wrong',
          message: context.toString(),
        ),
      ),
    );
  }
}
