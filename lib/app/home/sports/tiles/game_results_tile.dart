import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get_up_park/app/home/groups/group_model.dart';
import 'package:get_up_park/app/home/sports/game_model.dart';
import 'package:get_up_park/routing/app_router.dart';
import 'package:intl/intl.dart';

class GameResultsTile extends StatelessWidget {
  const GameResultsTile({required this.game, required this.admin, required this.group});

  final Game game;
  final Group group;
  final String admin;

  @override
  Widget build(BuildContext context) {
    return Slidable(
      movementDuration: const Duration(milliseconds: 75),
      actionPane: const SlidableStrechActionPane(),
      actionExtentRatio: 0.25,
      secondaryActions: () {
        if (admin == 'true') {
          return <Widget>[
            IconSlideAction(
              caption: 'Edit Game',
              color: Colors.black45,
              icon: Icons.edit_rounded,
              onTap: () {
                Navigator.of(context, rootNavigator: true).pushNamed(
                    AppRoutes.editGameView,
                    arguments: {
                      'game': game,
                    }
                );
              },
            ),
            IconSlideAction(
              caption: 'Delete',
              color: Colors.red,
              icon: Icons.delete,
              onTap: () => print('Delete'),
            ),
          ];
        }
        return <Widget>[];
      }(),
      child: InkWell(
        onTap: () {
          Navigator.of(context, rootNavigator: true).pushNamed(
              AppRoutes.gameView,
              arguments: {
                'game': game,
                'admin': admin,
                'group': group,
              }
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          child: Row(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.155,
                decoration: BoxDecoration(
                  border: Border(
                    right: BorderSide(color: Colors.grey.shade300, width: 0.75)
                  )
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${DateFormat.E('en_US').format(DateTime.parse(game.date))}, ${DateFormat.Md('en_US').format(DateTime.parse(game.date))}',
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      DateFormat.jm('en_US').format(DateTime.parse(game.date)),
                      style: TextStyle(
                        color: Colors.grey.shade900,
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: CachedNetworkImage(
                  fadeOutDuration: Duration.zero,
                  placeholderFadeInDuration: Duration.zero,
                  fadeInDuration: Duration.zero,
                  memCacheHeight: 100,
                  memCacheWidth: 100,
                  imageUrl: game.opponentLogoURL,
                  fit: BoxFit.fitWidth,
                  width: 30,
                  height: 30,
                  placeholder: (context, url) => const Image(image: AssetImage('assets/skeletonImage.gif'), fit: BoxFit.cover),//Lottie.asset('assets/skeleton.json'),//SpinKitCubeGrid(color: Colors.red),
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.39,
                child: AutoSizeText(
                  game.opponentName,
                  style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 14
                  ),
                  minFontSize: 14,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Spacer(),
              const SizedBox(width: 6),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    game.gameDone == 'true' ? 'Final' : '•Live',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                      color: game.gameDone == 'true' ? Colors.black : Colors.green,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      () {
                        if(game.gameDone == 'true') {
                          return Text(
                            int.parse(game.opponentScore) > int.parse(game.homeScore) ? 'L' : 'W',
                            style: TextStyle(
                                color: int.parse(game.opponentScore) > int.parse(game.homeScore) ? Colors.red : Colors.green,
                                fontWeight: FontWeight.w600,
                                fontSize: 12
                            ),
                          );
                        }
                        else {
                          return const SizedBox(height: 0);
                        }
                      }(),
                      const SizedBox(width: 6),
                      Text(
                        '${game.homeScore}-${game.opponentScore}',
                        style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 15
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
