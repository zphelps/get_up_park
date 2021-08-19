import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_up_park/app/announcements/empty_content.dart';
import 'package:get_up_park/app/home/groups/group_model.dart';
import 'package:get_up_park/app/home/news/create_article/select_game_tile.dart';
import 'package:get_up_park/app/home/sports/game_model.dart';
import 'package:get_up_park/app/home/sports/tiles/game_result_post_tile.dart';
import 'package:get_up_park/app/home/sports/tiles/game_schedule_tile.dart';
import 'package:get_up_park/app/top_level_providers.dart';
import 'package:get_up_park/app/user_model.dart';

// watch database
class GameScheduleListWidget extends ConsumerWidget {

  GameScheduleListWidget({this.groupName = 'all', required this.group, this.past = false, this.date = '', this.itemCount = 0, required this.user, required this.selectGame});

  final String groupName;
  final Group group;
  final bool past;
  final int itemCount;
  final String date;
  final PTUser user;
  final bool selectGame;

  @override
  Widget build(BuildContext context, ScopedReader watch) {



    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: _buildContents(context, watch),
    );
    //print(user.uid);
  }

  Widget _buildContents(BuildContext context, ScopedReader watch) {
    final gamesAsyncValue = watch(gamesStreamProvider);
    List<Game> filteredGames = [];
    gamesAsyncValue.whenData((games) {
      for(Game game in games) {
        if(past) {
          if(game.group == group.name && game.gameDone == 'true') {
            filteredGames.add(game);
          }
          // else if(game.group == group.name && DateTime.parse(game.date).isBefore(DateTime.now())) {
          //   filteredGames.add(game);
          // }
        }
        else {
          if(game.group == group.name) {
            filteredGames.add(game);
          }
          // else if(game.group == group.name && DateTime.parse(game.date).isAfter(DateTime.now())) {
          //   filteredGames.add(game);
          // }
        }
        // if(game.group == group.name && game.homeScore.isEmpty && game.opponentScore.isEmpty) {
        //   filteredGames.add(game);
        // }
      }
    });

    if(filteredGames.isEmpty && !selectGame) {
      return Center(child: EmptyContent(title: 'No ${group.name} results found', message: 'Check back later.',));
    }

    return ListView.separated(
      padding: EdgeInsets.zero,
      scrollDirection: Axis.vertical,
      itemCount: itemCount == 0 ? filteredGames.length : itemCount,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      separatorBuilder: (context, index) {
        return const Divider(height: 0);
      },
      itemBuilder: (context, index) {
        if(selectGame) {
          return SelectGameTile(game: filteredGames[index]);
        }
        else {
          if(past) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: GameResultPostTile(game: filteredGames[index], user: user, group: group),
            );
          }
          return GameScheduleTile(game: filteredGames[index], user: user, group: group);
        }
      },
    );
  }
}