import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_up_park/app/home/groups/group_model.dart';
import 'package:get_up_park/app/home/sports/game_model.dart';
import 'package:intl/intl.dart';

class SelectGameTile extends StatelessWidget {

  final Game game;

  const SelectGameTile({required this.game});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        HapticFeedback.heavyImpact();
        Navigator.pop(context, {
          'gameID': game.id,
          'opponentLogoURL': game.opponentLogoURL,
          'opponentName': game.opponentName,
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 6),
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Image(
                      image: AssetImage('assets/pantherHead.png'),
                      fit: BoxFit.fitWidth,
                      height: 25,
                      width: 25,
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'Panthers',
                      style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
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
                    Text(
                      game.opponentName,
                      style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 14
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Spacer(),
            Container(height: 50, width: 0.25, color: Colors.grey[400],),
            const SizedBox(width: 5),
            Container(
              width: MediaQuery.of(context).size.width * 0.175,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${DateFormat.E('en_US').format(DateTime.parse(game.date))} ${DateFormat.Md('en_US').format(DateTime.parse(game.date))}',
                    style: TextStyle(
                      color: Colors.grey[800],
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    DateFormat.jm('en_US').format(DateTime.parse(game.date)),
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
          ],
        ),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 24,
                offset: const Offset(0, 2), // changes position of shadow
              ),
            ]
        ),
      ),
    );
  }
}
