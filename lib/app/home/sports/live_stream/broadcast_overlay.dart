import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_up_park/app/announcements/empty_content.dart';
import 'package:get_up_park/app/home/events/event_model.dart';
import 'package:get_up_park/app/home/sports/game_model.dart';
import 'package:get_up_park/app/home/sports/update_game/post_game_update_view.dart';
import 'package:get_up_park/app/home/sports/update_game/update_game_score_view.dart';
import 'package:get_up_park/app/top_level_providers.dart';
import 'package:google_fonts/google_fonts.dart';

final gamesStreamProvider = StreamProvider.autoDispose<List<Game>>((ref) {
  final database = ref.watch(databaseProvider);
  return database.gamesStream();
});

class GameScoreOverlay extends ConsumerWidget {

  GameScoreOverlay({required this.gameID, required this.isBroadcaster, required this.event});

  final String gameID;
  final bool isBroadcaster;
  final Event event;

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final gamesAsyncValue = watch(gamesStreamProvider);
    return gamesAsyncValue.when(
      data: (games) {
        for(Game game in games) {
          if(game.id == gameID) {
            return Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.95,
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.black.withOpacity(0.5),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color: Colors.white
                                  ),
                                  child: const Image(
                                    image: AssetImage('assets/pantherHeadLowRes.png'),
                                    width: 15,
                                    height: 15,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Park Tudor',
                                  style: GoogleFonts.inter(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              game.homeScore == '' ? '0' : game.homeScore,
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      color: Colors.white
                                  ),
                                  child: CachedNetworkImage(
                                    memCacheHeight: 200,
                                    memCacheWidth: 200,
                                    imageUrl: game.opponentLogoURL,
                                    fadeInDuration: Duration.zero,
                                    placeholderFadeInDuration: Duration.zero,
                                    fadeOutDuration: Duration.zero,
                                    fit: BoxFit.fitHeight,
                                    width: 15,
                                    height: 15,
                                    placeholder: (context, url) => const Image(image: AssetImage('assets/skeletonImage.gif'), fit: BoxFit.cover),//Lottie.asset('assets/skeleton.json'),//SpinKitCubeGrid(color: Colors.red),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  game.opponentName,
                                  style: GoogleFonts.inter(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              game.opponentScore == '' ? '0' : game.opponentScore,
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                        () {
                          if(isBroadcaster) {
                            return Column(
                              children: [
                                const SizedBox(height: 6),
                                const Divider(color: Colors.white),
                                const SizedBox(height: 6),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.sports_outlined,
                                      size: 15,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(width: 5),
                                    InkWell(
                                      onTap: () {
                                        showModalBottomSheet<void>(
                                          context: context,
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                          builder: (BuildContext context) {
                                            return UpdateGameScoreView(game: game, event: event,);
                                          },
                                        );
                                      },
                                      child: Text(
                                        'Report Score',
                                        style: GoogleFonts.inter(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 35),
                                    const Icon(
                                      Icons.edit_outlined,
                                      size: 15,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(width: 5),
                                    InkWell(
                                      onTap: () {
                                        showModalBottomSheet<void>(
                                          context: context,
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                          builder: (BuildContext context) {
                                            return PostGameUpdateView(game: game, groupLogoURL: event.groupImageURL,);
                                          },
                                        );
                                      },
                                      child: Text(
                                          'Post Update',
                                        style: GoogleFonts.inter(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                              ],
                            );
                          }
                          return const SizedBox(height: 0);
                        }(),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
        }
        return EmptyContent(message: 'Could not find game data.',);

      },
      loading: () {
        return Container(color: Colors.black);
      },
      error: (_,__) {
        return EmptyContent(message: 'Error loading stream data',);
      },
    );

  }

}

class UserCountOverlay extends ConsumerWidget {

  UserCountOverlay({required this.gameID});

  final String gameID;

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final gamesAsyncValue = watch(gamesStreamProvider);
    return gamesAsyncValue.when(
      data: (games) {
        for(Game game in games) {
          if (game.id == gameID) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.black.withOpacity(0.25),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.person,
                    size: 15,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 3),
                  Text(
                    '${game.numberOfLiveUsers}',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            );
          }
        }
        return EmptyContent(message: 'Error loading stream data',);
      },
      loading: () {
        return Container(color: Colors.black);
      },
      error: (_,__) {
        return EmptyContent(message: 'Error loading stream data',);
      },
    );

  }

}