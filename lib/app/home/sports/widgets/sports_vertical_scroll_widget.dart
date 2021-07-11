import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_up_park/app/home/groups/group_model.dart';
import 'package:get_up_park/app/home/sports/cards/sport_preview_card.dart';
import 'package:get_up_park/app/home/sports/game_model.dart';
import 'package:get_up_park/app/home/sports/widgets/game_schedule_list_widget.dart';
import 'package:get_up_park/constants/all_sports.dart';
import 'package:get_up_park/shared_widgets/loading.dart';
import 'package:get_up_park/app/top_level_providers.dart';

final groupsStreamProvider = StreamProvider.autoDispose<List<Group>>((ref) {
  final database = ref.watch(databaseProvider);
  return database.groupsStream();
});

final gamesStreamProvider = StreamProvider.autoDispose<List<Game>>((ref) {
  final database = ref.watch(databaseProvider);
  return database.gamesStream();
});


// watch database
class SportsVerticalScrollWidget extends ConsumerWidget {

  SportsVerticalScrollWidget({this.sport = 'all', this.groupName = 'none', required this.admin, this.selectGame = false, this.selectedGroup = ''});

  final String sport;
  final String groupName;
  final String admin;
  final bool selectGame;
  final String selectedGroup;

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final groupAsyncValue = watch(groupsStreamProvider);
    final gamesAsyncValue = watch(gamesStreamProvider);
    return LoadSportsView(groupAsyncValue: groupAsyncValue, gamesAsyncValue: gamesAsyncValue, groupName: groupName, sport: sport, admin: admin, selectGame: selectGame, selectedGroup: selectedGroup);
  }

}

class LoadSportsView extends StatefulWidget {
  const LoadSportsView({required this.groupAsyncValue, required this.gamesAsyncValue, required this.groupName, required this.sport, required this.admin, required this.selectGame, required this.selectedGroup});

  final AsyncValue<List<Group>> groupAsyncValue;
  final AsyncValue<List<Game>> gamesAsyncValue;
  final String groupName;
  final String admin;
  final String sport;
  final bool selectGame;
  final String selectedGroup;

  @override
  _LoadSportsViewState createState() => _LoadSportsViewState();
}

class _LoadSportsViewState extends State<LoadSportsView> {

  bool loadingData = true;

  Timer? _timer;

  List<Group> allGroups = [];

  List<Game> allGames = [];

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _timer!.cancel();
  }
  @override
  Widget build(BuildContext context) {

    widget.groupAsyncValue.whenData((groups) {
      widget.gamesAsyncValue.whenData((games) {
        if(allGroups.length != groups.length || games != allGames) {
          setState(() {
            allGroups = groups;
            allGames = games;
          });
          _timer = Timer(const Duration(milliseconds: 250), () {
            setState(() {
              loadingData = false;
            });
          });
        }
      });
    });

    if (loadingData) {
      return const LoadingGroupsScroll();
    }
    return ListView.builder(
        itemCount: allGroups.length,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        itemBuilder: (context, index) {
          if (widget.sport == 'all') {
            if (AllSports.list.contains(allGroups[index].sport) && widget.selectGame && allGroups[index].name == widget.selectedGroup) {
              return GameScheduleListWidget(group: allGroups[index], groupName: allGroups[index].name, admin: widget.admin, selectGame: widget.selectGame);
            }
            else if (AllSports.list.contains(allGroups[index].sport) && !widget.selectGame) {
              return SportPreviewCard(
                  group: allGroups[index], admin: widget.admin);
            }
          }
          else {
            if (allGroups[index].sport == widget.sport && widget.selectGame && allGroups[index].name == widget.selectedGroup) {
              return GameScheduleListWidget(group: allGroups[index], groupName: allGroups[index].name, admin: widget.admin, selectGame: widget.selectGame);
            }
            else if (allGroups[index].sport == widget.sport && !widget.selectGame) {
              return SportPreviewCard(
                  group: allGroups[index], admin: widget.admin);
            }
          }
          return const SizedBox(height: 0);
        }
    );
  }
}
