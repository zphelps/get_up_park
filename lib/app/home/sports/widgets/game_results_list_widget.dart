import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_up_park/app/announcements/empty_content.dart';
import 'package:get_up_park/app/home/groups/group_model.dart';
import 'package:get_up_park/app/home/sports/game_model.dart';
import 'package:get_up_park/app/home/sports/tiles/game_results_tile.dart';
import 'package:get_up_park/app/top_level_providers.dart';

final gamesStreamProvider = StreamProvider.autoDispose<List<Game>>((ref) {
  final database = ref.watch(databaseProvider);
  return database.gamesStream();
});

// watch database
class GameResultsListWidget extends ConsumerWidget {

  GameResultsListWidget({this.groupName = 'all', required this.group, this.past = false, this.date = '', this.itemCount = 0, required this.admin});

  final String groupName;
  final Group group;
  final bool past;
  final int itemCount;
  final String date;
  final String admin;

  int lastGamesLength = 0;

  List<Game> filteredGames = [];

  @override
  Widget build(BuildContext context, ScopedReader watch) {

    final gamesAsyncValue = watch(gamesStreamProvider);

    return LoadGameResults(gamesAsyncValue: gamesAsyncValue, groupName: groupName, group: group, itemCount: itemCount, admin: admin);
  }
}

class LoadGameResults extends StatefulWidget {
  const LoadGameResults({required this.gamesAsyncValue, required this.groupName, required this.group, required this.itemCount, required this.admin});

  final AsyncValue<List<Game>> gamesAsyncValue;
  final String groupName;
  final Group group;
  final int itemCount;
  final String admin;

  @override
  _LoadGameResultsState createState() => _LoadGameResultsState();
}

class _LoadGameResultsState extends State<LoadGameResults> {

  List<Game> filteredGames = [];

  List<Game> lastGames = [];

  @override
  Widget build(BuildContext context) {
    widget.gamesAsyncValue.whenData((games) async {
      if(lastGames != games) {
        filteredGames.clear();
        for(Game game in games) {
          print('Loading Game Results List');
          if(game.group == widget.groupName && game.homeScore.isNotEmpty && game.opponentScore.isNotEmpty) {
            filteredGames.add(game);
          }
        }
        setState(() {
          lastGames = games;
        });
      }
    });

    if(filteredGames.isEmpty) {
      return EmptyContent(title: 'No ${widget.group.name} results found', message: 'Check back later.',);
    }
    return ListView.builder(
      padding: EdgeInsets.zero,
      scrollDirection: Axis.vertical,
      itemCount: widget.itemCount != 0 && widget.itemCount < filteredGames.length ? widget.itemCount : filteredGames.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Column(
          children: [
            const Divider(height: 0),
            GameResultsTile(game: filteredGames[index], admin: widget.admin, group: widget.group),
          ],
        );
      },
    );
  }
}
