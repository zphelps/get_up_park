import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get_up_park/app/home/sports/game_model.dart';
import 'package:intl/intl.dart';

class GameInfoCard extends StatelessWidget {
  const GameInfoCard({required this.game});

  final Game game;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Image(
            image: AssetImage('assets/pantherHead.png'),
            fit: BoxFit.fitHeight,
            height: 45,
            width: 45,
          ),
          Text(
            game.homeScore == '' ? '-' : game.homeScore,
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          Column(
            children: [
              Text(
                () {
                  if(game.gameDone == 'true') {
                    return 'FINAL';
                  }
                  else if(game.homeScore == '' && game.opponentScore == '') {
                    return 'Scheduled';
                  }
                  else {
                    return '•Live';
                  }
                }(),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: game.gameDone == 'true' ? Colors.black : Colors.green,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                '${DateFormat.E('en_US').format(DateTime.parse(game.date))} ${DateFormat.Md('en_US').format(DateTime.parse(game.date))}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '@ ${DateFormat.jm('en_US').format(DateTime.parse(game.date))}',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          Text(
            game.opponentScore == '' ? '-' : game.opponentScore,
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
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
              width: 50,
              height: 50,
              placeholder: (context, url) => const Image(image: AssetImage('assets/skeletonImage.gif'), fit: BoxFit.cover),//Lottie.asset('assets/skeleton.json'),//SpinKitCubeGrid(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
