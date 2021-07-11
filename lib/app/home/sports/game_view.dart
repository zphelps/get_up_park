import 'package:flutter/material.dart';
import 'package:get_up_park/app/home/groups/group_model.dart';
import 'package:get_up_park/app/home/news/widgets/news_vertical_scroll_widget.dart';
import 'package:get_up_park/app/home/sports/cards/game_info_card.dart';
import 'package:get_up_park/app/home/sports/game_model.dart';
import 'package:get_up_park/routing/app_router.dart';

class GameView extends StatefulWidget {
  const GameView({required this.game, required this.admin, required this.group});

  final Game game;
  final String admin;
  final Group group;

  @override
  _GameViewState createState() => _GameViewState();
}

class _GameViewState extends State<GameView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        brightness: Brightness.light,
        elevation: 1,
        title: Text(
          'Panthers v.s. ${widget.game.opponentName}',
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        actions: [
              () {
            if(widget.admin == 'true') {
              return IconButton(
                padding: const EdgeInsets.only(right: 16),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pushNamed(
                      AppRoutes.updateGameView,
                      arguments: {
                        'game': widget.game,
                        'group': widget.group,
                      }
                  );
                },
                icon: const Icon(
                    Icons.add_circle_outline
                ),
              );
            }
            return const SizedBox(width: 0);
          }(),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GameInfoCard(game: widget.game),
            const Divider(height: 0, thickness: 0.8),
            const SizedBox(height: 15),
            const Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text(
                'News',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 8),
            NewsVerticalScrollWidget(admin: widget.admin, gameID: widget.game.id),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
