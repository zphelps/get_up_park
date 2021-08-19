import 'dart:async';

import 'package:agora_rtc_engine/rtc_channel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
import 'package:get_up_park/app/home/events/event_model.dart';
import 'package:get_up_park/app/home/sports/game_model.dart';
import 'package:get_up_park/app/home/sports/live_stream/appId.dart';
import 'package:get_up_park/app/home/sports/live_stream/broadcast_overlay.dart';
import 'package:get_up_park/app/home/sports/update_game/update_game_score_view.dart';
import 'package:get_up_park/app/top_level_providers.dart';
import 'package:get_up_park/services/firestore_database.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class BroadcastPage extends StatefulWidget {
  final String channelName;
  final bool isBroadcaster;
  final String gameID;
  final String groupLogoURL;
  final Event event;

  const BroadcastPage({required this.channelName, required this.isBroadcaster, required this.gameID, required this.groupLogoURL, required this.event});

  @override
  _BroadcastPageState createState() => _BroadcastPageState();
}

class _BroadcastPageState extends State<BroadcastPage> {
  final _users = <int>[];
  late RtcEngine _engine;
  bool muted = false;
  late int streamId;

  @override
  void dispose() {
    // clear users
    _users.clear();
    // destroy sdk and leave channel
    _engine.destroy();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // initialize agora sdk
    initializeAgora();
  }

  Future<void> initializeAgora() async {
    await _initAgoraRtcEngine();

    if (widget.isBroadcaster) streamId = (await _engine.createDataStream(false, false))!;

    _engine.setEventHandler(RtcEngineEventHandler(
      joinChannelSuccess: (channel, uid, elapsed) {
        setState(() {
          print('onJoinChannel: $channel, uid: $uid');
        });
      },
      leaveChannel: (stats) {
        setState(() {
          print('onLeaveChannel');
          _users.clear();
        });
      },
      userJoined: (uid, elapsed) async {
        setState(() {
          print('userJoined: $uid');
          _users.add(uid);
        });
        final database = context.read<FirestoreDatabase>(databaseProvider);
        await database.addLiveUser(widget.gameID);
      },
      userOffline: (uid, elapsed) {
        setState(() {
          print('userOffline: $uid');
          _users.remove(uid);
        });
        // final database = context.read<FirestoreDatabase>(databaseProvider);
        // await database.removeLiveUser(widget.gameID);
      },
      streamMessage: (_, __, message) {
        final String info = "here is the message $message";
        print(info);
      },
      streamMessageError: (_, __, error, ___, ____) {
        final String info = "here is the error $error";
        print(info);
      },
    ));

    await _engine.joinChannel(null, widget.channelName, null, 0);
  }

  Future<void> _initAgoraRtcEngine() async {
    _engine = await RtcEngine.create(appId);
    await _engine.enableVideo();

    await _engine.setChannelProfile(ChannelProfile.LiveBroadcasting);
    if (widget.isBroadcaster) {
      await _engine.setClientRole(ClientRole.Broadcaster);
    } else {
      await _engine.setClientRole(ClientRole.Audience);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Stack(
          children: <Widget>[
            Center(
              child: Text(
                'No connection',
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
            ),
            _broadcastView(),
            _toolbar(),
            widget.isBroadcaster ? const SizedBox(width: 0) : Positioned(
              top: 40,
              left: 5,
              child: IconButton(
                onPressed: () async {
                  final database = context.read<FirestoreDatabase>(databaseProvider);
                  await database.removeLiveUser(widget.gameID);
                  Navigator.of(context).pop();
                },
                icon: const Icon(
                  Icons.clear,
                  size: 30,
                  color: Colors.white,
                ),
              ),
            ),
            Positioned(
              top: 45,
              right: 20,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.red.withOpacity(0.85),
                ),
                child: Text(
                  '• Live',
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            ),
            Positioned(
                top: 45,
                right: 90,
                child: UserCountOverlay(gameID: widget.gameID),
            ),
            Positioned(
              left: 0,
              bottom: widget.isBroadcaster ? 115 : 30,
              child: GameScoreOverlay(gameID: widget.gameID, isBroadcaster: widget.isBroadcaster, event: widget.event)
            ),
          ],
        ),
      ),
    );
  }

  Widget _toolbar() {
    return widget.isBroadcaster
        ? Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RawMaterialButton(
            onPressed: _onToggleMute,
            child: Icon(
              muted ? Icons.mic_off : Icons.mic,
              color: muted ? Colors.white : Colors.blueAccent,
              size: 20.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: muted ? Colors.blueAccent : Colors.white,
            padding: const EdgeInsets.all(12.0),
          ),
          RawMaterialButton(
            onPressed: () => _onCallEnd(context),
            child: Text(
              'End Live Stream',
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            elevation: 2.0,
            fillColor: Colors.red,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          ),
          RawMaterialButton(
            onPressed: _onSwitchCamera,
            child: Icon(
              Icons.switch_camera,
              color: Colors.blueAccent,
              size: 20.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.white,
            padding: const EdgeInsets.all(12.0),
          ),
        ],
      ),
    )
        : Container();
  }

  /// Helper function to get list of native views
  List<Widget> _getRenderViews() {
    final List<StatefulWidget> list = [];
    if (widget.isBroadcaster) {
      list.add(RtcLocalView.SurfaceView());
    }
    _users.forEach((int uid) => list.add(RtcRemoteView.SurfaceView(uid: uid)));
    return list;
  }

  /// Video view row wrapper
  Widget _expandedVideoView(List<Widget> views) {
    final wrappedViews = views.map<Widget>((view) => Expanded(child: Container(child: view))).toList();
    return Expanded(
      child: Row(
        children: wrappedViews,
      ),
    );
  }

  /// Video layout wrapper
  Widget _broadcastView() {
    final views = _getRenderViews();
    switch (views.length) {
      case 1:
        return Container(
            child: Column(
              children: <Widget>[
                _expandedVideoView([views[0]])
              ],
            ));
      case 2:
        return Container(
            child: Column(
              children: <Widget>[
                _expandedVideoView([views[0]]),
                _expandedVideoView([views[1]])
              ],
            ));
      case 3:
        return Container(
            child: Column(
              children: <Widget>[_expandedVideoView(views.sublist(0, 2)), _expandedVideoView(views.sublist(2, 3))],
            ));
      case 4:
        return Container(
            child: Column(
              children: <Widget>[_expandedVideoView(views.sublist(0, 2)), _expandedVideoView(views.sublist(2, 4))],
            ));
      default:
    }
    return Container();
  }

  Future<void> _onCallEnd(BuildContext context) async {
    final database = context.read<FirestoreDatabase>(databaseProvider);
    await database.setLive(widget.channelName, 'false');
    await database.resetLiveUserCount(widget.gameID);
    Navigator.pop(context);
  }

  void _onToggleMute() {
    setState(() {
      muted = !muted;
    });
    _engine.muteLocalAudioStream(muted);
  }

  void _onSwitchCamera() {
    if (streamId != null) _engine.sendStreamMessage(streamId, "mute user blet");
    _engine.switchCamera();
  }
}
