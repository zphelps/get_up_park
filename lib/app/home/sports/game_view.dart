import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_up_park/app/announcements/empty_content.dart';
import 'package:get_up_park/app/home/events/event_model.dart';
import 'package:get_up_park/app/home/groups/group_model.dart';
import 'package:get_up_park/app/home/news/widgets/news_vertical_scroll_widget.dart';
import 'package:get_up_park/app/home/sports/cards/game_info_card.dart';
import 'package:get_up_park/app/home/sports/game_model.dart';
import 'package:get_up_park/app/top_level_providers.dart';
import 'package:get_up_park/routing/app_router.dart';
import 'package:get_up_park/services/firestore_database.dart';
import 'package:get_up_park/shared_widgets/loading.dart';
import 'package:intl/intl.dart';

final eventsStreamProvider = StreamProvider.autoDispose<List<Event>>((ref) {
  final database = ref.watch(databaseProvider);
  return database.eventsStream();
});

final groupsStreamProvider = StreamProvider.autoDispose<List<Group>>((ref) {
  final database = ref.watch(databaseProvider);
  return database.groupsStream();
});

final gamesStreamProvider = StreamProvider.autoDispose<List<Game>>((ref) {
  final database = ref.watch(databaseProvider);
  return database.gamesStream();
});

class GameView extends ConsumerWidget {
  const GameView({required this.admin, required this.gameID});

  final String admin;
  final String gameID;


  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final groupAsyncValue = watch(groupsStreamProvider);

    return LoadGameView(groupAsyncValue: groupAsyncValue, admin: admin, gameID: gameID);

  }
}

class LoadGameView extends StatefulWidget {
  const LoadGameView({required this.groupAsyncValue, required this.admin, required this.gameID});

  final AsyncValue<List<Group>> groupAsyncValue;
  final String admin;
  final String gameID;

  @override
  _LoadGameViewState createState() => _LoadGameViewState();
}

class _LoadGameViewState extends State<LoadGameView> {

  bool sortingData = true;

  Timer? _timer;

  List<Group> allGroups = [];

  Event? _event;
  Game? _game;

  Future<void> getData(String gameID) async {
    final _database = FirebaseFirestore.instance;
    _game = await _database.collection('games').doc(gameID).get().then((value) => Game.fromMap(value.data(), value.id));
    _event = await _database.collection('events').doc(gameID).get().then((value) => Event.fromMap(value.data(), value.id));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _timer!.cancel();
  }

  @override
  Widget build(BuildContext context) {
    print('rebuilding');


    if(sortingData) {
      widget.groupAsyncValue.whenData((groups) async {
        await getData(widget.gameID);

        _timer = Timer(const Duration(milliseconds: 150),
                () {
              setState(() {
                sortingData = false;
              });
              _timer!.cancel();
            });
      });
      return Scaffold(
        appBar: AppBar(
          brightness: Brightness.light,
          elevation: 1,
          title: const Text(
            'Loading Game...',
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(
            color: Colors.black,
          ),
        ),
        body: const LoadingGroupsScroll(),
      );
    }
    // else if(filteredNews.isEmpty) {
    //   return EmptyContent(title: 'No news found', message: 'Check back later.',center: true,);
    // }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        brightness: Brightness.light,
        elevation: 1,
        title: Text(
          'Panthers v.s. ${_game!.opponentName}',
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
            if(widget.admin == 'Admin' || widget.admin == 'Student Admin' || widget.admin == 'Score Reporter') {
              return Padding(
                padding: const EdgeInsets.only(right: 10),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  //radius: 20,
                  child: PopupMenuButton(
                    icon: const Icon(
                      Icons.more_horiz_outlined,
                      color: Colors.black,
                    ),
                    //color: Colors.black,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15.0))
                    ),
                    itemBuilder: (BuildContext bc) {
                      if(widget.admin == 'Admin' || widget.admin == 'Student Admin') {
                        return [
                          const PopupMenuItem(child: Text("Post Update"), value: "post-update"),
                          const PopupMenuItem(child: Text("Report Score"), value: "report-score"),
                          const PopupMenuItem(child: Text("Delete"), value: "delete"),
                        ];
                      }
                      else {
                        return [
                          const PopupMenuItem(child: Text("Post Update"), value: "post-update"),
                          const PopupMenuItem(child: Text("Report Score"), value: "report-score"),
                        ];
                      }
                    },
                    onSelected: (value) async {
                      print(value);
                      if(value == 'delete') {
                        showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: const Text('Are you sure?'),
                            content: const Text('Once deleted, you will not be able to recover this event.'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () async {
                                  final database = context.read<FirestoreDatabase>(databaseProvider);
                                  await database.deleteEvent(_event!);
                                  await database.deleteGame(_game!);
                                  Navigator.of(context).popUntil((route) => !route.hasActiveRouteBelow);
                                },
                                child: const Text(
                                  'Delete',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      else if(value == 'post-update') {
                        await Navigator.of(context, rootNavigator: true).pushNamed(
                            AppRoutes.postGameUpdateView,
                            arguments: {
                              'groupLogoURL': _event!.groupImageURL,
                              'game': _game!,
                            }
                        );
                        setState(() {
                          sortingData = true;
                        });
                      }
                      else if(value == 'report-score') {
                        await Navigator.of(context, rootNavigator: true).pushNamed(
                            AppRoutes.updateGameView,
                            arguments: {
                              'event': _event!,
                              'game': _game!,
                            }
                        );
                        setState(() {
                          sortingData = true;
                        });
                      }
                    },
                  ),
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
            GameInfoCard(game: _game!),
            const Divider(height: 0, thickness: 0.8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    dense:true,
                    visualDensity: const VisualDensity(vertical: 0),
                    contentPadding: EdgeInsets.zero,
                    minVerticalPadding: 0,
                    horizontalTitleGap: 0,
                    leading: const Icon(
                      Icons.place_outlined,
                      color: Colors.black,
                    ),
                    title: const Text(
                      'Location',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black
                      ),
                    ),
                    subtitle: Text(
                      _event!.location,
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: Colors.black
                      ),
                    ),
                  ),
                  const Divider(
                    height: 0,
                    thickness: 0.75,
                  ),
                  ListTile(
                    dense:true,
                    visualDensity: const VisualDensity(vertical: 0),
                    contentPadding: EdgeInsets.zero,
                    minVerticalPadding: 0,
                    horizontalTitleGap: 0,
                    leading: const Icon(
                      Icons.access_time_sharp,
                      color: Colors.black,
                    ),
                    title: const Text(
                      'Date',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black
                      ),
                    ),
                    subtitle: Text(
                      '${DateFormat.yMMMMEEEEd().format(DateTime.parse(_event!.date))} at ${DateFormat.jm().format(DateTime.parse(_event!.date))}',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: Colors.black
                      ),
                    ),
                  ),
                  const Divider(
                    height: 0,
                    thickness: 0.75,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'About this event:',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    _event!.description,
                    style: TextStyle(
                      height: 1.3,
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Divider(
                    height: 0,
                    thickness: 0.85,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Group:',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                  // const SizedBox(height: 5),
                  ListTile(
                    onTap: () {
                      Navigator.of(context, rootNavigator: true).pushNamed(
                          AppRoutes.groupView,
                          arguments: {
                            'group':  FirestoreDatabase.getGroupFromString(widget.groupAsyncValue, _event!.group),
                          }
                      );
                    },
                    minVerticalPadding: 0,
                    horizontalTitleGap: 10,
                    contentPadding: const EdgeInsets.only(right: 5),
                    leading: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: CachedNetworkImage(
                          memCacheHeight: 200,
                          memCacheWidth: 200,
                          imageUrl: _event!.groupImageURL,
                          fadeInDuration: Duration.zero,
                          placeholderFadeInDuration: Duration.zero,
                          fadeOutDuration: Duration.zero,
                          fit: BoxFit.fitHeight,
                          width: 35,
                          height: 35,
                          placeholder: (context, url) => const Image(image: AssetImage('assets/skeletonImage.gif'), fit: BoxFit.cover),//Lottie.asset('assets/skeleton.json'),//SpinKitCubeGrid(color: Colors.red),
                        ),
                      ),
                    ),
                    title: Text(
                      _event!.group,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    trailing: Icon(
                      Icons.chevron_right,
                      color: Colors.grey[800],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(
              height: 5,
              thickness: 0.75,
            ),
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.only(left: 15),
              child: Text(
                'Related News',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
              ),
            ),
            const SizedBox(height: 8),
            NewsVerticalScrollWidget(admin: widget.admin, gameID: _game!.id),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}

// class GameView extends StatefulWidget {
//   const GameView({required this.admin, required this.gameID});
//
//   final String admin;
//   final String gameID;
//
//   @override
//   _GameViewState createState() => _GameViewState();
// }
//
// class _GameViewState extends State<GameView> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         brightness: Brightness.light,
//         elevation: 1,
//         title: Text(
//           'Panthers v.s. ${widget.game.opponentName}',
//           style: const TextStyle(
//             color: Colors.black,
//             fontSize: 16,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//         backgroundColor: Colors.white,
//         iconTheme: const IconThemeData(
//           color: Colors.black,
//         ),
//         actions: [
//               () {
//             if(widget.admin == 'true') {
//               return IconButton(
//                 padding: const EdgeInsets.only(right: 16),
//                 onPressed: () {
//                   Navigator.of(context, rootNavigator: true).pushNamed(
//                       AppRoutes.updateGameView,
//                       arguments: {
//                         'game': widget.game,
//                         'group': widget.group,
//                       }
//                   );
//                 },
//                 icon: const Icon(
//                     Icons.add_circle_outline
//                 ),
//               );
//             }
//             return const SizedBox(width: 0);
//           }(),
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             GameInfoCard(game: widget.game),
//             const Divider(height: 0, thickness: 0.8),
//             const SizedBox(height: 15),
//             const Padding(
//               padding: EdgeInsets.only(left: 10),
//               child: Text(
//                 'News',
//                 style: TextStyle(
//                   color: Colors.black,
//                   fontSize: 20,
//                   fontWeight: FontWeight.w700,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 8),
//             NewsVerticalScrollWidget(admin: widget.admin, gameID: widget.game.id),
//             const SizedBox(height: 50),
//           ],
//         ),
//       ),
//     );
//   }
// }
