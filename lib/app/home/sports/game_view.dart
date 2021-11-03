import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_up_park/app/announcements/empty_content.dart';
import 'package:get_up_park/app/home/events/event_model.dart';
import 'package:get_up_park/app/home/groups/group_model.dart';
import 'package:get_up_park/app/home/news/widgets/news_vertical_scroll_widget.dart';
import 'package:get_up_park/app/home/settings/user_tile.dart';
import 'package:get_up_park/app/home/sports/cards/game_info_card.dart';
import 'package:get_up_park/app/home/sports/game_model.dart';
import 'package:get_up_park/app/top_level_providers.dart';
import 'package:get_up_park/app/user_model.dart';
import 'package:get_up_park/routing/app_router.dart';
import 'package:get_up_park/services/firestore_database.dart';
import 'package:get_up_park/services/push_notifications.dart';
import 'package:get_up_park/shared_widgets/loading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

class GameView extends ConsumerWidget {
  const GameView({required this.user, required this.gameID});

  final PTUser user;
  final String gameID;


  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final groupAsyncValue = watch(groupsStreamProvider);

    return LoadGameView(groupAsyncValue: groupAsyncValue, user: user, gameID: gameID);

  }
}

class LoadGameView extends StatefulWidget {
  const LoadGameView({required this.groupAsyncValue, required this.user, required this.gameID});

  final AsyncValue<List<Group>> groupAsyncValue;
  final PTUser user;
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

  Future<void> refresh() async {
    setState(() {
      sortingData = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if(sortingData) {
      widget.groupAsyncValue.whenData((groups) async {
        await getData(widget.gameID);

        _timer = Timer(const Duration(milliseconds: 0),
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
          toolbarHeight: 50,
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(
            color: Colors.black,
          ),
        ),
        body: const LoadingGroupsScroll(),
      );
    }

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
            fontWeight: FontWeight.w800,
          ),
        ),
        toolbarHeight: 50,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        actions: [
              () {
            if(widget.user.admin == userTypes[0] || (widget.user.admin == userTypes[1] || widget.user.admin == userTypes[2] && widget.user.groupsUserCanAccess.contains(_event!.group))) {
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
                      if((widget.user.admin == userTypes[0] || widget.user.admin == userTypes[1]) && _game!.liveStreamActive != 'true') {
                        return [
                          const PopupMenuItem(child: Text("Post Update",), value: "post-update"),
                          const PopupMenuItem(child: Text("Report Score"), value: "report-score"),
                          const PopupMenuItem(child: Text("Delete"), value: "delete"),
                          const PopupMenuItem(child: Text("Start Live Stream"), value: "live"),
                        ];
                      }
                      else if(widget.user.admin == userTypes[0] || widget.user.admin == userTypes[1]) {
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
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                  // Navigator.of(context).popUntil((route) => !route.hasActiveRouteBelow);
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
                        if(DateTime.parse(_game!.date).difference(DateTime.now()) > const Duration(minutes: 30)) {
                          showDialog<String>(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) => AlertDialog(
                                contentPadding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                                actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 15),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                title: Text(
                                  "It's not game time.",
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                content: SizedBox(
                                  height: MediaQuery.of(context).size.height * 0.225,
                                  child: Column(
                                    children: [
                                      Image(
                                        image: const AssetImage('assets/notification.png'),
                                        fit: BoxFit.fitWidth,
                                        width: MediaQuery.of(context).size.width * 0.45,
                                        height: MediaQuery.of(context).size.width * 0.3,
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        "Scores cannot be reported for games that have not begun yet.",
                                        style: GoogleFonts.inter(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                actions: <Widget>[
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      InkWell(
                                        onTap: () async {
                                          Navigator.of(context).pop();
                                        },
                                        child: Container(
                                          alignment: Alignment.center,
                                          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                                          decoration: BoxDecoration(
                                            color: Colors.red,
                                            border: Border.all(color: Colors.red, width: 2),
                                            borderRadius: BorderRadius.circular(15),
                                          ),
                                          child: const Text(
                                            'OK',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w800,
                                                fontSize: 16,
                                                color: Colors.white
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              )
                          );
                        }
                        else if(_game!.gameDone == 'true') {
                          showDialog<String>(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) => AlertDialog(
                                contentPadding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                                actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 15),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                title: Text(
                                  "Final Score Already reported!",
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                content: SizedBox(
                                  height: MediaQuery.of(context).size.height * 0.26,
                                  child: Column(
                                    children: [
                                      Image(
                                        image: const AssetImage('assets/notification.png'),
                                        fit: BoxFit.fitWidth,
                                        width: MediaQuery.of(context).size.width * 0.45,
                                        height: MediaQuery.of(context).size.width * 0.3,
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        "The final score for this game has already been reported. Please check that the final score is accurate before continuing."
                                            "If the score is inaccurate, delete the incorrect game post and report the score again.",
                                        style: GoogleFonts.inter(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                actions: <Widget>[
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      InkWell(
                                        onTap: () async {
                                          await Navigator.of(context, rootNavigator: true).pushNamed(
                                              AppRoutes.updateGameView,
                                              arguments: {
                                                'event': _event!,
                                                'game': _game!,
                                              }
                                          );
                                          Navigator.of(context).pop();
                                          setState(() {
                                            sortingData = true;
                                          });
                                        },
                                        child: Container(
                                          alignment: Alignment.center,
                                          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                                          decoration: BoxDecoration(
                                            color: Colors.red,
                                            border: Border.all(color: Colors.red, width: 2),
                                            borderRadius: BorderRadius.circular(15),
                                          ),
                                          child: const Text(
                                            'Proceed Anyway',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w800,
                                                fontSize: 16,
                                                color: Colors.white
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      InkWell(
                                        onTap: () async {
                                          Navigator.of(context).pop();
                                        },
                                        child: Container(
                                          alignment: Alignment.center,
                                          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                                          decoration: BoxDecoration(
                                            border: Border.all(color: Colors.red, width: 2),
                                            borderRadius: BorderRadius.circular(15),
                                          ),
                                          child: const Text(
                                            "Cancel",
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.red,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              )
                          );
                        }
                        else {
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

                      }
                      else if(value == 'live') {
                        // setState(() {
                        //   sortingData = true;
                        // });
                        await getData(widget.gameID);
                        print(_game!.liveStreamActive);
                        if(_game!.liveStreamActive == 'true') {
                          showDialog<String>(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) => AlertDialog(
                                contentPadding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                                actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 15),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                title: Text(
                                  'Live stream in progress',
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                content: SizedBox(
                                  height: MediaQuery.of(context).size.height * 0.25,
                                  child: Column(
                                    children: [
                                      Image(
                                        image: const AssetImage('assets/notification.png'),
                                        fit: BoxFit.fitWidth,
                                        width: MediaQuery.of(context).size.width * 0.45,
                                        height: MediaQuery.of(context).size.width * 0.3,
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        "There is already a live stream for this game in progress. You must end the current live stream before beginning a new one.",
                                        style: GoogleFonts.inter(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                actions: <Widget>[
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      InkWell(
                                        onTap: () async {
                                          Navigator.of(context).pop();
                                        },
                                        child: Container(
                                          alignment: Alignment.center,
                                          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                                          decoration: BoxDecoration(
                                            color: Colors.red,
                                            border: Border.all(color: Colors.red, width: 2),
                                            borderRadius: BorderRadius.circular(15),
                                          ),
                                          child: const Text(
                                            'OK',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w800,
                                                fontSize: 16,
                                                color: Colors.white
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              )
                          );
                        }
                        else if(DateTime.parse(_game!.date).difference(DateTime.now()) > const Duration(minutes: 30) || _game!.gameDone == 'true') {
                          showDialog<String>(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) => AlertDialog(
                                contentPadding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                                actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 15),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                title: Text(
                                  _game!.gameDone == 'true' ? 'The game is over!' : "It's not game time.",
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                content: SizedBox(
                                  height: MediaQuery.of(context).size.height * 0.25,
                                  child: Column(
                                    children: [
                                      Image(
                                        image: const AssetImage('assets/notification.png'),
                                        fit: BoxFit.fitWidth,
                                        width: MediaQuery.of(context).size.width * 0.45,
                                        height: MediaQuery.of(context).size.width * 0.3,
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        "Live streams for games can only occur 30 minutes before the game start time and until the final score is reported.",
                                        style: GoogleFonts.inter(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                actions: <Widget>[
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      InkWell(
                                        onTap: () async {
                                          Navigator.of(context).pop();
                                        },
                                        child: Container(
                                          alignment: Alignment.center,
                                          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                                          decoration: BoxDecoration(
                                            color: Colors.red,
                                            border: Border.all(color: Colors.red, width: 2),
                                            borderRadius: BorderRadius.circular(15),
                                          ),
                                          child: const Text(
                                            'OK',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w800,
                                                fontSize: 16,
                                                color: Colors.white
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              )
                          );
                        }
                        else {
                          final database = context.read<FirestoreDatabase>(databaseProvider);
                          database.setLive(_game!.id, 'true');
                          await database.resetLiveUserCount(_game!.id);
                          showDialog<String>(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) => AlertDialog(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                              actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 15),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              title: Text(
                                'Notify Users',
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              content: SizedBox(
                                height: MediaQuery.of(context).size.height * 0.25,
                                child: Column(
                                  children: [
                                    Image(
                                      image: const AssetImage('assets/notification.png'),
                                      fit: BoxFit.fitWidth,
                                      width: MediaQuery.of(context).size.width * 0.45,
                                      height: MediaQuery.of(context).size.width * 0.3,
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      "Would you like to send an alert to all users that 'Park Tudor vs. ${_game!.opponentName}' is going live?",
                                      style: GoogleFonts.inter(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              actions: <Widget>[
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    InkWell(
                                      onTap: () async {
                                        sendCustomNotification('LIVE: Park Tudor v.s. ${_game!.opponentName}',
                                            'The score is currently ${_game!.homeScore == '' ? '0' : _game!.homeScore}-${_game!.opponentScore == '' ? '0' : _game!.opponentScore}. Watch now to see live game updates!');
                                        Navigator.of(context).pop();
                                        return onJoin(isBroadcaster: true, channelName: _game!.id, gameID: _game!.id);
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          border: Border.all(color: Colors.red, width: 2),
                                          borderRadius: BorderRadius.circular(15),
                                        ),
                                        child: const Text(
                                          'Send Notification',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize: 16,
                                              color: Colors.white
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    InkWell(
                                      onTap: () async {
                                        Navigator.of(context).pop();
                                        return onJoin(isBroadcaster: true, channelName: _game!.id, gameID: _game!.id);
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                                        decoration: BoxDecoration(
                                          border: Border.all(color: Colors.red, width: 2),
                                          borderRadius: BorderRadius.circular(15),
                                        ),
                                        child: const Text(
                                          "Don't send notification",
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.red,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          );
                        }
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
      body: RefreshIndicator(
        onRefresh: refresh,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              () {
                if(_game!.liveStreamActive == 'true') {
                  return InkWell(
                    onTap: () {
                      onJoin(channelName: _game!.id, isBroadcaster: false, gameID: _game!.id);
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 40,
                      color: Colors.red,
                      child: Center(
                        child: Text(
                          '• Join Live Stream',
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  );
                }
                return const SizedBox(height: 0);
              }(),
              GameInfoCard(game: _game!),
              const Divider(
                height: 0,
                thickness: 0.4,
                color: Colors.grey,
              ),
              const SizedBox(height: 12), //15
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Location & Date',
                      style: GoogleFonts.inter(
                        color: Colors.black,
                        fontWeight: FontWeight.w800,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 6),
                    ListTile(
                      dense:true,
                      visualDensity: const VisualDensity(vertical: 0),
                      contentPadding: EdgeInsets.zero,
                      minVerticalPadding: 0,
                      horizontalTitleGap: 0,
                      leading: Icon(
                        Icons.location_pin,
                        color: Colors.grey.withOpacity(0.75),
                        size: 26,
                      ),
                      // title: const Text(
                      //   'Location',
                      //   style: TextStyle(
                      //       fontSize: 16,
                      //       fontWeight: FontWeight.w600,
                      //       color: Colors.black
                      //   ),
                      // ),
                      title: Text(
                        _event!.location,
                        style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.black
                        ),
                      ),
                    ),
                    // const Divider(
                    //   height: 0,
                    //   thickness: 0.75,
                    // ),
                    ListTile(
                      dense:true,
                      visualDensity: const VisualDensity(vertical: 0),
                      contentPadding: EdgeInsets.zero,
                      minVerticalPadding: 0,
                      horizontalTitleGap: 0,
                      leading: Icon(
                        Icons.access_time_filled_rounded,
                        color: Colors.grey.withOpacity(0.7),
                        size: 25,
                      ),
                      // title: const Text(
                      //   'Date',
                      //   style: TextStyle(
                      //       fontSize: 16,
                      //       fontWeight: FontWeight.w600,
                      //       color: Colors.black
                      //   ),
                      // ),
                      title: Text(
                        '${DateFormat.yMMMMEEEEd().format(DateTime.parse(_event!.date))} at ${DateFormat.jm().format(DateTime.parse(_event!.date))}',
                        style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Divider(
                      height: 0,
                      thickness: 0.4,
                      color: Colors.grey,
                    ),
                    () {
                      if(_event!.description != '') {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 12),
                            Text(
                              'About this event',
                              style: GoogleFonts.inter(
                                color: Colors.black,
                                fontWeight: FontWeight.w800,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              _event!.description,
                              style: GoogleFonts.inter(
                                height: 1.3,
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 15),
                            const Divider(
                              height: 0,
                              thickness: 0.4,
                              color: Colors.grey,
                            ),
                          ],
                        );
                      }
                      return const SizedBox(height: 0);
                    }(),
                    const SizedBox(height: 12),
                    Text(
                      'Group',
                      style: GoogleFonts.inter(
                        color: Colors.black,
                        fontWeight: FontWeight.w800,
                        fontSize: 18,
                      ),
                    ),
                    // const SizedBox(height: 5),
                    ListTile(
                      onTap: () {
                        Navigator.of(context, rootNavigator: true).pushNamed(
                            AppRoutes.sportsProfileView,
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
                        style: GoogleFonts.inter(
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
                height: 0,
                thickness: 0.4,
                color: Colors.grey,
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Text(
                  'Game Updates',
                  style: GoogleFonts.inter(
                    color: Colors.black,
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                  ),
                ),
              ),
              NewsVerticalScrollWidget(user: widget.user, gameID: _game!.id),
              const SizedBox(height: 200),
            ],
          ),
        ),
      ),
    );
  }
  Future<void> onJoin({required String channelName, required bool isBroadcaster, required String gameID}) async {
    await [Permission.camera, Permission.microphone].request();

    await Navigator.of(context, rootNavigator: true).pushNamed(
        AppRoutes.liveStreamView,
        arguments: {
          'channelName': channelName,
          'isBroadcaster': isBroadcaster,
          'gameID': gameID,
          'event': _event!,
          'groupLogoURL': _event!.groupImageURL,
        }
    );
    setState(() {
      sortingData = true;
    });
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
