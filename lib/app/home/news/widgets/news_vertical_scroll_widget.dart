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
import 'package:get_up_park/app/home/news/cards/score_post_card.dart';
import 'package:get_up_park/app/home/sports/game_model.dart';
import 'package:get_up_park/app/user_model.dart';
import 'package:get_up_park/shared_widgets/loading.dart';
import 'package:get_up_park/app/top_level_providers.dart';

// watch database
class NewsVerticalScrollWidget extends ConsumerWidget {

  const NewsVerticalScrollWidget({this.category = 'all', this.group = 'none', required this.user, this.gameID = '', this.groupsFollowing = const []});

  final String category;
  final String group;
  final PTUser user;
  final String gameID;
  final List<dynamic> groupsFollowing;

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final articleAsyncValue = watch(articleStreamProvider);
    final groupAsyncValue = watch(groupsStreamProvider);
    final gamesAsyncValue = watch(gamesStreamProvider);
    return Container(color: Colors.white,child: SortNews(articleAsyncValue: articleAsyncValue, groupAsyncValue: groupAsyncValue, gamesAsyncValue: gamesAsyncValue, group: group, category: category, user: user, gameID: gameID, groupsFollowing: groupsFollowing,));
  }

}

class SortNews extends StatefulWidget {
  const SortNews({required this.articleAsyncValue, required this.groupAsyncValue, required this.gamesAsyncValue, required this.group, required this.category, required this.user, required this.gameID, required this.groupsFollowing});

  final AsyncValue<List<Article>> articleAsyncValue;
  final AsyncValue<List<Group>> groupAsyncValue;
  final AsyncValue<List<Game>> gamesAsyncValue;
  final String group;
  final String category;
  final PTUser user;
  final String gameID;
  final List<dynamic> groupsFollowing;

  @override
  _SortNewsState createState() => _SortNewsState();
}

class _SortNewsState extends State<SortNews> {

  bool sortingData = true;

  Timer? _timer;

  List<Article> filteredNews = [];

  List<Group> allGroups = [];

  List<Game> allGames = [];

  List<Article> lastNews = [];

  List<dynamic> lastGroupsFollowing = [];

  String lastCategory = '';

  @override
  void dispose() {
    super.dispose();
    _timer!.cancel();
  }

  @override
  Widget build(BuildContext context) {
    print('building');
    widget.articleAsyncValue.whenData((articles) async {
      if((lastNews != articles && widget.category == 'all' && widget.group == 'none' && widget.gameID == '') || lastCategory != widget.category || widget.groupsFollowing.length != lastGroupsFollowing.length) {
        filteredNews.clear();
        for (Article article in articles) {
          print('in news loop');
          if(widget.groupsFollowing.isNotEmpty) {
            if(widget.groupsFollowing.contains(article.group)) {
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
          }
          else {
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

        }

        lastCategory = widget.category;
        lastNews = articles;
        lastGroupsFollowing = widget.groupsFollowing;

        _timer = Timer(const Duration(milliseconds: 300), //600
                () {
              setState(() {
                sortingData = false;
              });
              _timer!.cancel();
            });
      }
      widget.groupAsyncValue.whenData((groups) {
        print('loading groups');
        if(allGroups != groups) {
          allGroups = groups;
        }
      });
      widget.gamesAsyncValue.whenData((games) {
        print('loading games');
        if(allGames != games) {
          allGames = games;
        }
      });
    });


    if(sortingData) {
      return const LoadingGroupsScroll();
    }
    else if(filteredNews.isEmpty) {
      if(widget.gameID != '') {
        return Column(
          children: [
            const SizedBox(height: 35,),
            EmptyContent(title: 'No Game Updates Found', message: 'All news from this game will appear here.',center: true,),
          ],
        );
      }
      return EmptyContent(title: 'No news found', message: 'Only news from groups you follow will appear in your feed.',center: true,);
    }

    return ListView.builder(
        padding: const EdgeInsets.fromLTRB(0, 4, 0, 10), //8
        itemCount: filteredNews.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        // separatorBuilder: (context, index) {
        //   return Divider(height: 0, thickness: 1, color: Colors.grey[300],);
        // },
        itemBuilder: (context, index) {
          for(Group g in allGroups) {
            if(g.name == filteredNews[index].group && (filteredNews[index].gameDone != 'false' || widget.gameID != '')) {
              if(filteredNews[index].gameID != '') {
                for(Game game in allGames) {
                  if(game.id == filteredNews[index].gameID && filteredNews[index].gameDone == 'true') {
                    return ScorePostCard(article: filteredNews[index], user: widget.user, group: g, game: game);
                  }
                }
              }
              if(filteredNews[index].imageURL.isEmpty && filteredNews[index].title.isEmpty) {
                return PostCard(article: filteredNews[index], user: widget.user, group: g);
              }
              else if(filteredNews[index].title.isEmpty) {
                return ImagePostCard(article: filteredNews[index], user: widget.user, group: g);
              }
              return NewsCard(article: filteredNews[index], user: widget.user);
            }
          }
          return const SizedBox(width: 0);
        }
    );

    // return widget.groupAsyncValue.when(
    //   data: (groups) {
    //     return ListView.separated(
    //         padding: const EdgeInsets.fromLTRB(0, 0, 0, 10), //8
    //         itemCount: filteredNews.length,
    //         shrinkWrap: true,
    //         physics: const NeverScrollableScrollPhysics(),
    //         separatorBuilder: (context, index) {
    //           return Divider(height: 0, thickness: 1, color: Colors.grey[300],);
    //         },
    //         itemBuilder: (context, index) {
    //           for(Group g in groups) {
    //             if(g.name == filteredNews[index].group) {
    //               if(filteredNews[index].gameID != '') {
    //                 return ScorePostCard(article: article, admin: admin, group: group)
    //               }
    //               if(filteredNews[index].imageURL.isEmpty && filteredNews[index].title.isEmpty) {
    //                 return PostCard(article: filteredNews[index], admin: widget.admin, group: g);
    //               }
    //               else if(filteredNews[index].title.isEmpty) {
    //                 return ImagePostCard(article: filteredNews[index], admin: widget.admin, group: g);
    //               }
    //               return NewsCard(article: filteredNews[index], admin: widget.admin);
    //             }
    //           }
    //           return const SizedBox(width: 0);
    //         }
    //     );
    //   },
    //   loading: () {
    //     return const LoadingEventsScroll();
    //   },
    //   error: (_, __) => Center(
    //     heightFactor: 5,
    //     child: EmptyContent(
    //       title: 'Something went wrong',
    //       message: context.toString(),
    //     ),
    //   ),
    // );
  }
}
