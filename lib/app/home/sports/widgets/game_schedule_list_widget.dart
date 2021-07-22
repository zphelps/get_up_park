import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_up_park/app/announcements/empty_content.dart';
import 'package:get_up_park/app/home/groups/group_model.dart';
import 'package:get_up_park/app/home/news/create_article/select_game_tile.dart';
import 'package:get_up_park/app/home/sports/game_model.dart';
import 'package:get_up_park/app/home/sports/tiles/game_schedule_tile.dart';
import 'package:get_up_park/app/top_level_providers.dart';

final gamesStreamProvider = StreamProvider.autoDispose<List<Game>>((ref) {
  final database = ref.watch(databaseProvider);
  return database.gamesStream();
});

// watch database
class GameScheduleListWidget extends ConsumerWidget {

  GameScheduleListWidget({this.groupName = 'all', required this.group, this.past = false, this.date = '', this.itemCount = 0, required this.admin, required this.selectGame});

  final String groupName;
  final Group group;
  final bool past;
  final int itemCount;
  final String date;
  final String admin;
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
        if(game.group == group.name && game.homeScore.isEmpty && game.opponentScore.isEmpty) {
          filteredGames.add(game);
        }
      }
    });

    if(filteredGames.isEmpty && !selectGame) {
      return Center(child: EmptyContent(title: 'No ${group.name} results found', message: 'Check back later.',));
    }

    return ListView.builder(
      padding: EdgeInsets.zero,
      scrollDirection: Axis.vertical,
      itemCount: itemCount == 0 ? filteredGames.length : itemCount,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Column(
          children: [
            const Divider(height: 0, thickness: 0.75),
            () {
              if(selectGame) {
                return SelectGameTile(game: filteredGames[index]);
              }
              else {
                return GameScheduleTile(game: filteredGames[index], admin: admin, group: group);
              }
            }(),
          ],
        );
      },
    );
  }
}