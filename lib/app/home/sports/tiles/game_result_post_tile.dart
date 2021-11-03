import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get_up_park/app/home/groups/group_model.dart';
import 'package:get_up_park/app/home/sports/game_model.dart';
import 'package:get_up_park/app/user_model.dart';
import 'package:get_up_park/routing/app_router.dart';
import 'package:intl/intl.dart';

class GameResultPostTile extends StatelessWidget {
  const GameResultPostTile({required this.game, required this.user, required this.group});

  final Game game;
  final PTUser user;
  final Group group;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context, rootNavigator: true).pushNamed(
            AppRoutes.gameView,
            arguments: {
              'gameID': game.id,
              'user': user,
            }
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Image(
                      image: AssetImage('assets/pantherHeadLowRes.png'),
                      fit: BoxFit.fitWidth,
                      height: 25,
                      width: 25,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Park Tudor',
                      style: TextStyle(
                          color: int.parse(game.homeScore) >= int.parse(game.opponentScore) ? Colors.black : Colors.grey[700],
                          fontWeight: int.parse(game.homeScore) >= int.parse(game.opponentScore) ? FontWeight.w700 : FontWeight.w400,
                          fontSize: 14
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: CachedNetworkImage(
                        fadeOutDuration: Duration.zero,
                        placeholderFadeInDuration: Duration.zero,
                        fadeInDuration: Duration.zero,
                        memCacheHeight: 300,
                        memCacheWidth: 300,
                        imageUrl: game.opponentLogoURL,
                        fit: BoxFit.fitWidth,
                        width: 25,
                        height: 25,
                        placeholder: (context, url) => const Image(image: AssetImage('assets/skeletonImage.gif'), fit: BoxFit.cover),//Lottie.asset('assets/skeleton.json'),//SpinKitCubeGrid(color: Colors.red),
                      ),
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: AutoSizeText(
                        game.opponentName,
                        style: TextStyle(
                            color: int.parse(game.opponentScore) >= int.parse(game.homeScore) ? Colors.black : Colors.grey[700],
                            fontWeight: int.parse(game.opponentScore) >= int.parse(game.homeScore) ? FontWeight.w700 : FontWeight.w400,
                            fontSize: 14
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Spacer(),
            Column(
              children: [
                Text(
                  game.homeScore,
                  style: TextStyle(
                      color: int.parse(game.homeScore) >= int.parse(game.opponentScore) ? Colors.black : Colors.grey[700],
                      fontWeight: int.parse(game.homeScore) >= int.parse(game.opponentScore) ? FontWeight.w700 : FontWeight.w400,
                      fontSize: 15
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  game.opponentScore,
                  style: TextStyle(
                      color: int.parse(game.opponentScore) >= int.parse(game.homeScore) ? Colors.black : Colors.grey[700],
                      fontWeight: int.parse(game.opponentScore) >= int.parse(game.homeScore) ? FontWeight.w700 : FontWeight.w400,
                      fontSize: 15
                  ),
                ),
              ],
            ),
            const SizedBox(width: 8),
            Container(height: 50, width: 0.25, color: Colors.grey[400],),
            const SizedBox(width: 5),
            Container(
              width: MediaQuery.of(context).size.width * 0.15,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Final',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${DateFormat.E('en_US').format(DateTime.parse(game.date))} ${DateFormat.Md('en_US').format(DateTime.parse(game.date))}',
                    style: TextStyle(
                      color: Colors.grey[800],
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
          ],
        ),
      ),
    );
  }
}
